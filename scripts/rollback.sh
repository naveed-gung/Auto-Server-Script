#!/bin/bash

################################################################################
# Rollback Script
# Restores system to pre-installation state
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

set -euo pipefail

BACKUP_DIR="/var/lib/elite-setup/backups"
LOG_DIR="/var/log/elite-setup"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

################################################################################
# Print functions
################################################################################
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

################################################################################
# Check if running as root
################################################################################
check_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

################################################################################
# Stop services
################################################################################
stop_services() {
    print_info "Stopping services..."
    
    local services=("nginx" "mongod" "pm2-root")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "${service}" 2>/dev/null; then
            print_info "Stopping ${service}..."
            systemctl stop "${service}" || print_warning "Failed to stop ${service}"
        fi
    done
}

################################################################################
# Restore configuration files
################################################################################
restore_configs() {
    print_info "Restoring configuration files..."
    
    # Find most recent backup
    local latest_backup=$(ls -t "${BACKUP_DIR}"/pre-install-*.tar.gz 2>/dev/null | head -n1)
    
    if [[ -z "${latest_backup}" ]]; then
        print_warning "No backup found to restore"
        return 0
    fi
    
    print_info "Found backup: ${latest_backup}"
    print_info "Extracting backup..."
    
    tar -xzf "${latest_backup}" -C / 2>/dev/null || {
        print_warning "Failed to extract some files from backup"
    }
    
    print_info "Configuration files restored"
}

################################################################################
# Remove installed packages (optional)
################################################################################
remove_packages() {
    read -p "Do you want to remove installed packages? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Skipping package removal"
        return 0
    fi
    
    print_warning "Removing packages..."
    
    # Detect package manager
    if command -v apt-get &> /dev/null; then
        apt-get remove -y nginx mongodb-org nodejs pm2 || true
        apt-get autoremove -y || true
    elif command -v yum &> /dev/null; then
        yum remove -y nginx mongodb-org nodejs pm2 || true
    elif command -v dnf &> /dev/null; then
        dnf remove -y nginx mongodb-org nodejs pm2 || true
    fi
    
    print_info "Packages removed"
}

################################################################################
# Clean up files
################################################################################
cleanup_files() {
    print_info "Cleaning up installation files..."
    
    local dirs_to_remove=(
        "/etc/elite-setup"
        "/var/log/elite-setup"
        "/var/lib/elite-setup"
    )
    
    for dir in "${dirs_to_remove[@]}"; do
        if [[ -d "${dir}" ]]; then
            print_info "Removing ${dir}..."
            rm -rf "${dir}"
        fi
    done
    
    print_info "Cleanup complete"
}

################################################################################
# Main rollback
################################################################################
main() {
    echo "========================================="
    echo "  Elite Setup - Rollback"
    echo "  Server: $(hostname)"
    echo "========================================="
    echo ""
    
    print_warning "This will rollback the Elite Setup installation"
    print_warning "The following actions will be performed:"
    echo "  1. Stop all installed services"
    echo "  2. Restore configuration files from backup"
    echo "  3. Optionally remove installed packages"
    echo "  4. Clean up installation files"
    echo ""
    
    read -p "Continue with rollback? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Rollback cancelled"
        exit 0
    fi
    
    check_root
    
    stop_services
    restore_configs
    remove_packages
    cleanup_files
    
    echo ""
    print_info "Rollback completed successfully"
    print_info "You may need to restart your server for all changes to take effect"
    echo ""
}

main "$@"
