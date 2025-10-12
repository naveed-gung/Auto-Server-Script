#!/bin/bash

################################################################################
# Configuration Management Library
# Handles configuration loading, validation, and management
################################################################################

# Configuration variables
declare -A CONFIG

################################################################################
# Load configuration from JSON file
# Arguments:
#   $1 - Configuration file path
################################################################################
load_config() {
    local config_file="$1"
    
    if [[ ! -f "${config_file}" ]]; then
        log_error "Configuration file not found: ${config_file}"
        return 1
    fi
    
    log_info "Loading configuration from: ${config_file}"
    
    # Check if jq is available
    if ! command_exists jq; then
        log_info "Installing jq for JSON parsing..."
        install_package jq
    fi
    
    # Validate JSON syntax
    if ! jq empty "${config_file}" 2>/dev/null; then
        log_error "Invalid JSON in configuration file"
        return 1
    fi
    
    # Load profile
    PROFILE=$(jq -r '.profile // "production"' "${config_file}")
    
    # Load domain settings
    DOMAIN=$(jq -r '.domain // ""' "${config_file}")
    SSL_EMAIL=$(jq -r '.ssl_email // ""' "${config_file}")
    
    # Load component settings
    CONFIG[nodejs_enabled]=$(jq -r '.components.nodejs.enabled // true' "${config_file}")
    CONFIG[nodejs_version]=$(jq -r '.components.nodejs.version // "20"' "${config_file}")
    
    CONFIG[mongodb_enabled]=$(jq -r '.components.mongodb.enabled // true' "${config_file}")
    CONFIG[mongodb_version]=$(jq -r '.components.mongodb.version // "7.0"' "${config_file}")
    CONFIG[mongodb_auth]=$(jq -r '.components.mongodb.enable_auth // true' "${config_file}")
    CONFIG[mongodb_user]=$(jq -r '.components.mongodb.admin_user // "admin"' "${config_file}")
    
    CONFIG[nginx_enabled]=$(jq -r '.components.nginx.enabled // true' "${config_file}")
    CONFIG[nginx_ssl]=$(jq -r '.components.nginx.ssl // true' "${config_file}")
    CONFIG[nginx_ssl_provider]=$(jq -r '.components.nginx.ssl_provider // "letsencrypt"' "${config_file}")
    
    CONFIG[pm2_enabled]=$(jq -r '.components.pm2.enabled // true' "${config_file}")
    CONFIG[pm2_instances]=$(jq -r '.components.pm2.instances // "max"' "${config_file}")
    
    CONFIG[docker_enabled]=$(jq -r '.components.docker.enabled // false' "${config_file}")
    
    # Load security settings
    CONFIG[firewall_enabled]=$(jq -r '.components.security.firewall // true' "${config_file}")
    CONFIG[fail2ban_enabled]=$(jq -r '.components.security.fail2ban // true' "${config_file}")
    CONFIG[auto_updates]=$(jq -r '.components.security.auto_updates // true' "${config_file}")
    CONFIG[ssh_hardening]=$(jq -r '.components.security.ssh_hardening // true' "${config_file}")
    
    # Load notification settings
    SLACK_WEBHOOK=$(jq -r '.notifications.slack_webhook // ""' "${config_file}")
    DISCORD_WEBHOOK=$(jq -r '.notifications.discord_webhook // ""' "${config_file}")
    CONFIG[notification_email]=$(jq -r '.notifications.email // ""' "${config_file}")
    
    log_info "Configuration loaded successfully"
    return 0
}

################################################################################
# Save configuration to file
# Arguments:
#   $1 - Configuration file path
################################################################################
save_config() {
    local config_file="$1"
    
    log_info "Saving configuration to: ${config_file}"
    
    cat > "${config_file}" << EOF
{
  "profile": "${PROFILE}",
  "domain": "${DOMAIN}",
  "ssl_email": "${SSL_EMAIL}",
  "components": {
    "nodejs": {
      "enabled": ${CONFIG[nodejs_enabled]:-true},
      "version": "${CONFIG[nodejs_version]:-20}"
    },
    "mongodb": {
      "enabled": ${CONFIG[mongodb_enabled]:-true},
      "version": "${CONFIG[mongodb_version]:-7.0}",
      "enable_auth": ${CONFIG[mongodb_auth]:-true},
      "admin_user": "${CONFIG[mongodb_user]:-admin}"
    },
    "nginx": {
      "enabled": ${CONFIG[nginx_enabled]:-true},
      "ssl": ${CONFIG[nginx_ssl]:-true},
      "ssl_provider": "${CONFIG[nginx_ssl_provider]:-letsencrypt}"
    },
    "pm2": {
      "enabled": ${CONFIG[pm2_enabled]:-true},
      "instances": "${CONFIG[pm2_instances]:-max}"
    },
    "docker": {
      "enabled": ${CONFIG[docker_enabled]:-false}
    },
    "security": {
      "firewall": ${CONFIG[firewall_enabled]:-true},
      "fail2ban": ${CONFIG[fail2ban_enabled]:-true},
      "auto_updates": ${CONFIG[auto_updates]:-true},
      "ssh_hardening": ${CONFIG[ssh_hardening]:-true}
    }
  },
  "notifications": {
    "slack_webhook": "${SLACK_WEBHOOK}",
    "discord_webhook": "${DISCORD_WEBHOOK}",
    "email": "${CONFIG[notification_email]}"
  }
}
EOF
    
    log_info "Configuration saved"
    return 0
}

