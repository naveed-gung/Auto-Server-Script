#!/bin/bash

################################################################################
# Elite Auto Server Setup - Main Entry Point
# Version: 1.0.0
# Description: Professional-grade server provisioning system
# Author: naveed-gung (https://github.com/naveed-gung)
# License: MIT
################################################################################

set -euo pipefail
IFS=$'\n\t'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

# Global variables (must be defined before sourcing libraries)
readonly VERSION="1.0.0"
readonly LOG_DIR="/var/log/elite-setup"
readonly CONFIG_DIR="/etc/elite-setup"
readonly BACKUP_DIR="/var/lib/elite-setup/backups"

# Source all library modules
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/logger.sh"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/preflight.sh"
source "${SCRIPT_DIR}/lib/installer.sh"
source "${SCRIPT_DIR}/lib/config.sh"
source "${SCRIPT_DIR}/lib/security.sh"
source "${SCRIPT_DIR}/lib/reporting.sh"
source "${SCRIPT_DIR}/lib/notifications.sh"

# Default configuration
MODE="interactive"
PROFILE="production"
CONFIG_FILE=""
SILENT=false
DRY_RUN=false
TEST_MODE=false
WITH_DOCKER=false
SKIP_FIREWALL=false
DOMAIN=""
SSL_EMAIL=""
NODE_VERSION="20"
MONGODB_VERSION="7.0"
SLACK_WEBHOOK=""
DISCORD_WEBHOOK=""

################################################################################
# Display banner
################################################################################
show_banner() {
    if [[ "${SILENT}" == false ]]; then
        clear
        echo -e "${CYAN}"
        cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║   ███████╗██╗     ██╗████████╗███████╗    ███████╗███████╗████████╗  ║
║   ██╔════╝██║     ██║╚══██╔══╝██╔════╝    ██╔════╝██╔════╝╚══██╔══╝  ║
║   █████╗  ██║     ██║   ██║   █████╗      ███████╗█████╗     ██║     ║
║   ██╔══╝  ██║     ██║   ██║   ██╔══╝      ╚════██║██╔══╝     ██║     ║
║   ███████╗███████╗██║   ██║   ███████╗    ███████║███████╗   ██║     ║
║   ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝    ╚══════╝╚══════╝   ╚═╝     ║
║                                                                       ║
║          Elite Auto Server Setup - Version ${VERSION}                ║
║          Professional Server Provisioning System                     ║
║          Created by: naveed-gung (github.com/naveed-gung)            ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
        echo ""
    fi
}

################################################################################
# Display help
################################################################################
show_help() {
    cat << EOF
${BOLD}Elite Auto Server Setup${NC} - Zero-touch production server provisioning

${BOLD}USAGE:${NC}
    sudo ./setup.sh [OPTIONS]

${BOLD}OPTIONS:${NC}
    ${GREEN}--mode=MODE${NC}              Mode: interactive, silent, or production (default: interactive)
    ${GREEN}--profile=PROFILE${NC}         Profile: development, staging, production (default: production)
    ${GREEN}--config=FILE${NC}             Load configuration from JSON file
    ${GREEN}--domain=DOMAIN${NC}           Domain name for SSL certificate
    ${GREEN}--ssl-email=EMAIL${NC}         Email for Let's Encrypt notifications
    ${GREEN}--node-version=VERSION${NC}    Node.js version to install (default: 20)
    ${GREEN}--mongodb-version=VERSION${NC} MongoDB version to install (default: 7.0)
    ${GREEN}--with-docker${NC}             Install Docker and docker-compose
    ${GREEN}--skip-firewall${NC}           Skip firewall configuration
    ${GREEN}--slack-webhook=URL${NC}       Slack webhook for notifications
    ${GREEN}--discord-webhook=URL${NC}     Discord webhook for notifications
    ${GREEN}--silent${NC}                  Run in silent mode (no interactive prompts)
    ${GREEN}--dry-run${NC}                 Simulate installation without making changes
    ${GREEN}--test${NC}                    Test mode - validates script without installing anything
    ${GREEN}--help${NC}                    Display this help message
    ${GREEN}--version${NC}                 Display version information

${BOLD}EXAMPLES:${NC}
    ${CYAN}# Interactive installation${NC}
    sudo ./setup.sh

    ${CYAN}# Production server with SSL${NC}
    sudo ./setup.sh --mode=production --domain=example.com --ssl-email=admin@example.com

    ${CYAN}# Development environment with Docker${NC}
    sudo ./setup.sh --profile=development --with-docker --skip-firewall

    ${CYAN}# CI/CD deployment${NC}
    sudo ./setup.sh --config=production.json --silent

${BOLD}CONFIGURATION PROFILES:${NC}
    ${YELLOW}development${NC}  - Local development environment
    ${YELLOW}staging${NC}      - Pre-production testing environment
    ${YELLOW}production${NC}   - Production server with full security

${BOLD}DOCUMENTATION:${NC}
    GitHub: https://github.com/naveed-gung/elite-server-setup
    Created by: naveed-gung

EOF
}

