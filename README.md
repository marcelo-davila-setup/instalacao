# 🚀 MarceloSetup v2.1 - All-in-One Marketing Automation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-2.1.0-blue.svg)](https://github.com/marcelo-davila-setup/instalacao)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%2020.04%2B-orange.svg)](https://ubuntu.com/)

> **Setup Completo para Automação de Marketing Digital**  
> Instale 10+ ferramentas profissionais em uma única linha de comando!

## ✨ Instalação Rápida

```bash
bash <(curl -sSL https://raw.githubusercontent.com/marcelo-davila-setup/instalacao/main/marcelosetup.sh)
```

## 🎯 O que é o MarceloSetup?

O **MarceloSetup v2.1** é uma solução completa que instala e configura automaticamente toda a infraestrutura necessária para automação de marketing digital. Em **20-30 minutos**, você terá um ambiente profissional completo funcionando.

## 🛠️ Ferramentas Incluídas

### 🔧 **Infraestrutura Base**
- **Docker & Docker Compose** - Containerização
- **Traefik** - Proxy reverso com SSL automático
- **UFW** - Firewall configurado

### 💾 **Bancos de Dados**
- **PostgreSQL 15** - Banco de dados principal
- **Redis 7** - Cache e sessões

### 🤖 **Automação de Marketing**
- **Evolution API** - API do WhatsApp Business
- **Typebot** - Construtor de chatbots visuais
- **n8n** - Automação de workflows avançada

### 💬 **Atendimento ao Cliente**
- **Chatwoot** - Central de atendimento omnichannel

### 📊 **Gestão e Monitoramento**
- **Portainer** - Interface para gerenciar Docker
- **Grafana** - Dashboards e monitoramento

## 🌐 Subdomínios Configurados

Após a instalação, os seguintes subdomínios estarão disponíveis:

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Evolution API | `https://api.seudominio.com` | API do WhatsApp Business |
| Typebot | `https://bot.seudominio.com` | Construtor de chatbots |
| n8n | `https://n8n.seudominio.com` | Automação de workflows |
| Chatwoot | `https://support.seudominio.com` | Atendimento ao cliente |
| Portainer | `https://docker.seudominio.com` | Gerenciamento Docker |
| Grafana | `https://monitor.seudominio.com` | Monitoramento |
| Traefik | `https://admin.seudominio.com` | Proxy reverso |

## 📋 Requisitos do Sistema

### **Mínimos**
- **SO:** Ubuntu 20.04+ ou Debian 11+
- **RAM:** 4GB
- **Disco:** 20GB SSD
- **CPU:** 2 cores
- **Acesso:** Root/sudo

### **Recomendados**
- **RAM:** 8GB+
- **Disco:** 50GB+ SSD
- **CPU:** 4+ cores
- **Rede:** Banda larga estável

## 🚀 Guia de Instalação

### 1. **Preparação do Servidor**

```bash
# Conectar no servidor
ssh root@SEU_IP_DO_SERVIDOR

# Verificar recursos
free -h && df -h && nproc
```

### 2. **Configuração de DNS**

Configure os seguintes registros DNS apontando para o IP do seu servidor:

```
Tipo: A | Nome: @ | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: api | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: bot | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: n8n | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: support | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: docker | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: monitor | Valor: SEU_IP_DO_SERVIDOR
Tipo: A | Nome: admin | Valor: SEU_IP_DO_SERVIDOR
```

### 3. **Executar a Instalação**

```bash
bash <(curl -sSL https://raw.githubusercontent.com/marcelo-davila-setup/instalacao/main/marcelosetup.sh)
```

O script irá:
1. Mostrar banner e termos legais
2. Verificar sistema e recursos
3. Solicitar domínio e email
4. Instalar todas as ferramentas
5. Configurar SSL automático
6. Exibir credenciais e URLs

## 🔐 Credenciais e Segurança

### **Localização das Credenciais**
```bash
/opt/marcelosetup/configs/credentials.env
```

### **Visualizar Credenciais**
```bash
marcelosetup credentials
```

### **Recursos de Segurança**
- ✅ **Senhas aleatórias** de 25 caracteres
- ✅ **SSL automático** (Let's Encrypt)
- ✅ **Firewall configurado** (UFW)
- ✅ **Containers isolados** em rede privada

## 🔧 Comandos de Gerenciamento

```bash
# Ver status de todos os serviços
marcelosetup status

# Iniciar todos os serviços
marcelosetup start

# Parar todos os serviços
marcelosetup stop

# Reiniciar todos os serviços
marcelosetup restart

# Ver logs em tempo real
marcelosetup logs

# Ver credenciais do sistema
marcelosetup credentials
```

## 💡 Novidades v2.1

### **🔧 Melhorias Técnicas**
- ✅ **Script linear** sem menus confusos
- ✅ **Detecção inteligente** de recursos
- ✅ **Logs melhorados** com timestamps
- ✅ **Validação** de domínio e email
- ✅ **Termos legais** integrados

### **🛡️ Segurança Aprimorada**
- ✅ **Credenciais protegidas** (chmod 600)
- ✅ **Firewall automático**
- ✅ **SSL para todos** os serviços
- ✅ **Containers isolados**

### **📱 Interface Melhorada**
- ✅ **Banner ASCII** personalizado
- ✅ **Mensagens coloridas** e claras
- ✅ **Progresso visual** das etapas
- ✅ **Conclusão detalhada**

## 🚨 Troubleshooting

### **Problemas Comuns**

#### **1. Erro de Permissão**
```bash
# Executar como root
sudo bash <(curl -sSL https://raw.githubusercontent.com/marcelo-davila-setup/instalacao/main/marcelosetup.sh)
```

#### **2. DNS não Resolve**
```bash
# Verificar DNS
nslookup api.seudominio.com
dig +short api.seudominio.com

# Aguardar propagação (até 24h)
```

#### **3. Container não Inicia**
```bash
# Ver logs do container específico
docker logs marcelosetup_evolution

# Ver recursos do sistema
free -h && df -h
```

### **Logs Importantes**
```bash
# Log principal da instalação
tail -f /tmp/marcelosetup.log

# Logs do Traefik (proxy/SSL)
docker logs marcelosetup_traefik
```

## 📞 Suporte

### **Canais de Suporte**
- 📧 **Email:** info@marceloautomacoes.com.br
- 🌐 **Website:** [marceloautomacoes.com.br](https://marceloautomacoes.com.br)
- 📱 **Instagram:** [@marceloagentedigital](https://instagram.com/marceloagentedigital)
- 🐛 **Issues:** [GitHub Issues](https://github.com/marcelo-davila-setup/instalacao/issues)

## 📄 Licença

© 2024 Marcelo Dávila - Todos os direitos reservados  
Powered by @marceloagentedigital  
marceloautomacoes.com.br  

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

<div align="center">

**🔥 MarceloSetup v2.1 - Powered by [@marceloagentedigital](https://github.com/marceloagentedigital) 🔥**

*Do zero ao profissional em uma linha de comando!*

[![⭐ Star no GitHub](https://img.shields.io/badge/⭐%20Star%20no%20GitHub-yellow.svg)](https://github.com/marcelo-davila-setup/instalacao)

</div>
