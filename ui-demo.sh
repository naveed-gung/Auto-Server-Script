#!/bin/bash
################################################################################
# UI Demo Script - Shows the Elite Setup Interface
################################################################################

# Source the colors library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/colors.sh"

clear

# Show Banner
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
║          Elite Auto Server Setup - Version 1.0.0                     ║
║          Professional Server Provisioning System                     ║
║          Created by: naveed-gung | naveed-gung.dev                   ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
echo ""

# Show Installation Plan
print_header "Installation Plan"
echo ""
print_table_row "Profile" "Production" "${BOLD_CYAN}"
print_table_row "Domain" "example.com" "${CYAN}"
print_table_row "SSL Email" "admin@example.com" "${CYAN}"
echo ""
echo -e "${BOLD}Components to Install:${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} Node.js 20 (LTS)"
echo -e "  ${GREEN}✓${NC} MongoDB 7.0 (with authentication)"
echo -e "  ${GREEN}✓${NC} Nginx (with Let's Encrypt SSL)"
echo -e "  ${GREEN}✓${NC} PM2 (max instances)"
echo -e "  ${GREEN}✓${NC} Docker + docker-compose"
echo ""
echo -e "${BOLD}Security Features:${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} UFW Firewall"
echo -e "  ${GREEN}✓${NC} Fail2ban"
echo -e "  ${GREEN}✓${NC} Automatic Security Updates"
echo -e "  ${GREEN}✓${NC} SSH Hardening"
echo ""

# Show Progress
print_header "Installation Progress"
echo ""
print_step "1" "5" "Installing Node.js"
sleep 1
print_success "Node.js v20.11.0 installed successfully"
echo ""

print_step "2" "5" "Installing MongoDB"
sleep 1
print_success "MongoDB 7.0.5 installed and running"
echo ""

print_step "3" "5" "Installing Nginx"
sleep 1
print_success "Nginx 1.24.0 installed and configured"
echo ""

print_step "4" "5" "Installing PM2"
sleep 1
print_success "PM2 5.3.0 installed globally"
echo ""

print_step "5" "5" "Applying Security Hardening"
sleep 1
print_success "Security hardening completed"
echo ""

# Show Health Check Results
print_header "Post-Installation Health Check"
echo ""
echo -n "  Node.js: "
print_success "v20.11.0"
echo -n "  MongoDB: "
print_success "Running on port 27017"
echo -n "  Nginx: "
print_success "Running on ports 80, 443"
echo -n "  PM2: "
print_success "Ready for deployments"
echo -n "  Firewall: "
print_success "Active and configured"
echo ""

# Show Completion
echo ""
print_box \
    "🎉 Congratulations! Your server is now ready for production." \
    "" \
    "Installation completed in 245s" \
    "" \
    "📊 Deployment Report: /var/log/elite-setup/report.html" \
    "📋 Security Checklist: /var/log/elite-setup/security-checklist.txt" \
    "📝 Installation Log: /var/log/elite-setup/install.log"
echo ""

echo -e "${BOLD_CYAN}Next Steps:${NC}"
echo ""
echo "1. Review the security checklist"
echo "2. Set up SSH key-based authentication"
echo "3. Deploy your first application using PM2"
echo "4. Configure monitoring and backups"
echo ""

echo -e "${BOLD_GREEN}Your domain:${NC} https://example.com"
echo ""

# Show all UI elements
print_header "UI Components Showcase"
echo ""

echo -e "${BOLD}Status Messages:${NC}"
echo ""
print_success "Success message example"
print_error "Error message example"
print_warning "Warning message example"
print_info "Info message example"
echo ""

echo -e "${BOLD}Progress Bar:${NC}"
echo ""
for i in {1..5}; do
    print_progress "$i" "5" "Processing"
    sleep 0.3
done
echo ""

echo -e "${BOLD}Table Format:${NC}"
echo ""
print_table_row "Hostname" "elite-server-01" "${CYAN}"
print_table_row "IP Address" "192.168.1.100" "${CYAN}"
print_table_row "OS" "Ubuntu 22.04 LTS" "${CYAN}"
print_table_row "Memory" "8GB RAM" "${CYAN}"
print_table_row "Disk" "50GB Available" "${CYAN}"
echo ""

echo -e "${BOLD}Color Palette:${NC}"
echo ""
echo -e "  ${RED}■${NC} Red (Errors)"
echo -e "  ${GREEN}■${NC} Green (Success)"
echo -e "  ${YELLOW}■${NC} Yellow (Warnings)"
echo -e "  ${BLUE}■${NC} Blue (Information)"
echo -e "  ${MAGENTA}■${NC} Magenta (Highlights)"
echo -e "  ${CYAN}■${NC} Cyan (Headers)"
echo ""

print_header "Demo Complete!"
echo ""
echo -e "${BOLD_GREEN}✓ All UI components are working perfectly!${NC}"
echo ""
echo -e "${CYAN}Run './setup.sh --help' for full documentation${NC}"
echo -e "${CYAN}Run './setup.sh' to start the interactive installation${NC}"
echo ""
echo -e "${DIM}Created by: naveed-gung | Portfolio: https://naveed-gung.dev${NC}"
echo ""
