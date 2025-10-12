#!/bin/bash

################################################################################
# Preflight Checks Library
# Pre-installation system validation
################################################################################

# Minimum requirements
readonly MIN_DISK_SPACE_GB=10
readonly MIN_RAM_GB=1
readonly MIN_CPU_CORES=1

################################################################################
# Run all preflight checks
################################################################################
run_preflight_checks() {
    print_header "Pre-flight System Checks"
    
    local checks_passed=0
    local checks_failed=0
    
    # Array of check functions
    local checks=(
        "check_root_privileges:Root Privileges"
        "check_os_compatibility:OS Compatibility"
        "check_internet_connectivity:Internet Connectivity"
        "check_disk_space:Disk Space"
        "check_memory:System Memory"
        "check_cpu:CPU Cores"
        "check_required_ports:Port Availability"
        "check_existing_services:Existing Services"
        "check_required_commands:Required Commands"
    )
    
    for check_info in "${checks[@]}"; do
        IFS=':' read -r check_func check_name <<< "${check_info}"
        
        echo -n "  Checking ${check_name}... "
        
        if ${check_func}; then
            print_success ""
            ((checks_passed++))
        else
            print_error ""
            ((checks_failed++))
        fi
    done
    
    echo ""
    
    if [[ $checks_failed -gt 0 ]]; then
        log_error "Preflight checks failed: ${checks_failed} failed, ${checks_passed} passed"
        print_error "Some preflight checks failed. Please fix the issues and try again."
        return 1
    else
        log_info "All preflight checks passed: ${checks_passed} passed"
        print_success "All preflight checks passed!"
        return 0
    fi
}

################################################################################
# Check root privileges
################################################################################
check_root_privileges() {
    if ! is_root; then
        log_error "Not running as root"
        return 1
    fi
    return 0
}

################################################################################
# Check OS compatibility
################################################################################
check_os_compatibility() {
    if ! is_os_supported; then
        local os_type=$(get_os_type)
        local os_version=$(get_os_version)
        log_error "Unsupported OS: ${os_type} ${os_version}"
        log_error "Supported: Ubuntu 20.04/22.04, Debian 11/12, CentOS/RHEL 8+"
        return 1
    fi
    
    local os_type=$(get_os_type)
    local os_version=$(get_os_version)
    log_info "Detected OS: ${os_type} ${os_version}"
    return 0
}

################################################################################
# Check internet connectivity
################################################################################
check_internet_connectivity() {
    if ! has_internet; then
        log_error "No internet connectivity"
        return 1
    fi
    
    # Test DNS resolution
    if ! nslookup google.com &>/dev/null && ! host google.com &>/dev/null; then
        log_error "DNS resolution failed"
        return 1
    fi
    
    return 0
}

################################################################################
# Check disk space
################################################################################
check_disk_space() {
    local available_space=$(get_available_space)
    
    if [[ $available_space -lt $MIN_DISK_SPACE_GB ]]; then
        log_error "Insufficient disk space: ${available_space}GB available, ${MIN_DISK_SPACE_GB}GB required"
        return 1
    fi
    
    log_info "Available disk space: ${available_space}GB"
    return 0
}

################################################################################
# Check memory
################################################################################
check_memory() {
    local total_ram=$(get_total_ram)
    
    if [[ $total_ram -lt $MIN_RAM_GB ]]; then
        log_error "Insufficient RAM: ${total_ram}GB available, ${MIN_RAM_GB}GB required"
        return 1
    fi
    
    log_info "Total RAM: ${total_ram}GB"
    return 0
}

################################################################################
# Check CPU
################################################################################
check_cpu() {
    local cpu_cores=$(get_cpu_cores)
    
    if [[ $cpu_cores -lt $MIN_CPU_CORES ]]; then
        log_error "Insufficient CPU cores: ${cpu_cores} available, ${MIN_CPU_CORES} required"
        return 1
    fi
    
    log_info "CPU cores: ${cpu_cores}"
    return 0
}

