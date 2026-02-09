#!/bin/bash

# ====================================================
# Script Avançado de Otimização e Manutenção do Kali Linux
# Inclui diagnóstico e correção de drivers de rede/Wi-Fi
# ====================================================

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
LOG_FILE="/var/log/kali-optimize-$(date +%Y%m%d-%H%M%S).log"
FW_PACKAGES="firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-atheros firmware-brcm80211"

# Função para logging
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Função para verificar se é root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log "${RED}[ERRO] Este script deve ser executado como root/sudo${NC}"
        exit 1
    fi
}

# Função para exibir mensagens
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
    log "[*] $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
    log "[+] $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    log "[!] $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
    log "[-] $1"
}

# Função para detectar hardware de rede
detect_network_hardware() {
    print_status "Realizando diagnóstico de hardware de rede..."

    # Detectar placas PCI/PCIe
    local pci_devices=$(lspci -nnk 2>/dev/null | grep -i -A2 "network\|ethernet\|wireless")
    if [ -n "$pci_devices" ]; then
        print_status "Dispositivos de rede PCI/PCIe:"
        echo "$pci_devices"
        log "Dispositivos PCI: $pci_devices"
    else
        print_warning "Nenhum dispositivo de rede PCI/PCIe detectado."
    fi

    # Detectar adaptadores USB
    local usb_devices=$(lsusb 2>/dev/null | grep -i "network\|ethernet\|wireless")
    if [ -n "$usb_devices" ]; then
        print_status "Dispositivos de rede USB:"
        echo "$usb_devices"
        log "Dispositivos USB: $usb_devices"
    else
        print_warning "Nenhum dispositivo de rede USB detectado."
    fi

    # Verificar interfaces de rede ativas
    print_status "Interfaces de rede ativas:"
    ip -brief link show | while read line; do
        echo "  $line"
        log "Interface: $line"
    done

    # Verificar bloqueio rfkill (para Wi-Fi)
    if command -v rfkill &> /dev/null; then
        local rfkill_list=$(rfkill list)
        if [ -n "$rfkill_list" ]; then
            print_status "Status de bloqueio rfkill (Wi-Fi/Bluetooth):"
            echo "$rfkill_list"
            log "rfkill: $rfkill_list"
        fi
    fi
}

# Função para verificar e instalar firmware
install_firmware() {
    print_status "Verificando pacotes de firmware recomendados..."

    # Listar pacotes de firmware disponíveis
    local missing_fw=""
    for pkg in $FW_PACKAGES; do
        if ! dpkg -l | grep -q "^ii  $pkg"; then
            missing_fw+=" $pkg"
        fi
    done

    if [ -n "$missing_fw" ]; then
        print_warning "Pacotes de firmware recomendados não instalados:$missing_fw"
        read -p "Deseja instalar os pacotes de firmware recomendados? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            print_status "Instalando pacotes de firmware..."
            apt install -y $missing_fw 2>&1 | tee -a "$LOG_FILE"
            if [ ${PIPESTATUS[0]} -eq 0 ]; then
                print_success "Pacotes de firmware instalados com sucesso."
            else
                print_error "Falha ao instalar alguns pacotes de firmware."
            fi
        else
            print_warning "Instalação de firmware ignorada pelo usuário."
        fi
    else
        print_success "Todos os pacotes de firmware recomendados já estão instalados."
    fi
}

# Função para detectar e tratar drivers Broadcom
handle_broadcom_drivers() {
    # Verificar se há hardware Broadcom
    if lspci -nn 2>/dev/null | grep -qi "broadcom.*wireless"; then
        print_warning "Hardware Broadcom detectado. Drivers proprietários podem ser necessários."

        # Verificar se o driver bcmwl-kernel-source está instalado
        if ! dpkg -l | grep -q "^ii  bcmwl-kernel-source"; then
            read -p "Deseja instalar o driver proprietário Broadcom (bcmwl-kernel-source)? (s/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                print_status "Instalando driver Broadcom..."
                apt install -y bcmwl-kernel-source 2>&1 | tee -a "$LOG_FILE"
                if [ ${PIPESTATUS[0]} -eq 0 ]; then
                    print_success "Driver Broadcom instalado com sucesso."
                    print_warning "Reinicie o sistema para carregar o driver."
                else
                    print_error "Falha ao instalar o driver Broadcom."
                fi
            fi
        else
            print_success "Driver Broadcom já está instalado."
        fi
    fi
}

