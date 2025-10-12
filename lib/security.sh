#!/bin/bash

################################################################################
# Security Hardening Library
# Security configuration and hardening functions
################################################################################

################################################################################
# Configure security hardening
################################################################################
configure_security() {
    log_info "Applying security hardening..."
    
    local tasks=(
        "configure_firewall:Configuring Firewall"
        "install_fail2ban:Installing Fail2ban"
        "configure_auto_updates:Configuring Auto-Updates"
        "harden_ssh:Hardening SSH"
        "configure_system_limits:Configuring System Limits"
    )
    
    for task_info in "${tasks[@]}"; do
        IFS=':' read -r task_func task_name <<< "${task_info}"
        
        if ${task_func}; then
            log_info "${task_name} completed"
        else
            log_warning "${task_name} failed"
        fi
    done
    
    return 0
}

################################################################################
# Configure UFW firewall
################################################################################
configure_firewall() {
    if [[ "${CONFIG[firewall_enabled]}" != "true" || "${SKIP_FIREWALL}" == true ]]; then
        log_info "Skipping firewall configuration"
        return 0
    fi
    
    log_info "Configuring UFW firewall..."
    
    # Install UFW
    local pkg_manager=$(get_package_manager)
    case "${pkg_manager}" in
        apt)
            apt-get install -y ufw
            ;;
        yum|dnf)
            ${pkg_manager} install -y ufw
            ;;
    esac
    
    # Reset UFW to defaults
    ufw --force reset
    
    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing
    
    # Allow SSH (be careful not to lock yourself out!)
    ufw allow 22/tcp comment 'SSH'
    
    # Allow HTTP and HTTPS
    ufw allow 80/tcp comment 'HTTP'
    ufw allow 443/tcp comment 'HTTPS'
    
    # Allow MongoDB (localhost only)
    ufw allow from 127.0.0.1 to any port 27017 comment 'MongoDB'
    
    # Enable UFW
    ufw --force enable
    
    # Enable UFW service
    systemctl enable ufw
    systemctl start ufw
    
    log_info "Firewall configured successfully"
    ufw status verbose
    
    return 0
}

################################################################################
# Install and configure fail2ban
################################################################################
install_fail2ban() {
    if [[ "${CONFIG[fail2ban_enabled]}" != "true" ]]; then
        log_info "Skipping fail2ban installation"
        return 0
    fi
    
    log_info "Installing fail2ban..."
    
    # Install fail2ban
    local pkg_manager=$(get_package_manager)
    case "${pkg_manager}" in
        apt)
            apt-get install -y fail2ban
            ;;
        yum|dnf)
            ${pkg_manager} install -y fail2ban fail2ban-systemd
            ;;
    esac
    
    # Create local configuration
    cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
destemail = root@localhost
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s

[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log

[nginx-noscript]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log

[nginx-badbots]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log

[nginx-noproxy]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log
EOF
    
    # Start and enable fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
    
    log_info "fail2ban installed and configured"
    fail2ban-client status
    
    return 0
}

################################################################################
# Configure automatic security updates
################################################################################
configure_auto_updates() {
    if [[ "${CONFIG[auto_updates]}" != "true" ]]; then
        log_info "Skipping automatic updates configuration"
        return 0
    fi
    
    log_info "Configuring automatic security updates..."
    
    local pkg_manager=$(get_package_manager)
    
    case "${pkg_manager}" in
        apt)
            # Install unattended-upgrades
            apt-get install -y unattended-upgrades apt-listchanges
            
            # Configure unattended-upgrades
            cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}:${distro_codename}-updates";
};

Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF
            
            # Enable automatic updates
            cat > /etc/apt/apt.conf.d/20auto-upgrades << 'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
            
            # Test configuration
            unattended-upgrades --dry-run --debug
            ;;
        yum|dnf)
            # Install yum-cron or dnf-automatic
            if [[ "${pkg_manager}" == "dnf" ]]; then
                ${pkg_manager} install -y dnf-automatic
                
                # Configure dnf-automatic
                sed -i 's/^apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
                
                # Enable and start
                systemctl enable --now dnf-automatic.timer
            else
                ${pkg_manager} install -y yum-cron
                
                # Configure yum-cron
                sed -i 's/^apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
                
                # Enable and start
                systemctl enable --now yum-cron
            fi
            ;;
    esac
    
    log_info "Automatic security updates configured"
    return 0
}

