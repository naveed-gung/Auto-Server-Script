#!/bin/bash

################################################################################
# Health Check Script
# Verifies all components are running correctly
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

################################################################################
# Print status
################################################################################
print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((CHECKS_PASSED++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((CHECKS_FAILED++))
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((CHECKS_WARNING++))
}

################################################################################
# Check Node.js
################################################################################
check_nodejs() {
    echo -n "Checking Node.js... "
    if command -v node &> /dev/null; then
        local version=$(node --version)
        print_pass "Node.js ${version}"
    else
        print_fail "Node.js not found"
    fi
}

################################################################################
# Check npm
################################################################################
check_npm() {
    echo -n "Checking npm... "
    if command -v npm &> /dev/null; then
        local version=$(npm --version)
        print_pass "npm ${version}"
    else
        print_fail "npm not found"
    fi
}

################################################################################
# Check MongoDB
################################################################################
check_mongodb() {
    echo -n "Checking MongoDB... "
    if systemctl is-active --quiet mongod; then
        local version=$(mongod --version | grep "db version" | awk '{print $3}')
        print_pass "MongoDB ${version} (running)"
    else
        print_fail "MongoDB not running"
    fi
}

################################################################################
# Check Nginx
################################################################################
check_nginx() {
    echo -n "Checking Nginx... "
    if systemctl is-active --quiet nginx; then
        local version=$(nginx -v 2>&1 | cut -d'/' -f2)
        print_pass "Nginx ${version} (running)"
    else
        print_fail "Nginx not running"
    fi
}

################################################################################
# Check PM2
################################################################################
check_pm2() {
    echo -n "Checking PM2... "
    if command -v pm2 &> /dev/null; then
        local version=$(pm2 --version)
        print_pass "PM2 ${version}"
    else
        print_fail "PM2 not found"
    fi
}

################################################################################
# Check Docker
################################################################################
check_docker() {
    echo -n "Checking Docker... "
    if command -v docker &> /dev/null; then
        if systemctl is-active --quiet docker; then
            local version=$(docker --version | cut -d' ' -f3 | tr -d ',')
            print_pass "Docker ${version} (running)"
        else
            print_warn "Docker installed but not running"
        fi
    else
        print_warn "Docker not installed (optional)"
    fi
}

################################################################################
# Check UFW Firewall
################################################################################
check_firewall() {
    echo -n "Checking Firewall... "
    if command -v ufw &> /dev/null; then
        if ufw status | grep -q "Status: active"; then
            print_pass "UFW active"
        else
            print_warn "UFW inactive"
        fi
    else
        print_warn "UFW not installed"
    fi
}

################################################################################
# Check Fail2ban
################################################################################
check_fail2ban() {
    echo -n "Checking Fail2ban... "
    if systemctl is-active --quiet fail2ban; then
        print_pass "Fail2ban active"
    else
        print_warn "Fail2ban not running"
    fi
}

################################################################################
# Check disk space
################################################################################
check_disk_space() {
    echo -n "Checking Disk Space... "
    local usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    if [[ $usage -lt 80 ]]; then
        print_pass "Disk usage: ${usage}%"
    elif [[ $usage -lt 90 ]]; then
        print_warn "Disk usage: ${usage}% (getting full)"
    else
        print_fail "Disk usage: ${usage}% (critically full)"
    fi
}

################################################################################
# Check memory
################################################################################
check_memory() {
    echo -n "Checking Memory... "
    local usage=$(free | awk 'NR==2 {printf "%.0f", $3*100/$2}')
    if [[ $usage -lt 80 ]]; then
        print_pass "Memory usage: ${usage}%"
    elif [[ $usage -lt 90 ]]; then
        print_warn "Memory usage: ${usage}% (high)"
    else
        print_fail "Memory usage: ${usage}% (critically high)"
    fi
}

################################################################################
# Check ports
################################################################################
check_ports() {
    local ports=(80 443 27017)
    for port in "${ports[@]}"; do
        echo -n "Checking port ${port}... "
        if netstat -tuln 2>/dev/null | grep -q ":${port} " || ss -tuln 2>/dev/null | grep -q ":${port} "; then
            print_pass "Port ${port} in use"
        else
            print_warn "Port ${port} not in use"
        fi
    done
}

################################################################################
# Main health check
################################################################################
main() {
    echo "========================================="
    echo "  Elite Setup - Health Check"
    echo "  Server: $(hostname)"
    echo "  Date: $(date)"
    echo "========================================="
    echo ""
    
    check_nodejs
    check_npm
    check_mongodb
    check_nginx
    check_pm2
    check_docker
    check_firewall
    check_fail2ban
    check_disk_space
    check_memory
    check_ports
    
    echo ""
    echo "========================================="
    echo "  Summary"
    echo "========================================="
    echo -e "${GREEN}Passed:${NC}  ${CHECKS_PASSED}"
    echo -e "${YELLOW}Warnings:${NC} ${CHECKS_WARNING}"
    echo -e "${RED}Failed:${NC}  ${CHECKS_FAILED}"
    echo ""
    
    if [[ $CHECKS_FAILED -gt 0 ]]; then
        echo "Some health checks failed. Please review the output above."
        exit 1
    elif [[ $CHECKS_WARNING -gt 0 ]]; then
        echo "All critical checks passed, but some warnings were found."
        exit 0
    else
        echo "All health checks passed successfully!"
        exit 0
    fi
}

main "$@"
