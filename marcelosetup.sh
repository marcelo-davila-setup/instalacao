#!/bin/bash

#====================================================================
# MARCELOSETUP v2.1 - ALL IN ONE MARKETING AUTOMATION
# Setup Completo para Automação de Marketing Digital  
# Powered by @marceloagentedigital
# Domain: marceloautomacoes.com.br
# Repository: https://github.com/marcelo-davila-setup/instalacao
#====================================================================

# Exit on any error
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# Script info
SCRIPT_VERSION="2.1.0"
SCRIPT_AUTHOR="@marceloagentedigital"
SCRIPT_URL="marceloautomacoes.com.br"
SCRIPT_EMAIL="info@marceloautomacoes.com.br"

# Installation paths
INSTALL_DIR="/opt/marcelosetup"
LOG_FILE="/tmp/marcelosetup.log"

#====================================================================
# UTILITY FUNCTIONS
#====================================================================

print_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
███╗   ███╗ █████╗ ██████╗  ██████╗███████╗██╗      ██████╗ 
████╗ ████║██╔══██╗██╔══██╗██╔════╝██╔════╝██║     ██╔═══██╗
██╔████╔██║███████║██████╔╝██║     █████╗  ██║     ██║   ██║
██║╚██╔╝██║██╔══██║██╔══██╗██║     ██╔══╝  ██║     ██║   ██║
██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗███████╗███████╗╚██████╔╝
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝╚══════╝ ╚═════╝ 
EOF
    echo -e "${NC}"
    echo -e "${WHITE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║${CYAN}              SETUP v${SCRIPT_VERSION} - ALL IN ONE                     ${WHITE}║${NC}"
    echo -e "${WHITE}║${YELLOW}        Setup Completo para Automação de Marketing        ${WHITE}║${NC}"
    echo -e "${WHITE}║                                                           ║${NC}"
    echo -e "${WHITE}║${MAGENTA}           Powered by ${SCRIPT_AUTHOR}           ${WHITE}║${NC}"
    echo -e "${WHITE}║${BLUE}              ${SCRIPT_URL}                ${WHITE}║${NC}"
    echo -e "${WHITE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_legal() {
    echo -e "${GRAY}© 2024 Marcelo Dávila - Todos os direitos reservados${NC}"
    echo -e "${GRAY}Powered by @marceloagentedigital${NC}"
    echo -e "${GRAY}marceloautomacoes.com.br${NC}"
    echo ""
    echo -e "${YELLOW}AVISO LEGAL: O MarceloSetup v2.1 é propriedade intelectual de Marcelo Dávila${NC}"
    echo ""
    echo -e "${WHITE}LICENÇA E SERVIÇOS${NC}"
    echo -e "${WHITE}Ao utilizar o MarceloSetup v2.1, você está adquirindo acesso a uma solução${NC}"
    echo -e "${WHITE}premium desenvolvida exclusivamente por Marcelo Dávila (@marceloagentedigital),${NC}"
    echo -e "${WHITE}especialista em marketing digital e automações.${NC}"
    echo ""
    echo -e "${GREEN}✅ Setup Profissional Completo - 15+ ferramentas de marketing digital${NC}"
    echo -e "${GREEN}✅ Infraestrutura Enterprise - Configuração que custaria R$ 5.000-15.000${NC}"
    echo -e "${GREEN}✅ Suporte Técnico Especializado - Suporte direto com o criador${NC}"
    echo -e "${GREEN}✅ Atualizações Vitalícias - Sempre a versão mais atualizada${NC}"
    echo -e "${GREEN}✅ Garantia de Funcionamento - Ambiente testado e otimizado${NC}"
    echo ""
    echo -e "${BLUE}📞 CONTRATO DE SERVIÇOS PREMIUM${NC}"
    echo -e "${BLUE}Email para Contratação: ${SCRIPT_EMAIL}${NC}"
    echo ""
}

accept_terms() {
    while true; do
        echo -e "${YELLOW}Concorda com os termos? ${WHITE}(${GREEN}Sim${WHITE}/${RED}Não${WHITE}): ${NC}" 
        read -r RESPONSE
        
        case "${RESPONSE,,}" in
            sim|s|yes|y)
                echo -e "${GREEN}✅ Termos aceitos. Continuando...${NC}"
                echo ""
                return 0
                ;;
            não|nao|n|no)
                echo -e "${RED}❌ Termos não aceitos. Instalação cancelada.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Resposta inválida. Digite 'Sim' ou 'Não'.${NC}"
                ;;
        esac
    done
}

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    log_info "$1"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    log_error "$1"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
    log_info "WARNING: $1"
}