################################################################################
# Check required ports
################################################################################
check_required_ports() {
    local ports=(80 443 27017)
    local ports_in_use=()
    
    for port in "${ports[@]}"; do
        if is_port_in_use "${port}"; then
            local process=$(get_port_process "${port}")
            log_warning "Port ${port} is in use by: ${process}"
            ports_in_use+=("${port}")
        fi
    done
    
    if [[ ${#ports_in_use[@]} -gt 0 ]]; then
        log_warning "Some ports are already in use: ${ports_in_use[*]}"
        
        if [[ "${MODE}" == "interactive" && "${SILENT}" == false ]]; then
            echo ""
            print_warning "The following ports are in use:"
            for port in "${ports_in_use[@]}"; do
                echo "  - Port ${port}: $(get_port_process ${port})"
            done
            echo ""
            
            if ! ask_yes_no "Continue anyway?" "n"; then
                return 1
            fi
        fi
    fi
    
    return 0
}

################################################################################
# Check existing services
################################################################################
check_existing_services() {
    local services=("nginx" "mongodb" "mongod" "docker")
    local existing_services=()
    
    for service in "${services[@]}"; do
        if service_exists "${service}"; then
            if is_service_running "${service}"; then
                log_info "Service ${service} is already installed and running"
                existing_services+=("${service}")
            else
                log_info "Service ${service} is installed but not running"
            fi
        fi
    done
    
    if [[ ${#existing_services[@]} -gt 0 ]]; then
        log_info "Found existing services: ${existing_services[*]}"
        
        if [[ "${MODE}" == "interactive" && "${SILENT}" == false ]]; then
            echo ""
            print_info "The following services are already installed:"
            for service in "${existing_services[@]}"; do
                echo "  - ${service}"
            done
            echo ""
            print_warning "Installation will attempt to configure existing services."
            echo ""
        fi
    fi
    
    return 0
}

################################################################################
# Check required commands
################################################################################
check_required_commands() {
    local required_commands=("curl" "wget" "tar" "gzip" "systemctl")
    local missing_commands=()
    
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "${cmd}"; then
            log_warning "Required command not found: ${cmd}"
            missing_commands+=("${cmd}")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        log_info "Will install missing commands: ${missing_commands[*]}"
        
        # Try to install missing commands
        local pkg_manager=$(get_package_manager)
        case "${pkg_manager}" in
            apt)
                install_package ${missing_commands[@]}
                ;;
            yum|dnf)
                install_package ${missing_commands[@]}
                ;;
            *)
                log_error "Cannot install missing commands: unknown package manager"
                return 1
                ;;
        esac
    fi
    
    return 0
}

################################################################################
# Display system information
################################################################################
display_system_info() {
    print_header "System Information"
    
    echo ""
    print_table_row "Hostname" "$(hostname)" "${CYAN}"
    print_table_row "OS" "$(get_os_info)" "${CYAN}"
    print_table_row "Kernel" "$(uname -r)" "${CYAN}"
    print_table_row "Architecture" "$(uname -m)" "${CYAN}"
    print_table_row "CPU Cores" "$(get_cpu_cores)" "${CYAN}"
    print_table_row "Total RAM" "$(get_total_ram)GB" "${CYAN}"
    print_table_row "Available Disk" "$(get_available_space)GB" "${CYAN}"
    print_table_row "Public IP" "$(get_public_ip)" "${CYAN}"
    print_table_row "Package Manager" "$(get_package_manager)" "${CYAN}"
    echo ""
}

################################################################################
# Check system load
################################################################################
check_system_load() {
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    local cpu_cores=$(get_cpu_cores)
    local load_threshold=$(echo "${cpu_cores} * 2" | bc)
    
    if (( $(echo "${load_avg} > ${load_threshold}" | bc -l) )); then
        log_warning "High system load detected: ${load_avg} (${cpu_cores} cores)"
        
        if [[ "${MODE}" == "interactive" && "${SILENT}" == false ]]; then
            print_warning "System load is high. Installation may be slow."
            if ! ask_yes_no "Continue anyway?" "y"; then
                return 1
            fi
        fi
    fi
    
    return 0
}

################################################################################
# Check available updates
################################################################################
check_system_updates() {
    log_info "Checking for system updates..."
    
    local pkg_manager=$(get_package_manager)
    local updates_available=0
    
    case "${pkg_manager}" in
        apt)
            update_package_cache
            updates_available=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo "0")
            ;;
        yum|dnf)
            updates_available=$(${pkg_manager} check-update -q | grep -c "^[a-zA-Z]" || echo "0")
            ;;
    esac
    
    if [[ $updates_available -gt 0 ]]; then
        log_info "System updates available: ${updates_available}"
        
        if [[ "${MODE}" == "interactive" && "${SILENT}" == false ]]; then
            if ask_yes_no "Update system packages before installation?" "y"; then
                update_system_packages
            fi
        fi
    else
        log_info "System is up to date"
    fi
    
    return 0
}

################################################################################
# Verify system architecture
################################################################################
check_architecture() {
    local arch=$(uname -m)
    
    case "${arch}" in
        x86_64|amd64)
            log_info "Architecture: ${arch} (supported)"
            return 0
            ;;
        aarch64|arm64)
            log_warning "Architecture: ${arch} (experimental support)"
            if [[ "${MODE}" == "interactive" && "${SILENT}" == false ]]; then
                print_warning "ARM architecture has experimental support."
                if ! ask_yes_no "Continue anyway?" "n"; then
                    return 1
                fi
            fi
            return 0
            ;;
        *)
            log_error "Architecture: ${arch} (not supported)"
            return 1
            ;;
    esac
}

# Export functions
export -f run_preflight_checks
export -f check_root_privileges
export -f check_os_compatibility
export -f check_internet_connectivity
export -f check_disk_space
export -f check_memory
export -f check_cpu
export -f check_required_ports
export -f check_existing_services
export -f check_required_commands
export -f display_system_info
export -f check_system_load
export -f check_system_updates
export -f check_architecture
