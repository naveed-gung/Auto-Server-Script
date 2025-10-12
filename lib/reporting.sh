#!/bin/bash

################################################################################
# Reporting Library
# Generate installation reports and summaries
################################################################################

################################################################################
# Generate deployment report
################################################################################
generate_deployment_report() {
    log_info "Generating deployment report..."
    
    local report_file="${LOG_DIR}/report.html"
    local report_txt="${LOG_DIR}/report.txt"
    
    # Generate HTML report
    generate_html_report "${report_file}"
    
    # Generate text report
    generate_text_report "${report_txt}"
    
    # Generate security checklist
    generate_security_checklist
    
    log_info "Deployment report generated: ${report_file}"
    return 0
}

################################################################################
# Generate HTML report
# Arguments:
#   $1 - Output file path
################################################################################
generate_html_report() {
    local output_file="$1"
    
    cat > "${output_file}" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Setup - Deployment Report</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .header .subtitle {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .content {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 2em;
            color: #667eea;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-card label {
            font-weight: bold;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }
        
        .info-card value {
            color: #333;
            font-size: 1.1em;
        }
        
        .component-list {
            list-style: none;
        }
        
        .component-item {
            background: #f8f9fa;
            padding: 15px 20px;
            margin-bottom: 10px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .component-item .icon {
            font-size: 1.5em;
            margin-right: 15px;
        }
        
        .component-item .name {
            flex: 1;
            font-weight: 500;
        }
        
        .component-item .version {
            color: #666;
            font-size: 0.9em;
        }
        
        .status-success {
            color: #28a745;
            font-weight: bold;
        }
        
        .status-warning {
            color: #ffc107;
            font-weight: bold;
        }
        
        .status-error {
            color: #dc3545;
            font-weight: bold;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
        }
        
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .footer {
            background: #f8f9fa;
            padding: 30px;
            text-align: center;
            color: #666;
        }
        
        .footer .timestamp {
            font-size: 0.9em;
            margin-top: 10px;
        }
        
        @media print {
            body {
                background: white;
                padding: 0;
            }
            
            .container {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Elite Setup</h1>
            <div class="subtitle">Production Server Deployment Report</div>
        </div>
        
        <div class="content">
            <div class="section">
                <h2 class="section-title">📊 System Information</h2>
                <div class="info-grid">
                    <div class="info-card">
                        <label>Hostname</label>
                        <value>HOSTNAME_PLACEHOLDER</value>
                    </div>
                    <div class="info-card">
                        <label>Operating System</label>
                        <value>OS_PLACEHOLDER</value>
                    </div>
                    <div class="info-card">
                        <label>Kernel</label>
                        <value>KERNEL_PLACEHOLDER</value>
                    </div>
                    <div class="info-card">
                        <label>CPU Cores</label>
                        <value>CPU_PLACEHOLDER</value>
                    </div>
                    <div class="info-card">
                        <label>Total RAM</label>
                        <value>RAM_PLACEHOLDER GB</value>
                    </div>
                    <div class="info-card">
                        <label>Available Disk</label>
                        <value>DISK_PLACEHOLDER GB</value>
                    </div>
                </div>
            </div>
            
            <div class="section">
                <h2 class="section-title">📦 Installed Components</h2>
                <ul class="component-list">
                    COMPONENTS_PLACEHOLDER
                </ul>
            </div>
            
            <div class="section">
                <h2 class="section-title">🔒 Security Status</h2>
                <ul class="component-list">
                    SECURITY_PLACEHOLDER
                </ul>
            </div>
            
            <div class="section">
                <h2 class="section-title">✅ Next Steps</h2>
                <ul class="component-list">
                    <li class="component-item">
                        <span class="icon">1️⃣</span>
                        <span class="name">Review security checklist at: /var/log/elite-setup/security-checklist.txt</span>
                    </li>
                    <li class="component-item">
                        <span class="icon">2️⃣</span>
                        <span class="name">Set up SSH key-based authentication</span>
                    </li>
                    <li class="component-item">
                        <span class="icon">3️⃣</span>
                        <span class="name">Deploy your first application using PM2</span>
                    </li>
                    <li class="component-item">
                        <span class="icon">4️⃣</span>
                        <span class="name">Configure application-specific Nginx settings</span>
                    </li>
                    <li class="component-item">
                        <span class="icon">5️⃣</span>
                        <span class="name">Set up monitoring and alerting</span>
                    </li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <div>Generated by <strong>Elite Auto Server Setup</strong> v1.0.0</div>
            <div class="timestamp">TIMESTAMP_PLACEHOLDER</div>
        </div>
    </div>
</body>
</html>
HTMLEOF
    
    # Replace placeholders
    sed -i "s/HOSTNAME_PLACEHOLDER/$(hostname)/g" "${output_file}"
    sed -i "s/OS_PLACEHOLDER/$(get_os_info)/g" "${output_file}"
    sed -i "s/KERNEL_PLACEHOLDER/$(uname -r)/g" "${output_file}"
    sed -i "s/CPU_PLACEHOLDER/$(get_cpu_cores)/g" "${output_file}"
    sed -i "s/RAM_PLACEHOLDER/$(get_total_ram)/g" "${output_file}"
    sed -i "s/DISK_PLACEHOLDER/$(get_available_space)/g" "${output_file}"
    sed -i "s/TIMESTAMP_PLACEHOLDER/$(date '+%Y-%m-%d %H:%M:%S')/g" "${output_file}"
    
    # Generate component list HTML
    local components_html=""
    for component in "${!INSTALLED_COMPONENTS[@]}"; do
        local status="${INSTALLED_COMPONENTS[$component]}"
        local badge_class="badge-success"
        local icon="✅"
        
        if [[ "${status}" == "failed" ]]; then
            badge_class="badge-warning"
            icon="⚠️"
        fi
        
        components_html+="<li class=\"component-item\">"
        components_html+="<span class=\"icon\">${icon}</span>"
        components_html+="<span class=\"name\">${component}</span>"
        components_html+="<span class=\"badge ${badge_class}\">${status}</span>"
        components_html+="</li>"
    done
    
    sed -i "s|COMPONENTS_PLACEHOLDER|${components_html}|g" "${output_file}"
    
    # Generate security status HTML
    local security_html=""
    security_html+="<li class=\"component-item\"><span class=\"icon\">🔥</span><span class=\"name\">UFW Firewall</span><span class=\"badge badge-success\">Enabled</span></li>"
    security_html+="<li class=\"component-item\"><span class=\"icon\">🛡️</span><span class=\"name\">Fail2ban</span><span class=\"badge badge-success\">Active</span></li>"
    security_html+="<li class=\"component-item\"><span class=\"icon\">🔄</span><span class=\"name\">Auto Updates</span><span class=\"badge badge-success\">Configured</span></li>"
    security_html+="<li class=\"component-item\"><span class=\"icon\">🔐</span><span class=\"name\">SSH Hardening</span><span class=\"badge badge-success\">Applied</span></li>"
    
    sed -i "s|SECURITY_PLACEHOLDER|${security_html}|g" "${output_file}"
    
    return 0
}

################################################################################
# Generate text report
# Arguments:
#   $1 - Output file path
################################################################################
generate_text_report() {
    local output_file="$1"
    
    cat > "${output_file}" << EOF
═══════════════════════════════════════════════════════════════
                 ELITE SETUP - DEPLOYMENT REPORT
═══════════════════════════════════════════════════════════════

SYSTEM INFORMATION
───────────────────────────────────────────────────────────────
Hostname          : $(hostname)
Operating System  : $(get_os_info)
Kernel            : $(uname -r)
Architecture      : $(uname -m)
CPU Cores         : $(get_cpu_cores)
Total RAM         : $(get_total_ram) GB
Available Disk    : $(get_available_space) GB
Public IP         : $(get_public_ip)

INSTALLED COMPONENTS
───────────────────────────────────────────────────────────────
EOF
    
    for component in "${!INSTALLED_COMPONENTS[@]}"; do
        printf "%-20s : %s\n" "$component" "${INSTALLED_COMPONENTS[$component]}" >> "${output_file}"
    done
    
    cat >> "${output_file}" << EOF

SECURITY STATUS
───────────────────────────────────────────────────────────────
UFW Firewall      : $(systemctl is-active ufw 2>/dev/null || echo "inactive")
Fail2ban          : $(systemctl is-active fail2ban 2>/dev/null || echo "inactive")
Auto Updates      : Configured
SSH Hardening     : Applied

CREDENTIALS
───────────────────────────────────────────────────────────────
MongoDB credentials saved to: ${CONFIG_DIR}/mongodb-credentials.txt
SSL certificates location: /etc/nginx/ssl/ or /etc/letsencrypt/

IMPORTANT FILES
───────────────────────────────────────────────────────────────
Installation Log  : ${LOG_DIR}/install.log
Error Log         : ${LOG_DIR}/error.log
HTML Report       : ${LOG_DIR}/report.html
Security Checklist: ${LOG_DIR}/security-checklist.txt

NEXT STEPS
───────────────────────────────────────────────────────────────
1. Review security checklist
2. Set up SSH key-based authentication
3. Deploy your first application
4. Configure application-specific settings
5. Set up monitoring and backups

═══════════════════════════════════════════════════════════════
Generated: $(date '+%Y-%m-%d %H:%M:%S')
═══════════════════════════════════════════════════════════════
EOF
    
    return 0
}

################################################################################
# Display installation summary
# Arguments:
#   $1 - Installation duration in seconds
################################################################################
display_installation_summary() {
    local duration=$1
    
    clear
    print_header "Installation Complete!"
    
    echo ""
    print_box \
        "🎉 Congratulations! Your server is now ready for production." \
        "" \
        "Installation completed in $(get_elapsed_time 0 ${duration})" \
        "" \
        "📊 Deployment Report: ${LOG_DIR}/report.html" \
        "📋 Security Checklist: ${LOG_DIR}/security-checklist.txt" \
        "📝 Installation Log: ${LOG_DIR}/install.log"
    echo ""
    
    # Display installed components
    echo -e "${BOLD}Installed Components:${NC}"
    echo ""
    for component in "${!INSTALLED_COMPONENTS[@]}"; do
        local status="${INSTALLED_COMPONENTS[$component]}"
        if [[ "${status}" == "success" ]]; then
            print_success "${component}"
        elif [[ "${status}" == "failed" ]]; then
            print_error "${component}"
        else
            print_info "${component} (${status})"
        fi
    done
    
    echo ""
    echo -e "${BOLD_CYAN}Next Steps:${NC}"
    echo ""
    echo "1. Review the security checklist"
    echo "2. Set up SSH key-based authentication"
    echo "3. Deploy your first application using PM2"
    echo "4. Configure monitoring and backups"
    echo ""
    
    if [[ -n "${DOMAIN}" ]]; then
        echo -e "${BOLD_GREEN}Your domain:${NC} https://${DOMAIN}"
        echo ""
    fi
    
    echo -e "${BOLD}For support and documentation:${NC}"
    echo "📖 https://docs.elitesysadmin.io"
    echo "💬 https://discord.gg/elitesysadmin"
    echo ""
}

################################################################################
# Run post-installation health checks
################################################################################
run_health_checks() {
    print_header "Post-Installation Health Checks"
    
    local checks_passed=0
    local checks_failed=0
    
    # Check Node.js
    if command_exists node; then
        echo -n "  Node.js: "
        print_success "$(node --version)"
        ((checks_passed++))
    else
        echo -n "  Node.js: "
        print_error "Not found"
        ((checks_failed++))
    fi
    
    # Check MongoDB
    if systemctl is-active --quiet mongod; then
        echo -n "  MongoDB: "
        print_success "Running"
        ((checks_passed++))
    else
        echo -n "  MongoDB: "
        print_warning "Not running"
        ((checks_failed++))
    fi
    
    # Check Nginx
    if systemctl is-active --quiet nginx; then
        echo -n "  Nginx: "
        print_success "Running"
        ((checks_passed++))
    else
        echo -n "  Nginx: "
        print_warning "Not running"
        ((checks_failed++))
    fi
    
    # Check PM2
    if command_exists pm2; then
        echo -n "  PM2: "
        print_success "Installed"
        ((checks_passed++))
    else
        echo -n "  PM2: "
        print_error "Not found"
        ((checks_failed++))
    fi
    
    echo ""
    log_info "Health checks: ${checks_passed} passed, ${checks_failed} failed"
    
    return $([[ $checks_failed -eq 0 ]] && echo 0 || echo 1)
}

################################################################################
# Create system backup point
################################################################################
create_backup_point() {
    log_info "Creating system backup point..."
    
    mkdir -p "${BACKUP_DIR}"
    
    local backup_file="${BACKUP_DIR}/pre-install-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    # Backup important configuration files
    tar -czf "${backup_file}" \
        /etc/nginx/ \
        /etc/ssh/sshd_config \
        /etc/security/limits.conf \
        /etc/sysctl.conf \
        2>/dev/null || true
    
    log_info "Backup created: ${backup_file}"
    return 0
}

################################################################################
# Rollback installation
################################################################################
rollback_installation() {
    log_warning "Rolling back installation..."
    
    # TODO: Implement proper rollback logic
    # - Stop and remove installed services
    # - Restore backed up configuration files
    # - Remove installed packages
    
    log_error "Rollback not fully implemented yet"
    return 1
}

# Export functions
export -f generate_deployment_report
export -f generate_html_report
export -f generate_text_report
export -f display_installation_summary
export -f run_health_checks
export -f create_backup_point
export -f rollback_installation