print_info() {
    echo -e "${CYAN}ℹ️ $1${NC}"
    log_info "$1"
}

#====================================================================
# SYSTEM CHECKS
#====================================================================

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Este script deve ser executado como root. Use: sudo $0"
        exit 1
    fi
    print_success "Permissões de administrador verificadas"
}

check_system() {
    print_info "Verificando sistema operacional..."
    
    if [[ ! -f /etc/os-release ]]; then
        print_error "Sistema operacional não suportado"
        exit 1
    fi
    
    . /etc/os-release
    
    if [[ "$ID" != "ubuntu" ]] && [[ "$ID" != "debian" ]]; then
        print_error "Sistema operacional não suportado: $ID"
        exit 1
    fi
    
    print_success "Sistema detectado: $NAME $VERSION_ID"
}

check_resources() {
    print_info "Verificando recursos do sistema..."
    
    # Check RAM
    RAM_GB=$(free -g | awk 'NR==2{printf "%.0f", $2}')
    if [[ $RAM_GB -lt 4 ]]; then
        print_error "Mínimo 4GB RAM necessário. Detectado: ${RAM_GB}GB"
        exit 1
    fi
    
    # Check disk space
    DISK_GB=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $DISK_GB -lt 20 ]]; then
        print_error "Mínimo 20GB espaço livre necessário. Disponível: ${DISK_GB}GB"
        exit 1
    fi
    
    # Check CPU cores
    CPU_CORES=$(nproc)
    if [[ $CPU_CORES -lt 2 ]]; then
        print_warning "Recomendado 2+ cores CPU. Detectado: ${CPU_CORES} core(s)"
    fi
    
    print_success "Recursos verificados: RAM ${RAM_GB}GB, Disco ${DISK_GB}GB, CPU ${CPU_CORES} core(s)"
}

check_internet() {
    print_info "Verificando conectividade..."
    
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "Sem conexão com a internet"
        exit 1
    fi
    
    print_success "Conexão com internet confirmada"
}

#====================================================================
# USER INPUT
#====================================================================

get_domain() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${YELLOW}               CONFIGURAÇÃO DE DOMÍNIO                    ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}Para usar o MarceloSetup, você precisa de um domínio configurado.${NC}"
    echo -e "${WHITE}Exemplo: meusite.com.br${NC}"
    echo ""
    
    while true; do
        echo -e "${BLUE}Digite seu domínio principal: ${NC}"
        read -r DOMAIN
        
        if [[ -z "$DOMAIN" ]]; then
            print_warning "Domínio não pode ser vazio"
            continue
        fi
        
        # Basic domain validation
        if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]] && [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
            print_warning "Formato de domínio inválido. Use: exemplo.com ou exemplo.com.br"
            continue
        fi
        
        print_success "Domínio configurado: $DOMAIN"
        break
    done
}

