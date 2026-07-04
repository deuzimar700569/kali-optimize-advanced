# Changelog

Todos os mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-07-04

### Adicionado
- 📚 README.md completo com documentação detalhada
- 📄 LICENSE MIT
- 📝 CHANGELOG.md
- 🔧 Arquivo .gitignore
- 📁 Estrutura de diretórios modular (lib/, config/, examples/)
- 🎨 Melhorias de tratamento de erros
- ⚙️ Suporte a variáveis de configuração (DRY_RUN, SKIP_FIRMWARE, SKIP_REBOOT)
- 🔍 Verificações pré-execução melhoradas
- 📊 Logging aprimorado com timestamps
- 🛡️ Modo simulação (dry-run)
- 📋 Validações de espaço em disco
- 🌐 Verificação de conexão de internet

### Melhorado
- ✅ Tratamento de erros com PIPESTATUS
- ✅ Quoting de variáveis para segurança
- ✅ Lógica de detecção de interfaces de rede
- ✅ Documentação inline com comentários
- ✅ Mensagens de status mais claras
- ✅ Backup automático de configurações antes de alterações

### Corrigido
- 🐛 Risco de remoção de arquivos críticos em /tmp
- 🐛 Possível conflito com pacotes em instalação
- 🐛 Tratamento inadequado de falhas em apt
- 🐛 Falta de validação de comandos necessários

### Removido
- ❌ Remoção agressiva de /tmp/* (agora apenas files > 7 dias)
- ❌ Execução não confirmada de operações perigosas

## [1.0.0] - 2026-02-09

### Adicionado
- ✨ Script inicial de otimização Kali Linux
- 🔧 Diagnóstico de hardware de rede
- 📦 Instalação automática de firmware
- 🔄 Atualização do sistema
- 🧹 Limpeza de cache e logs
- ⚡ Otimizações de performance
- 📊 Suporte a drivers Broadcom
- 🌐 Verificação de interfaces de rede
- 📝 Sistema de logging completo
- 🎨 Saída colorida com status

---

## Roadmap Futuro

### Planejado para v2.1.0
- [ ] Suporte a opções via argparse
- [ ] Modo interativo com menu
- [ ] Perfis de otimização predefinidos
- [ ] Integração com systemd timers
- [ ] Alertas de segurança

### Planejado para v3.0.0
- [ ] Reescrever em Python com OOP
- [ ] Interface web
- [ ] API REST
- [ ] Suporte a múltiplas distros Linux
- [ ] Dashboard de monitoramento

---

**Nota**: Este projeto está sob desenvolvimento ativo. 
Contribua em: https://github.com/deuzimar700569/kali-optimize-advanced
