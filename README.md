# Kali Linux Optimization Script - Advanced Edition

> Script avançado de otimização e manutenção para Kali Linux com diagnóstico completo de rede/Wi-Fi

## 📋 Características

- **Fase 1**: Diagnóstico completo de hardware de rede (PCI/PCIe, USB, interfaces)
- **Fase 2**: Atualização completa do sistema e ferramentas Kali
- **Fase 3**: Correção de dependências quebradas
- **Fase 4**: Limpeza profunda (cache, logs, temporários)
- **Fase 5**: Otimizações de performance (memória, swappiness, deborphan)
- **Fase 6**: Verificações finais e sugestões adicionais

## ⚠️ Avisos Importantes

- **Executar como root**: O script requer privilégios administrativos
- **Fazer backup**: Recomenda-se fazer backup de configurações críticas antes de executar
- **Testar em VM**: Teste em uma máquina virtual antes de usar em produção
- **Não é reversível**: Algumas operações (limpeza de logs) não podem ser revertidas
- **Conexão de internet**: Necessário para atualizar repositórios e pacotes

## 🚀 Instalação Rápida

```bash
# Clonar repositório
git clone https://github.com/deuzimar700569/kali-optimize-advanced.git
cd kali-optimize-advanced

# Dar permissão de execução
chmod +x kali-optimize-advanced.sh

# Executar com sudo
sudo ./kali-optimize-advanced.sh
```

## 📖 Uso

### Execução Padrão (Todas as fases)

```bash
sudo ./kali-optimize-advanced.sh
```

### Modo Simulação (Sem fazer alterações)

```bash
sudo DRY_RUN=true ./kali-optimize-advanced.sh
```

### Pular Reinicialização

```bash
sudo SKIP_REBOOT=true ./kali-optimize-advanced.sh
```

### Pular Instalação de Firmware

```bash
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh
```

## 📊 Fases de Execução

### Fase 1: Diagnóstico de Rede
- Detecta dispositivos PCI/PCIe de rede
- Lista adaptadores USB
- Mostra interfaces ativas
- Verifica bloqueio rfkill (Wi-Fi/Bluetooth)
- Instala firmware recomendado
- Trata drivers Broadcom especiais

### Fase 2: Atualização do Sistema
- Atualiza repositórios APT
- Full-upgrade e dist-upgrade
- Instala ferramentas Kali essenciais

### Fase 3: Correção de Problemas
- Corrige dependências quebradas
- Reconfigura pacotes com problemas

### Fase 4: Limpeza
- Limpa cache APT
- Remove pacotes não necessários
- Limpa arquivos temporários
- Remove logs antigos
- Otimiza banco de dados APT

### Fase 5: Otimizações
- Verifica integridade do sistema (debsums)
- Ajusta swappiness baseado em RAM
- Opção de limpar cache de memória
- Atualiza banco de exploits (searchsploit)

### Fase 6: Finalização
- Verifica espaço em disco
- Lista atualizações pendentes
- Resumo do estado de rede
- Sugestões adicionais
- Opção de reiniciar

## 📝 Arquivos de Log

Os logs são salvos em: `/var/log/kali-optimize-YYYYMMDD-HHMMSS.log`

Para visualizar:
```bash
tail -f /var/log/kali-optimize-*.log
```

## 🔧 Configurações Customizáveis

Edite `config/kali-optimize.conf` para customizar:

```bash
# Pacotes de firmware a instalar
FW_PACKAGES="firmware-linux firmware-linux-nonfree"

# Limite de tempo para journalctl
JOURNAL_VACUUM_TIME="3d"

# Threshold de swappiness
SWAPPINESS_VALUE=10
```

## 💡 Sugestões Adicionais

Após executar o script, considere:

```bash
# 1. Ajustes específicos do Kali
sudo kali-tweaks

# 2. Compression de memória (pouca RAM)
sudo apt install zram-tools

# 3. Preload para performance
sudo apt install preload

# 4. Para laptops (gerenciamento de energia)
sudo apt install tlp tlp-rdw

# 5. Atualizações regulares
sudo apt update && sudo apt upgrade
```

## 🔍 Verificações Pré-Execução

O script verifica automaticamente:
- ✅ Se está executando como root
- ✅ Se é Kali Linux ou derivado
- ✅ Espaço em disco disponível
- ✅ Conexão de internet
- ✅ Comandos necessários instalados

## ❌ Troubleshooting

### Script permissionado negado
```bash
sudo chmod +x kali-optimize-advanced.sh
```

### Erro em firmwares
```bash
# Pular fase de firmware
sudo SKIP_FIRMWARE=true ./kali-optimize-advanced.sh
```

### NetworkManager não inicia
```bash
sudo systemctl restart NetworkManager
sudo systemctl status NetworkManager
```

### Espaço em disco insuficiente
```bash
df -h
# Libere espaço antes de executar
```

## 📚 Estrutura do Projeto

```
kali-optimize-advanced/
├── README.md                          # Este arquivo
├── LICENSE                            # MIT License
├── CHANGELOG.md                       # Histórico de versões
├── .gitignore                         # Arquivos ignorados pelo git
├── kali-optimize-advanced.sh          # Script principal
├── lib/
│   ├── colors.sh                     # Funções de cores
│   ├── logging.sh                    # Sistema de logging
│   ├── network-diagnostics.sh        # Diagnóstico de rede
│   ├── system-cleanup.sh             # Limpeza do sistema
│   └── performance-tuning.sh         # Otimizações
├── config/
│   └── kali-optimize.conf            # Configurações padrão
└── examples/
    └── usage-examples.md             # Exemplos de uso
```

## 🤝 Contribuindo

Pull requests são bem-vindas! Para mudanças significativas:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## ⚡ Performance

Tempo estimado de execução:
- **Fase 1**: ~2 minutos
- **Fase 2**: ~10-30 minutos (depende da internet)
- **Fase 3**: ~2 minutos
- **Fase 4**: ~5 minutos
- **Fase 5**: ~3 minutos
- **Fase 6**: ~1 minuto

**Total**: ~25-45 minutos

## 🐛 Reportar Bugs

Encuentre um bug? [Abra uma issue](https://github.com/deuzimar700569/kali-optimize-advanced/issues) com:
- Descrição do problema
- Versão do Kali Linux
- Saída do log completo
- Passos para reproduzir

## 📞 Suporte

Para dúvidas:
- 📧 Email: [seu email]
- 💬 Issues: [GitHub Issues](https://github.com/deuzimar700569/kali-optimize-advanced/issues)
- 🌐 Wiki: [Documentação avançada](https://github.com/deuzimar700569/kali-optimize-advanced/wiki)

## 🙏 Agradecimentos

- Equipe Kali Linux
- Comunidade de segurança
- Contribuidores do projeto

---

**Última atualização**: 2026-07-04  
**Versão**: 2.0.0  
**Status**: ✅ Estável