get_email() {
    while true; do
        echo -e "${BLUE}Digite seu email para SSL (ou pressione ENTER para usar admin@${DOMAIN}): ${NC}"
        read -r EMAIL
        
        if [[ -z "$EMAIL" ]]; then
            EMAIL="admin@${DOMAIN}"
            break
        fi
        
        # Basic email validation
        if [[ ! "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            print_warning "Formato de email inválido"
            continue
        fi
        
        break
    done
    
    print_success "Email configurado: $EMAIL"
}

#====================================================================
# INSTALLATION FUNCTIONS
#====================================================================

update_system() {
    print_info "Atualizando sistema operacional..."
    
    export DEBIAN_FRONTEND=noninteractive
    
    apt update -y >> "$LOG_FILE" 2>&1
    apt upgrade -y >> "$LOG_FILE" 2>&1
    
    # Install essential dependencies
    apt install -y \
        curl wget git unzip software-properties-common \
        apt-transport-https ca-certificates gnupg lsb-release \
        htop nano vim ufw fail2ban \
        bc jq openssl >> "$LOG_FILE" 2>&1
    
    print_success "Sistema atualizado e dependências instaladas"
}

install_docker() {
    print_info "Verificando Docker..."
    
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+')
        print_success "Docker já instalado: v$DOCKER_VERSION"
        return
    fi
    
    print_info "Instalando Docker..."
    
    # Remove old versions
    apt remove -y docker docker-engine docker.io containerd runc &> /dev/null || true
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    apt update -y >> "$LOG_FILE" 2>&1
    apt install -y docker-ce docker-ce-cli containerd.io >> "$LOG_FILE" 2>&1
    
    # Configure Docker
    systemctl enable docker >> "$LOG_FILE" 2>&1
    systemctl start docker >> "$LOG_FILE" 2>&1
    
    print_success "Docker instalado e configurado"
}

install_docker_compose() {
    print_info "Verificando Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        COMPOSE_VERSION=$(docker-compose --version | grep -oP '\d+\.\d+\.\d+')
        print_success "Docker Compose já instalado: v$COMPOSE_VERSION"
        return
    fi
    
    print_info "Instalando Docker Compose..."
    
    # Get latest version
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
    
    # Download and install
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >> "$LOG_FILE" 2>&1
    chmod +x /usr/local/bin/docker-compose
    
    # Create symbolic link
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    print_success "Docker Compose instalado: $COMPOSE_VERSION"
}

setup_firewall() {
    print_info "Configurando firewall..."
    
    # Configure UFW
    ufw --force reset >> "$LOG_FILE" 2>&1
    ufw default deny incoming >> "$LOG_FILE" 2>&1
    ufw default allow outgoing >> "$LOG_FILE" 2>&1
    
    # Essential ports
    ufw allow ssh >> "$LOG_FILE" 2>&1
    ufw allow 80/tcp >> "$LOG_FILE" 2>&1
    ufw allow 443/tcp >> "$LOG_FILE" 2>&1
    
    # Enable firewall
    ufw --force enable >> "$LOG_FILE" 2>&1
    
    print_success "Firewall configurado"
}

create_directories() {
    print_info "Criando estrutura de diretórios..."
    
    # Main directories
    mkdir -p "$INSTALL_DIR"/{configs,data,logs,backups,scripts}
    mkdir -p "$INSTALL_DIR"/data/{postgres,redis,evolution,typebot,n8n,portainer,grafana,chatwoot,minio,traefik}
    mkdir -p "$INSTALL_DIR"/configs/{traefik,ssl}
    
    # Permissions
    chmod -R 755 "$INSTALL_DIR"
    
    print_success "Estrutura de diretórios criada"
}

generate_credentials() {
    print_info "Gerando credenciais seguras..."
    
    # Function to generate secure password
    generate_password() {
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
    }
    
    # Generate all credentials
    DB_PASSWORD=$(generate_password)
    REDIS_PASSWORD=$(generate_password)
    EVOLUTION_API_KEY=$(generate_password)
    GRAFANA_ADMIN_PASSWORD=$(generate_password)
    N8N_ENCRYPTION_KEY=$(generate_password)
    
    # Save credentials
    cat > "$INSTALL_DIR/configs/credentials.env" << EOF
# MarceloSetup v${SCRIPT_VERSION} - Credenciais Geradas em $(date)
# MANTENHA ESTE ARQUIVO SEGURO E PRIVADO!

# Configurações gerais
DOMAIN=${DOMAIN}
EMAIL=${EMAIL}

# Banco de dados
POSTGRES_DB=marcelosetup
POSTGRES_USER=marcelosetup
POSTGRES_PASSWORD=${DB_PASSWORD}

# Cache
REDIS_PASSWORD=${REDIS_PASSWORD}

# Automação
EVOLUTION_API_KEY=${EVOLUTION_API_KEY}
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}

# Monitoramento
GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
EOF
    
    # Protect credentials file
    chmod 600 "$INSTALL_DIR/configs/credentials.env"
    
    print_success "Credenciais seguras geradas"
}

create_docker_compose() {
    print_info "Criando configuração Docker Compose..."
    
    cat > "$INSTALL_DIR/docker-compose.yml" << EOF
version: '3.8'

# ===================================================================
# MARCELOSETUP v${SCRIPT_VERSION} - Docker Compose Configuration
# Powered by @marceloagentedigital
# Generated on $(date)
# ===================================================================

networks:
  marcelonet:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
  evolution_data:
  typebot_data:
  n8n_data:
  portainer_data:
  grafana_data:
  chatwoot_data:
  traefik_data:

services:
  # ===============================================================
  # REVERSE PROXY - TRAEFIK
  # ===============================================================
  traefik:
    image: traefik:v2.10
    container_name: marcelosetup_traefik
    restart: unless-stopped
    command:
      - "--api.dashboard=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.email=${EMAIL}"
      - "--certificatesresolvers.letsencrypt.acme.storage=/certificates/acme.json"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik_data:/certificates
    networks:
      - marcelonet
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(\`admin.${DOMAIN}\`)"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      - "traefik.http.routers.traefik.service=api@internal"

  # ===============================================================
  # BANCO DE DADOS - POSTGRESQL
  # ===============================================================
  postgres:
    image: postgres:15-alpine
    container_name: marcelosetup_postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - marcelonet

  # ===============================================================
  # CACHE - REDIS
  # ===============================================================
  redis:
    image: redis:7-alpine
    container_name: marcelosetup_redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - marcelonet

  # ===============================================================
  # WHATSAPP API - EVOLUTION
  # ===============================================================
  evolution:
    image: atendai/evolution-api:latest
    container_name: marcelosetup_evolution
    restart: unless-stopped
    environment:
      - DATABASE_PROVIDER=postgresql
      - DATABASE_CONNECTION_URI=postgresql://${POSTGRES_USER}:${DB_PASSWORD}@postgres:5432/${POSTGRES_DB}?schema=evolution
      - REDIS_URI=redis://:${REDIS_PASSWORD}@redis:6379
      - AUTHENTICATION_API_KEY=${EVOLUTION_API_KEY}
      - SERVER_TYPE=https
      - SERVER_URL=https://api.${DOMAIN}
    volumes:
      - evolution_data:/evolution/instances
    networks:
      - marcelonet
    depends_on:
      - postgres
      - redis
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.evolution.rule=Host(\`api.${DOMAIN}\`)"
      - "traefik.http.routers.evolution.entrypoints=websecure"
      - "traefik.http.routers.evolution.tls.certresolver=letsencrypt"
      - "traefik.http.services.evolution.loadbalancer.server.port=8080"

  # ===============================================================
  # CHATBOT BUILDER - TYPEBOT
  # ===============================================================
  typebot:
    image: baptistearno/typebot-builder:latest
    container_name: marcelosetup_typebot
    restart: unless-stopped
    environment:
      - DATABASE_URL=postgresql://${POSTGRES_USER}:${DB_PASSWORD}@postgres:5432/${POSTGRES_DB}?schema=typebot
      - NEXTAUTH_URL=https://bot.${DOMAIN}
      - NEXTAUTH_SECRET=${N8N_ENCRYPTION_KEY}
      - ENCRYPTION_SECRET=${N8N_ENCRYPTION_KEY}
      - ADMIN_EMAIL=${EMAIL}
    networks:
      - marcelonet
    depends_on:
      - postgres
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.typebot.rule=Host(\`bot.${DOMAIN}\`)"
      - "traefik.http.routers.typebot.entrypoints=websecure"
      - "traefik.http.routers.typebot.tls.certresolver=letsencrypt"
      - "traefik.http.services.typebot.loadbalancer.server.port=3000"

  # ===============================================================
  # WORKFLOW AUTOMATION - N8N
  # ===============================================================
  n8n:
    image: n8nio/n8n:latest
    container_name: marcelosetup_n8n
    restart: unless-stopped
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}
      - DB_POSTGRESDB_SCHEMA=n8n
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - WEBHOOK_URL=https://n8n.${DOMAIN}
      - GENERIC_TIMEZONE=America/Sao_Paulo
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=${DB_PASSWORD}
    volumes:
      - n8n_data:/home/node/.n8n
    networks:
      - marcelonet
    depends_on:
      - postgres
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.n8n.rule=Host(\`n8n.${DOMAIN}\`)"
      - "traefik.http.routers.n8n.entrypoints=websecure"
      - "traefik.http.routers.n8n.tls.certresolver=letsencrypt"
      - "traefik.http.services.n8n.loadbalancer.server.port=5678"

  # ===============================================================
  # CUSTOMER SUPPORT - CHATWOOT
  # ===============================================================
  chatwoot:
    image: chatwoot/chatwoot:latest
    container_name: marcelosetup_chatwoot
    restart: unless-stopped
    environment:
      - RAILS_ENV=production
      - SECRET_KEY_BASE=${N8N_ENCRYPTION_KEY}
      - POSTGRES_HOST=postgres
      - POSTGRES_USERNAME=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DATABASE=${POSTGRES_DB}
      - REDIS_URL=redis://:${REDIS_PASSWORD}@redis:6379
      - FRONTEND_URL=https://support.${DOMAIN}
    volumes:
      - chatwoot_data:/app/storage
    networks:
      - marcelonet
    depends_on:
      - postgres
      - redis
    command: ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.chatwoot.rule=Host(\`support.${DOMAIN}\`)"
      - "traefik.http.routers.chatwoot.entrypoints=websecure"
      - "traefik.http.routers.chatwoot.tls.certresolver=letsencrypt"
      - "traefik.http.services.chatwoot.loadbalancer.server.port=3000"

  # ===============================================================
  # DOCKER MANAGEMENT - PORTAINER
  # ===============================================================
  portainer:
    image: portainer/portainer-ce:latest
    container_name: marcelosetup_portainer
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - marcelonet
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.portainer.rule=Host(\`docker.${DOMAIN}\`)"
      - "traefik.http.routers.portainer.entrypoints=websecure"
      - "traefik.http.routers.portainer.tls.certresolver=letsencrypt"
      - "traefik.http.services.portainer.loadbalancer.server.port=9000"

  # ===============================================================
  # MONITORING - GRAFANA
  # ===============================================================
  grafana:
    image: grafana/grafana:latest
    container_name: marcelosetup_grafana
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
      - GF_USERS_ALLOW_SIGN_UP=false
      - GF_SERVER_DOMAIN=monitor.${DOMAIN}
      - GF_SERVER_ROOT_URL=https://monitor.${DOMAIN}
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - marcelonet
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.grafana.rule=Host(\`monitor.${DOMAIN}\`)"
      - "traefik.http.routers.grafana.entrypoints=websecure"
      - "traefik.http.routers.grafana.tls.certresolver=letsencrypt"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"

EOF

    print_success "Configuração Docker Compose criada"
}

start_services() {
    print_info "Iniciando todos os serviços..."
    
    cd "$INSTALL_DIR"
    
    # Source environment variables
    source "$INSTALL_DIR/configs/credentials.env"
    export $(grep -v '^#' "$INSTALL_DIR/configs/credentials.env" | xargs)
    
    # Start containers
    docker-compose up -d >> "$LOG_FILE" 2>&1
    
    print_success "Todos os serviços foram iniciados"
}

wait_for_services() {
    print_info "Aguardando serviços estabilizarem (isso pode levar alguns minutos)..."
    
    sleep 30  # Wait for containers to start
    
    print_success "Serviços estão sendo inicializados"
}

create_management_script() {
    print_info "Criando script de gerenciamento..."
    
    cat > "/usr/local/bin/marcelosetup" << 'EOF'
#!/bin/bash
# MarceloSetup - Script de Gerenciamento

INSTALL_DIR="/opt/marcelosetup"

case "$1" in
    start)
        echo "Iniciando MarceloSetup..."
        cd "$INSTALL_DIR" && docker-compose up -d
        ;;
    stop)
        echo "Parando MarceloSetup..."
        cd "$INSTALL_DIR" && docker-compose down
        ;;
    restart)
        echo "Reiniciando MarceloSetup..."
        cd "$INSTALL_DIR" && docker-compose restart
        ;;
    status)
        echo "Status dos serviços:"
        cd "$INSTALL_DIR" && docker-compose ps
        ;;
    logs)
        echo "Logs dos serviços:"
        cd "$INSTALL_DIR" && docker-compose logs -f
        ;;
    credentials)
        echo "Credenciais do sistema:"
        cat "$INSTALL_DIR/configs/credentials.env"
        ;;
    *)
        echo "MarceloSetup v2.1 - Gerenciamento"
        echo "Comandos disponíveis:"
        echo "  start        - Iniciar todos os serviços"
        echo "  stop         - Parar todos os serviços"
        echo "  restart      - Reiniciar todos os serviços"
        echo "  status       - Verificar status dos serviços"
        echo "  logs         - Visualizar logs em tempo real"
        echo "  credentials  - Mostrar credenciais do sistema"
        ;;
esac
EOF

    chmod +x "/usr/local/bin/marcelosetup"
    
    print_success "Script de gerenciamento criado"
}

#====================================================================
# COMPLETION FUNCTIONS
#====================================================================

show_completion() {
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║          🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO! 🎉          ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Load credentials for display
    source "$INSTALL_DIR/configs/credentials.env"
    
    echo -e "${BLUE}🌐 URLs dos Serviços:${NC}"
    echo -e "   • Evolution API (WhatsApp): ${GREEN}https://api.${DOMAIN}${NC}"
    echo -e "   • Typebot (Chatbots):       ${GREEN}https://bot.${DOMAIN}${NC}"
    echo -e "   • n8n (Automação):          ${GREEN}https://n8n.${DOMAIN}${NC}"
    echo -e "   • Chatwoot (Atendimento):   ${GREEN}https://support.${DOMAIN}${NC}"
    echo -e "   • Portainer (Docker):       ${GREEN}https://docker.${DOMAIN}${NC}"
    echo -e "   • Grafana (Monitor):        ${GREEN}https://monitor.${DOMAIN}${NC}"
    echo -e "   • Traefik (Admin):          ${GREEN}https://admin.${DOMAIN}${NC}"
    echo ""
    
    echo -e "${YELLOW}🔑 Credenciais Importantes:${NC}"
    echo -e "   • Evolution API Key:        ${WHITE}${EVOLUTION_API_KEY}${NC}"
    echo -e "   • Grafana Admin:            ${WHITE}admin / ${GRAFANA_ADMIN_PASSWORD}${NC}"
    echo -e "   • n8n Login:                ${WHITE}admin / ${POSTGRES_PASSWORD}${NC}"
    echo ""
    
    echo -e "${CYAN}📋 Comandos Úteis:${NC}"
    echo -e "   • Ver status:               ${WHITE}marcelosetup status${NC}"
    echo -e "   • Ver logs:                 ${WHITE}marcelosetup logs${NC}"
    echo -e "   • Reiniciar:                ${WHITE}marcelosetup restart${NC}"
    echo -e "   • Ver credenciais:          ${WHITE}marcelosetup credentials${NC}"
    echo ""
    
    echo -e "${GREEN}✅ Próximos Passos:${NC}"
    echo -e "   1. Configure DNS: Aponte os subdomínios para este servidor"
    echo -e "   2. Acesse Portainer para gerenciar containers"
    echo -e "   3. Configure Evolution API com WhatsApp Business"
    echo -e "   4. Crie seus primeiros chatbots no Typebot"
    echo -e "   5. Configure automações no n8n"
    echo ""
    
    echo -e "${BLUE}📧 Suporte:${NC} ${EMAIL}"
    echo -e "${BLUE}🔗 Powered by:${NC} ${SCRIPT_AUTHOR}"
    echo -e "${BLUE}🌐 Website:${NC} ${SCRIPT_URL}"
    echo ""
    
    echo -e "${MAGENTA}🔥 MarceloSetup v${SCRIPT_VERSION} instalado com sucesso! 🔥${NC}"
    echo ""
}

#====================================================================
# MAIN FUNCTION
#====================================================================

main() {
    # Initialize log
    echo "MarceloSetup v${SCRIPT_VERSION} installation started at $(date)" > "$LOG_FILE"
    
    # Show banner and legal terms
    print_banner
    print_legal
    accept_terms
    
    # System checks
    check_root
    check_system
    check_resources
    check_internet
    
    # Get user input
    get_domain
    get_email
    
    # Installation process
    print_info "Iniciando processo de instalação..."
    echo ""
    
    update_system
    install_docker
    install_docker_compose
    setup_firewall
    create_directories
    generate_credentials
    create_docker_compose
    start_services
    wait_for_services
    create_management_script
    
    # Show completion info
    show_completion
    
    # Final log
    log_info "MarceloSetup v${SCRIPT_VERSION} installation completed successfully"
}

#====================================================================
# SCRIPT EXECUTION
#====================================================================

# Run main function
main "$@"

exit 0