# Função para verificar e corrigir problemas de interface
check_network_interfaces() {
    print_status "Verificando configuração de interfaces de rede..."

    # Verificar se há interfaces em estado DOWN
    local down_interfaces=$(ip link show | grep -E "^[0-9]+:" | grep -v "LOOPBACK" | awk -F: '{print $2}' | xargs -I {} sh -c 'if ip link show {} | grep -q "state DOWN"; then echo {}; fi')

    for iface in $down_interfaces; do
        print_warning "Interface $iface está DOWN."
        read -p "Deseja ativar a interface $iface? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            ip link set $iface up 2>&1 | tee -a "$LOG_FILE"
            if [ ${PIPESTATUS[0]} -eq 0 ]; then
                print_success "Interface $iface ativada."
            else
                print_error "Falha ao ativar $iface."
            fi
        fi
    done

    # Verificar se o serviço NetworkManager está ativo
    if systemctl is-active --quiet NetworkManager 2>/dev/null; then
        print_success "NetworkManager está em execução."
    else
        print_warning "NetworkManager não está em execução."
        read -p "Deseja iniciar o NetworkManager? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            systemctl start NetworkManager 2>&1 | tee -a "$LOG_FILE"
            systemctl enable NetworkManager 2>&1 | tee -a "$LOG_FILE"
        fi
    fi
}