################################################################################
# Load profile configuration
# Arguments:
#   $1 - Profile name (development, staging, production)
################################################################################
load_profile() {
    local profile="$1"
    
    log_info "Loading profile: ${profile}"
    
    case "${profile}" in
        development)
            CONFIG[nodejs_enabled]=true
            CONFIG[nodejs_version]="20"
            CONFIG[mongodb_enabled]=true
            CONFIG[mongodb_auth]=false
            CONFIG[nginx_enabled]=true
            CONFIG[nginx_ssl]=false
            CONFIG[pm2_enabled]=true
            CONFIG[pm2_instances]=1
            CONFIG[docker_enabled]=false
            CONFIG[firewall_enabled]=false
            CONFIG[fail2ban_enabled]=false
            CONFIG[auto_updates]=false
            CONFIG[ssh_hardening]=false
            ;;
        staging)
            CONFIG[nodejs_enabled]=true
            CONFIG[nodejs_version]="20"
            CONFIG[mongodb_enabled]=true
            CONFIG[mongodb_auth]=true
            CONFIG[nginx_enabled]=true
            CONFIG[nginx_ssl]=true
            CONFIG[nginx_ssl_provider]="selfsigned"
            CONFIG[pm2_enabled]=true
            CONFIG[pm2_instances]="max"
            CONFIG[docker_enabled]=false
            CONFIG[firewall_enabled]=true
            CONFIG[fail2ban_enabled]=true
            CONFIG[auto_updates]=true
            CONFIG[ssh_hardening]=true
            ;;
        production)
            CONFIG[nodejs_enabled]=true
            CONFIG[nodejs_version]="20"
            CONFIG[mongodb_enabled]=true
            CONFIG[mongodb_auth]=true
            CONFIG[nginx_enabled]=true
            CONFIG[nginx_ssl]=true
            CONFIG[nginx_ssl_provider]="letsencrypt"
            CONFIG[pm2_enabled]=true
            CONFIG[pm2_instances]="max"
            CONFIG[docker_enabled]=false
            CONFIG[firewall_enabled]=true
            CONFIG[fail2ban_enabled]=true
            CONFIG[auto_updates]=true
            CONFIG[ssh_hardening]=true
            ;;
        *)
            log_error "Unknown profile: ${profile}"
            return 1
            ;;
    esac
    
    log_info "Profile loaded: ${profile}"
    return 0
}

################################################################################
# Display installation plan
################################################################################
display_installation_plan() {
    print_header "Installation Plan"
    
    echo ""
    print_table_row "Profile" "${PROFILE}" "${BOLD_CYAN}"
    
    if [[ -n "${DOMAIN}" ]]; then
        print_table_row "Domain" "${DOMAIN}" "${CYAN}"
    fi
    
    if [[ -n "${SSL_EMAIL}" ]]; then
        print_table_row "SSL Email" "${SSL_EMAIL}" "${CYAN}"
    fi
    
    echo ""
    echo -e "${BOLD}Components to Install:${NC}"
    echo ""
    
    if [[ "${CONFIG[nodejs_enabled]}" == "true" ]]; then
        echo -e "  ${GREEN}✓${NC} Node.js ${CONFIG[nodejs_version]:-20}"
    fi
    
    if [[ "${CONFIG[mongodb_enabled]}" == "true" ]]; then
        local auth_status="without auth"
        if [[ "${CONFIG[mongodb_auth]}" == "true" ]]; then
            auth_status="with authentication"
        fi
        echo -e "  ${GREEN}✓${NC} MongoDB ${CONFIG[mongodb_version]:-7.0} (${auth_status})"
    fi
    
    if [[ "${CONFIG[nginx_enabled]}" == "true" ]]; then
        local ssl_status="without SSL"
        if [[ "${CONFIG[nginx_ssl]}" == "true" ]]; then
            ssl_status="with ${CONFIG[nginx_ssl_provider]:-letsencrypt} SSL"
        fi
        echo -e "  ${GREEN}✓${NC} Nginx (${ssl_status})"
    fi
    
    if [[ "${CONFIG[pm2_enabled]}" == "true" ]]; then
        echo -e "  ${GREEN}✓${NC} PM2 (${CONFIG[pm2_instances]:-max} instances)"
    fi
    
    if [[ "${CONFIG[docker_enabled]}" == "true" || "${WITH_DOCKER}" == true ]]; then
        echo -e "  ${GREEN}✓${NC} Docker + docker-compose"
    fi
    
    echo ""
    echo -e "${BOLD}Security Features:${NC}"
    echo ""
    
    if [[ "${CONFIG[firewall_enabled]}" == "true" && "${SKIP_FIREWALL}" == false ]]; then
        echo -e "  ${GREEN}✓${NC} UFW Firewall"
    fi
    
    if [[ "${CONFIG[fail2ban_enabled]}" == "true" ]]; then
        echo -e "  ${GREEN}✓${NC} Fail2ban"
    fi
    
    if [[ "${CONFIG[auto_updates]}" == "true" ]]; then
        echo -e "  ${GREEN}✓${NC} Automatic Security Updates"
    fi
    
    if [[ "${CONFIG[ssh_hardening]}" == "true" ]]; then
        echo -e "  ${GREEN}✓${NC} SSH Hardening"
    fi
    
    echo ""
}