################################################################################
# Harden SSH configuration
################################################################################
harden_ssh() {
    if [[ "${CONFIG[ssh_hardening]}" != "true" ]]; then
        log_info "Skipping SSH hardening"
        return 0
    fi
    
    log_info "Hardening SSH configuration..."
    
    local ssh_config="/etc/ssh/sshd_config"
    backup_file "${ssh_config}"
    
    # Apply SSH hardening settings
    declare -A ssh_settings=(
        ["PermitRootLogin"]="prohibit-password"
        ["PasswordAuthentication"]="yes"
        ["PubkeyAuthentication"]="yes"
        ["PermitEmptyPasswords"]="no"
        ["ChallengeResponseAuthentication"]="no"
        ["UsePAM"]="yes"
        ["X11Forwarding"]="no"
        ["PrintMotd"]="no"
        ["AcceptEnv"]="LANG LC_*"
        ["ClientAliveInterval"]="300"
        ["ClientAliveCountMax"]="2"
        ["MaxAuthTries"]="3"
        ["MaxSessions"]="10"
        ["Protocol"]="2"
    )
    
    for setting in "${!ssh_settings[@]}"; do
        local value="${ssh_settings[$setting]}"
        
        # Comment out existing setting
        sed -i "s/^${setting}/#${setting}/" "${ssh_config}"
        
        # Add new setting at the end if not exists
        if ! grep -q "^${setting} ${value}" "${ssh_config}"; then
            echo "${setting} ${value}" >> "${ssh_config}"
        fi
    done
    
    # Test SSH configuration
    if ! sshd -t; then
        log_error "SSH configuration test failed"
        restore_file "${ssh_config}"
        return 1
    fi
    
    # Restart SSH service
    systemctl restart sshd || systemctl restart ssh
    
    log_info "SSH hardening complete"
    log_warning "NOTE: Make sure you have SSH key access before disabling password authentication!"
    
    return 0
}

################################################################################
# Configure system limits
################################################################################
configure_system_limits() {
    log_info "Configuring system limits..."
    
    # Configure limits.conf
    cat >> /etc/security/limits.conf << 'EOF'

# Elite Setup - System Limits
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
root soft nofile 65536
root hard nofile 65536
EOF
    
    # Configure sysctl
    cat > /etc/sysctl.d/99-elite-setup.conf << 'EOF'
# Elite Setup - Kernel Parameters

# Network Performance
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65536
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.ip_local_port_range = 1024 65535

# TCP Tuning
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15

# File System
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288

# Security
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
EOF
    
    # Apply sysctl settings
    sysctl -p /etc/sysctl.d/99-elite-setup.conf
    
    log_info "System limits configured"
    return 0
}

################################################################################
# Generate security checklist
################################################################################
generate_security_checklist() {
    local checklist_file="${LOG_DIR}/security-checklist.txt"
    
    log_info "Generating security checklist..."
    
    cat > "${checklist_file}" << EOF
═══════════════════════════════════════════════════════════════
                    SECURITY CHECKLIST
═══════════════════════════════════════════════════════════════

Server: $(hostname)
Date: $(date)

AUTOMATED SECURITY MEASURES
───────────────────────────────────────────────────────────────
EOF
    
    # Check each security measure
    if systemctl is-active --quiet ufw; then
        echo "✓ UFW Firewall: ENABLED" >> "${checklist_file}"
    else
        echo "✗ UFW Firewall: DISABLED" >> "${checklist_file}"
    fi
    
    if systemctl is-active --quiet fail2ban; then
        echo "✓ Fail2ban: ENABLED" >> "${checklist_file}"
    else
        echo "✗ Fail2ban: DISABLED" >> "${checklist_file}"
    fi
    
    if systemctl is-enabled --quiet unattended-upgrades 2>/dev/null; then
        echo "✓ Automatic Updates: ENABLED" >> "${checklist_file}"
    else
        echo "✗ Automatic Updates: DISABLED" >> "${checklist_file}"
    fi
    
    echo "" >> "${checklist_file}"
    echo "MANUAL SECURITY TASKS" >> "${checklist_file}"
    echo "───────────────────────────────────────────────────────────────" >> "${checklist_file}"
    echo "□ Set up SSH key-based authentication" >> "${checklist_file}"
    echo "□ Disable SSH password authentication (after key setup)" >> "${checklist_file}"
    echo "□ Configure MongoDB backup schedule" >> "${checklist_file}"
    echo "□ Review and update application security settings" >> "${checklist_file}"
    echo "□ Set up monitoring and alerting" >> "${checklist_file}"
    echo "□ Configure log rotation" >> "${checklist_file}"
    echo "□ Review firewall rules" >> "${checklist_file}"
    echo "□ Set up SSL certificate renewal monitoring" >> "${checklist_file}"
    echo "" >> "${checklist_file}"
    echo "═══════════════════════════════════════════════════════════════" >> "${checklist_file}"
    
    log_info "Security checklist saved to: ${checklist_file}"
    return 0
}

################################################################################
# Audit system security
################################################################################
audit_system_security() {
    log_info "Performing security audit..."
    
    print_header "Security Audit"
    
    # Check firewall status
    echo -n "Firewall (UFW): "
    if systemctl is-active --quiet ufw; then
        print_success "Active"
    else
        print_error "Inactive"
    fi
    
    # Check fail2ban status
    echo -n "Fail2ban: "
    if systemctl is-active --quiet fail2ban; then
        print_success "Active"
    else
        print_error "Inactive"
    fi
    
    # Check for automatic updates
    echo -n "Automatic Updates: "
    if systemctl is-enabled --quiet unattended-upgrades 2>/dev/null; then
        print_success "Enabled"
    else
        print_error "Disabled"
    fi
    
    # Check SSH configuration
    echo -n "SSH Root Login: "
    local root_login=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
    if [[ "${root_login}" == "no" || "${root_login}" == "prohibit-password" ]]; then
        print_success "Restricted (${root_login})"
    else
        print_warning "Allowed"
    fi
    
    echo ""
}

# Export functions
export -f configure_security
export -f configure_firewall
export -f install_fail2ban
export -f configure_auto_updates
export -f harden_ssh
export -f configure_system_limits
export -f generate_security_checklist
export -f audit_system_security