################################################################################
# Display version
################################################################################
show_version() {
    echo "Elite Auto Server Setup v${VERSION}"
    echo "Created by: naveed-gung (https://github.com/naveed-gung)"
    echo "License: MIT"
}

################################################################################
# Parse command-line arguments
################################################################################
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --version|-v)
                show_version
                exit 0
                ;;
            --mode=*)
                MODE="${1#*=}"
                ;;
            --profile=*)
                PROFILE="${1#*=}"
                ;;
            --config=*)
                CONFIG_FILE="${1#*=}"
                ;;
            --domain=*)
                DOMAIN="${1#*=}"
                ;;
            --ssl-email=*)
                SSL_EMAIL="${1#*=}"
                ;;
            --node-version=*)
                NODE_VERSION="${1#*=}"
                ;;
            --mongodb-version=*)
                MONGODB_VERSION="${1#*=}"
                ;;
            --slack-webhook=*)
                SLACK_WEBHOOK="${1#*=}"
                ;;
            --discord-webhook=*)
                DISCORD_WEBHOOK="${1#*=}"
                ;;
            --with-docker)
                WITH_DOCKER=true
                ;;
            --skip-firewall)
                SKIP_FIREWALL=true
                ;;
            --silent)
                SILENT=true
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --test)
                TEST_MODE=true
                DRY_RUN=true
                ;;
            *)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                echo "Run './setup.sh --help' for usage information."
                exit 1
                ;;
        esac
        shift
    done
}

################################################################################
# Main installation flow
################################################################################
main() {
    # Parse arguments
    parse_arguments "$@"
    
    # Display banner
    show_banner
    
    # Initialize logging
    init_logging
    
    log_info "=== Elite Auto Server Setup v${VERSION} ==="
    log_info "Mode: ${MODE}"
    log_info "Profile: ${PROFILE}"
    
    # Check if running as root
    if [[ "${EUID}" -ne 0 ]]; then
        log_error "This script must be run as root or with sudo"
        echo -e "${RED}Error: Please run with sudo${NC}"
        exit 1
    fi
    
    # Load configuration
    if [[ -n "${CONFIG_FILE}" ]]; then
        log_info "Loading configuration from: ${CONFIG_FILE}"
        load_config "${CONFIG_FILE}"
    fi
    
    # Run preflight checks
    log_info "Running preflight system checks..."
    if ! run_preflight_checks; then
        log_error "Preflight checks failed"
        send_notification "❌ Elite Setup Failed" "Preflight checks failed on $(hostname)"
        exit 1
    fi
    
    # Display installation plan
    if [[ "${SILENT}" == false ]]; then
        display_installation_plan
        read -p "Continue with installation? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled by user"
            exit 0
        fi
    fi
    
    # Create backup point for rollback
    log_info "Creating system backup point..."
    create_backup_point
    
    # Start installation
    local start_time=$(date +%s)
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_info "DRY RUN MODE - No changes will be made"
    fi
    
    # Install components
    log_info "Installing components..."
    
    # Update system packages
    install_component "System Update" update_system_packages
    
    # Install Node.js
    install_component "Node.js ${NODE_VERSION}" install_nodejs
    
    # Install MongoDB
    install_component "MongoDB ${MONGODB_VERSION}" install_mongodb
    
    # Install Nginx
    install_component "Nginx" install_nginx
    
    # Install PM2
    install_component "PM2" install_pm2
    
    # Install Docker (optional)
    if [[ "${WITH_DOCKER}" == true ]]; then
        install_component "Docker" install_docker
    fi
    
    # Configure security
    if [[ "${SKIP_FIREWALL}" == false ]]; then
        install_component "Security Hardening" configure_security
    fi
    
    # Post-installation health checks
    log_info "Running post-installation health checks..."
    if ! run_health_checks; then
        log_warning "Some health checks failed"
    fi
    
    # Generate deployment report
    log_info "Generating deployment report..."
    generate_deployment_report
    
    # Calculate installation time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Display summary
    display_installation_summary "${duration}"
    
    # Send notifications
    send_notification "✅ Elite Setup Complete" "Server $(hostname) provisioned successfully in ${duration}s"
    
    log_info "=== Installation Complete ==="
    log_info "Installation logs: ${LOG_DIR}/install.log"
    log_info "Deployment report: ${LOG_DIR}/report.html"
    
    exit 0
}

################################################################################
# Error handler
################################################################################
error_handler() {
    local line_number=$1
    log_error "Error occurred in setup.sh at line ${line_number}"
    log_error "Rolling back changes..."
    
    if [[ "${DRY_RUN}" == false ]]; then
        rollback_installation
    fi
    
    send_notification "❌ Elite Setup Failed" "Installation failed on $(hostname) at line ${line_number}"
    
    echo -e "${RED}Installation failed. Check logs at ${LOG_DIR}/error.log${NC}"
    exit 1
}

# Set error trap
trap 'error_handler ${LINENO}' ERR

# Run main function
main "$@"