################################################################################
# Validate configuration
################################################################################
validate_config() {
    log_info "Validating configuration..."
    
    local errors=0
    
    # Validate domain if SSL is enabled
    if [[ "${CONFIG[nginx_ssl]}" == "true" && "${CONFIG[nginx_ssl_provider]}" == "letsencrypt" ]]; then
        if [[ -z "${DOMAIN}" ]]; then
            log_error "Domain is required for Let's Encrypt SSL"
            ((errors++))
        elif ! is_valid_domain "${DOMAIN}"; then
            log_error "Invalid domain format: ${DOMAIN}"
            ((errors++))
        fi
        
        if [[ -z "${SSL_EMAIL}" ]]; then
            log_error "Email is required for Let's Encrypt SSL"
            ((errors++))
        elif ! is_valid_email "${SSL_EMAIL}"; then
            log_error "Invalid email format: ${SSL_EMAIL}"
            ((errors++))
        fi
    fi
    
    # Validate Node.js version
    if [[ "${CONFIG[nodejs_enabled]}" == "true" ]]; then
        local nodejs_version="${CONFIG[nodejs_version]:-20}"
        if [[ ! "${nodejs_version}" =~ ^[0-9]+$ ]]; then
            log_error "Invalid Node.js version: ${nodejs_version}"
            ((errors++))
        fi
    fi
    
    # Validate MongoDB version
    if [[ "${CONFIG[mongodb_enabled]}" == "true" ]]; then
        local mongodb_version="${CONFIG[mongodb_version]:-7.0}"
        if [[ ! "${mongodb_version}" =~ ^[0-9]+\.[0-9]+$ ]]; then
            log_error "Invalid MongoDB version: ${mongodb_version}"
            ((errors++))
        fi
    fi
    
    if [[ $errors -gt 0 ]]; then
        log_error "Configuration validation failed with ${errors} error(s)"
        return 1
    fi
    
    log_info "Configuration validation passed"
    return 0
}

################################################################################
# Get configuration value
# Arguments:
#   $1 - Key
#   $2 - Default value (optional)
################################################################################
get_config() {
    local key="$1"
    local default="${2:-}"
    echo "${CONFIG[$key]:-$default}"
}

################################################################################
# Set configuration value
# Arguments:
#   $1 - Key
#   $2 - Value
################################################################################
set_config() {
    local key="$1"
    local value="$2"
    CONFIG[$key]="$value"
}

################################################################################
# Interactive configuration wizard
################################################################################
interactive_config_wizard() {
    if [[ "${SILENT}" == true ]]; then
        return 0
    fi
    
    print_header "Configuration Wizard"
    
    echo ""
    echo -e "${CYAN}Let's configure your server setup...${NC}"
    echo ""
    
    # Ask for profile
    echo "Select profile:"
    echo "  1) Development (local dev environment)"
    echo "  2) Staging (pre-production testing)"
    echo "  3) Production (production server)"
    echo ""
    read -p "Choice [1-3] (default: 3): " profile_choice
    
    case "${profile_choice}" in
        1) PROFILE="development" ;;
        2) PROFILE="staging" ;;
        *) PROFILE="production" ;;
    esac
    
    load_profile "${PROFILE}"
    
    # Ask for domain
    if [[ "${CONFIG[nginx_ssl]}" == "true" ]]; then
        echo ""
        read -p "Enter domain name (e.g., example.com): " DOMAIN
        
        if [[ -n "${DOMAIN}" ]]; then
            read -p "Enter email for SSL certificate: " SSL_EMAIL
        fi
    fi
    
    # Ask for optional components
    echo ""
    if ask_yes_no "Install Docker?" "n"; then
        CONFIG[docker_enabled]=true
        WITH_DOCKER=true
    fi
    
    echo ""
    print_success "Configuration complete!"
    sleep 1
}

# Export functions
export -f load_config
export -f save_config
export -f load_profile
export -f display_installation_plan
export -f validate_config
export -f get_config
export -f set_config
export -f interactive_config_wizard