# Função principal
main() {
    clear
    echo "===================================================="
    echo "  Kali Linux Optimization Script - Edição Avançada"
    echo "  Log: $LOG_FILE"
    echo "===================================================="
    echo ""
    
    check_root
    
    # Início do log
    log "Início da execução do script de otimização."
    
    # Fase 1: Diagnóstico de rede
    echo "==================== FASE 1: DIAGNÓSTICO DE REDE ===================="
    detect_network_hardware
    install_firmware
    handle_broadcom_drivers
    check_network_interfaces
    
    # Fase 2: Atualização do sistema
    echo ""
    echo "==================== FASE 2: ATUALIZAÇÃO DO SISTEMA ===================="
    print_status "Atualizando repositórios..."
    apt update 2>&1 | tee -a "$LOG_FILE"
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        print_success "Repositórios atualizados"
    else
        print_error "Falha ao atualizar repositórios"
        # Não sai, continua tentando
    fi
    
    print_status "Atualizando sistema completo..."
    apt full-upgrade -y 2>&1 | tee -a "$LOG_FILE"
    apt dist-upgrade -y 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Atualizando ferramentas do Kali..."
    apt install -y kali-linux-core kali-tools-top10 2>&1 | tee -a "$LOG_FILE"
    
    # Fase 3: Correção de problemas
    echo ""
    echo "==================== FASE 3: CORREÇÃO DE PROBLEMAS ===================="
    print_status "Corrigindo dependências quebradas..."
    apt --fix-broken install -y 2>&1 | tee -a "$LOG_FILE"
    dpkg --configure -a 2>&1 | tee -a "$LOG_FILE"
    
    # Fase 4: Limpeza
    echo ""
    echo "==================== FASE 4: LIMPEZA ===================="
    print_status "Limpando cache do apt..."
    apt clean 2>&1 | tee -a "$LOG_FILE"
    apt autoclean 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Removendo pacotes não necessários..."
    apt autoremove -y 2>&1 | tee -a "$LOG_FILE"
    apt autopurge -y 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Limpando arquivos temporários..."
    rm -rf /tmp/* 2>&1 | tee -a "$LOG_FILE"
    rm -rf /var/tmp/* 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Limpando cache de thumbnails..."
    rm -rf ~/.cache/thumbnails/* 2>&1 | tee -a "$LOG_FILE"
    rm -rf /root/.cache/thumbnails/* 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Limpando logs antigos..."
    journalctl --vacuum-time=3d 2>&1 | tee -a "$LOG_FILE"
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \; 2>&1 | tee -a "$LOG_FILE"
    
    print_status "Otimizando banco de dados do apt..."
    if command -v deborphan >/dev/null 2>&1; then
        deborphan | xargs apt-get -y remove --purge 2>&1 | tee -a "$LOG_FILE"
    else
        apt install -y deborphan 2>&1 | tee -a "$LOG_FILE"
        deborphan | xargs apt-get -y remove --purge 2>&1 | tee -a "$LOG_FILE"
    fi
    
    # Fase 5: Otimização
    echo ""
    echo "==================== FASE 5: OTIMIZAÇÃO ===================="
    print_status "Verificando integridade do sistema..."
    if command -v debsums >/dev/null 2>&1; then
        debsums -c 2>&1 | head -50 | tee -a "$LOG_FILE"
        print_warning "Apenas os primeiros 50 erros de debsums são mostrados."
    else
        apt install -y debsums 2>&1 | tee -a "$LOG_FILE"
        debsums -c 2>&1 | head -50 | tee -a "$LOG_FILE"
    fi
    
    print_status "Otimizando configurações de performance..."
    
    # Ajustar swappiness (se for menor que 10GB de RAM)
    MEM=$(free -g | awk '/^Mem:/{print $2}')
    if [ $MEM -lt 10 ]; then
        sysctl vm.swappiness=10 2>&1 | tee -a "$LOG_FILE"
        if grep -q "vm.swappiness" /etc/sysctl.conf; then
            sed -i 's/^vm.swappiness=.*/vm.swappiness=10/' /etc/sysctl.conf
        else
            echo "vm.swappiness=10" >> /etc/sysctl.conf
        fi
        print_success "Swappiness ajustado para 10 (RAM detectada: ${MEM}GB)."
    fi
    
    # Limpar memória cache (opcional - use com cuidado)
    read -p "Deseja limpar a memória cache? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sync
        echo 3 > /proc/sys/vm/drop_caches 2>&1 | tee -a "$LOG_FILE"
        print_success "Cache de memória limpo."
    fi
    
    # Atualizar ferramentas do exploitdb
    print_status "Atualizando exploitdb..."
    if command -v searchsploit &> /dev/null; then
        searchsploit -u 2>&1 | tee -a "$LOG_FILE"
    fi
    
    # Finalização
    echo ""
    echo "==================== FASE 6: FINALIZAÇÃO ===================="
    print_status "Executando verificações finais..."
    
    # Verificar espaço livre
    echo ""
    print_status "Espaço em disco após limpeza:"
    df -h / 2>&1 | tee -a "$LOG_FILE"
    
    # Verificar atualizações pendentes
    echo ""
    print_status "Verificando atualizações pendentes..."
    apt list --upgradable 2>/dev/null | tee -a "$LOG_FILE"
    
    # Resumo de rede
    echo ""
    print_status "Resumo do estado de rede:"
    ip -brief address 2>&1 | tee -a "$LOG_FILE"
    
    # Sugestões
    echo ""
    print_warning "SUGESTÕES ADICIONAIS:"
    echo "1. Execute manualmente: kali-tweaks para ajustes específicos"
    echo "2. Configure o zram se tiver pouca RAM: apt install zram-tools"
    echo "3. Considere usar preload: apt install preload"
    echo "4. Para laptops: apt install tlp tlp-rdw"
    echo "5. Execute regularmente: apt update && apt upgrade"
    echo "6. Consulte o log completo em: $LOG_FILE"
    
    echo ""
    print_success "Otimização completa!"
    print_warning "Recomenda-se reiniciar o sistema para aplicar todas as alterações"
    
    log "Execução do script concluída com sucesso."
    
    read -p "Deseja reiniciar agora? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        log "Reinicialização solicitada pelo usuário."
        reboot
    fi
}

# Tratamento de sinais
trap 'print_error "Script interrompido pelo usuário"; log "Script interrompido pelo usuário"; exit 1' INT TERM

# Executar função principal
main "$@"
