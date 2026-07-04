# Exemplos de Uso - Kali Linux Optimization Script

## 📌 Casos de Uso Comuns

### 1. Execução Padrão (Completa)

Executar todas as 6 fases com confirmações interativas:

```bash
sudo ./kali-optimize-advanced.sh
```

### 2. Modo Simulação (Seguro)

Ver o que seria feito sem alterar nada:

```bash
sudo DRY_RUN=true ./kali-optimize-advanced.sh
```

### 3. Pular Reinicialização

Executar todas as fases mas não reiniciar ao final:

```bash
sudo SKIP_REBOOT=true ./kali-optimize-advanced.sh
```

### 4. Pular Instalação de Firmware

Útil se você já tem drivers instalados:

```bash
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh
```

### 5. Combinando Múltiplas Opções

```bash
sudo SKIP_FIRMWARE=true SKIP_REBOOT=true ./kali-optimize-advanced.sh
```

---

## 🌐 Cenários por Tipo de Hardware

### Laptop com WiFi Broadcom

```bash
# Instalar driver Broadcom e otimizar
sudo ./kali-optimize-advanced.sh
# Responder 's' quando perguntado sobre driver Broadcom
# Reiniciar após conclusão
```

### Desktop com Conexão Cabeada

```bash
# Pular verificações de WiFi, mas fazer limpeza completa
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh
```

### Máquina Virtual (VMware/VirtualBox)

```bash
# Pular hardware drivers, focar em performance
sudo DRY_RUN=true ./kali-optimize-advanced.sh  # Testar antes
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh
```

### Sistema com Pouca RAM (<4GB)

```bash
# Executar limpeza agressiva e ativar swap
sudo ./kali-optimize-advanced.sh
# Depois instalar zram-tools:
sudo apt install zram-tools
```

---

## 🔧 Troubleshooting

### Cenário 1: Erro ao instalar firmware

```bash
# Opção 1: Pular firmware
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh

# Opção 2: Modo simulação para verificar
sudo DRY_RUN=true ./kali-optimize-advanced.sh

# Opção 3: Instalar manualmente depois
sudo apt install -y firmware-linux firmware-linux-nonfree
```

### Cenário 2: Sem espaço em disco

```bash
# Verificar espaço
df -h

# Liberar espaço manualmente
sudo apt clean
sudo apt autoclean
sudo apt autoremove

# Depois executar o script
sudo ./kali-optimize-advanced.sh
```

### Cenário 3: NetworkManager não inicia

```bash
# Verificar status
sudo systemctl status NetworkManager

# Reiniciar manualmente
sudo systemctl restart NetworkManager

# Se continuar com problema, pular essa fase
sudo DRY_RUN=true ./kali-optimize-advanced.sh
```

### Cenário 4: Sem conexão de internet

```bash
# Se não conseguir conectar:
# 1. Verificar interfaces
ip link show

# 2. Tentar conectar manualmente
sudo nmcli dev wifi list
sudo nmcli dev wifi connect "SSID" password "PASSWORD"

# 3. Testar conexão
ping 8.8.8.8

# 4. Depois executar script
sudo ./kali-optimize-advanced.sh
```

---

## 📊 Monitoramento Durante Execução

### Terminal 1: Executar script

```bash
sudo ./kali-optimize-advanced.sh
```

### Terminal 2: Monitorar resources

```bash
# CPU e memória em tempo real
watch -n 1 free -h

# Ou usar top/htop
top
htop
```

### Terminal 3: Ver logs

```bash
# Ver em tempo real
tail -f /var/log/kali-optimize-*.log

# Ou pesquisar por erros
grep ERROR /var/log/kali-optimize-*.log
```

---

## 🚀 Automação com Cron

### Executar semanalmente

```bash
# Editar crontab
sudo crontab -e

# Adicionar esta linha (domingo às 2 AM)
0 2 * * 0 /home/user/kali-optimize-advanced/kali-optimize-advanced.sh >> /var/log/kali-optimize-cron.log 2>&1
```

### Executar com tempo limite

```bash
# Com timeout de 1 hora
sudo timeout 3600 ./kali-optimize-advanced.sh
```

---

## 📋 Checklist de Segurança

Antes de executar:

- [ ] Fazer backup de dados importantes
- [ ] Testar em VM se possível
- [ ] Ter acesso sudo/root
- [ ] Conexão de internet estável
- [ ] Pelo menos 2GB de espaço livre em /
- [ ] Bateria carregada (se laptop)
- [ ] Ninguém usando o sistema
- [ ] Ter acesso ao terminal de recuperação

---

## 💡 Dicas Profissionais

### Tip 1: Verificar compatibilidade

```bash
# Antes de executar, verificar se é Kali Linux
grep VERSION_ID /etc/os-release

# Ou
lsb_release -a
```

### Tip 2: Ter rollback plan

```bash
# Snapshot de VM antes de executar
vboxmanage snapshot "Kali VM" take "before-optimization"

# Se algo der errado
vboxmanage snapshot "Kali VM" restore "before-optimization"
```

### Tip 3: Customizar para seu ambiente

```bash
# Editar config
sudo nano config/kali-optimize.conf

# Depois executar
sudo ./kali-optimize-advanced.sh
```

### Tip 4: Logs para análise

```bash
# Guardar logs depois de executar
cp /var/log/kali-optimize-*.log ~/backups/

# Analisar problemas
less ~/backups/kali-optimize-*.log
```

### Tip 5: Teste antes em modo simulação

```bash
# Sempre testar:
sudo DRY_RUN=true ./kali-optimize-advanced.sh

# Se tudo OK, executar para real:
sudo ./kali-optimize-advanced.sh
```

---

## 🎯 Resultados Esperados

Após executar o script, você deve ver:

✅ Sistema mais responsivo  
✅ Menos arquivos temporários  
✅ Firmware/drivers corretos instalados  
✅ Espaço em disco liberado  
✅ Logs limpanizados  
✅ Performance otimizada  
✅ Sem erros de dependências  

---

## 📞 Suporte

Se tiver problemas:

1. Verificar o log: `cat /var/log/kali-optimize-*.log`
2. Procurar por "ERROR" ou "FALHA"
3. Abrir uma issue no GitHub
4. Incluir:
   - Versão Kali Linux
   - Hardware (VM ou físico)
   - Log completo
   - Passos para reproduzir

---

**Última atualização**: 2026-07-04
