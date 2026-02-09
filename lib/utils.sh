#!/bin/bash

################################################################################
# Utility Functions Library
# Collection of reusable utility functions
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

################################################################################
# Check if command exists
# Arguments:
#   $1 - Command name
################################################################################
command_exists() {
    command -v "$1" &> /dev/null
}

################################################################################
# Check if running as root
################################################################################
is_root() {
    [[ "${EUID}" -eq 0 ]]
}

################################################################################
# Get OS type
################################################################################
get_os_type() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${ID}"
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

################################################################################
# Get OS version
################################################################################
get_os_version() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${VERSION_ID}"
    else
        echo "unknown"
    fi
}

################################################################################
# Check if OS is supported
################################################################################
is_os_supported() {
    local os_type=$(get_os_type)
    local os_version=$(get_os_version)
    
    case "${os_type}" in
        ubuntu)
            [[ "${os_version}" == "20.04" || "${os_version}" == "22.04" || "${os_version}" == "24.04" ]]
            ;;
        debian)
            [[ "${os_version}" == "11" || "${os_version}" == "12" ]]
            ;;
        centos|rhel|rocky|almalinux)
            [[ "${os_version}" =~ ^[89] ]]
            ;;
        *)
            return 1
            ;;
    esac
}

################################################################################
# Get package manager
################################################################################
get_package_manager() {
    if command_exists apt-get; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

################################################################################
# Install package
# Arguments:
#   $@ - Package names
################################################################################
install_package() {
    local pkg_manager=$(get_package_manager)
    local packages="$@"
    
    log_debug "Installing packages: ${packages}"
    
    case "${pkg_manager}" in
        apt)
            DEBIAN_FRONTEND=noninteractive apt-get install -y ${packages}
            ;;
        yum|dnf)
            ${pkg_manager} install -y ${packages}
            ;;
        *)
            log_error "Unknown package manager"
            return 1
            ;;
    esac
}

################################################################################
# Update package cache
################################################################################
update_package_cache() {
    local pkg_manager=$(get_package_manager)
    
    log_info "Updating package cache..."
    
    case "${pkg_manager}" in
        apt)
            apt-get update -qq
            ;;
        yum|dnf)
            ${pkg_manager} makecache -q
            ;;
        *)
            log_error "Unknown package manager"
            return 1
            ;;
    esac
}

################################################################################
# Get available disk space in GB
# Arguments:
#   $1 - Path (default: /)
################################################################################
get_available_space() {
    local path="${1:-/}"
    df -BG "${path}" | awk 'NR==2 {print $4}' | sed 's/G//'
}

################################################################################
# Get total RAM in GB
################################################################################
get_total_ram() {
    free -g | awk 'NR==2 {print $2}'
}

################################################################################
# Get CPU cores
################################################################################
get_cpu_cores() {
    nproc
}

################################################################################
# Check if port is in use
# Arguments:
#   $1 - Port number
################################################################################
is_port_in_use() {
    local port=$1
    netstat -tuln 2>/dev/null | grep -q ":${port} " || \
    ss -tuln 2>/dev/null | grep -q ":${port} "
}

################################################################################
# Get process using port
# Arguments:
#   $1 - Port number
################################################################################
get_port_process() {
    local port=$1
    lsof -i ":${port}" -t 2>/dev/null || \
    ss -tlnp 2>/dev/null | grep ":${port}" | awk '{print $6}' | cut -d',' -f2 | cut -d'=' -f2
}

################################################################################
# Generate random password
# Arguments:
#   $1 - Length (default: 32)
################################################################################
generate_password() {
    local length="${1:-32}"
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c "${length}"
}

################################################################################
# Generate random alphanumeric string
# Arguments:
#   $1 - Length (default: 16)
################################################################################
generate_random_string() {
    local length="${1:-16}"
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "${length}"
}

################################################################################
# Check if service exists
# Arguments:
#   $1 - Service name
################################################################################
service_exists() {
    systemctl list-unit-files | grep -q "^${1}.service"
}

################################################################################
# Check if service is running
# Arguments:
#   $1 - Service name
################################################################################
is_service_running() {
    systemctl is-active --quiet "$1"
}

################################################################################
# Check if service is enabled
# Arguments:
#   $1 - Service name
################################################################################
is_service_enabled() {
    systemctl is-enabled --quiet "$1"
}

################################################################################
# Start service
# Arguments:
#   $1 - Service name
################################################################################
start_service() {
    local service="$1"
    log_info "Starting service: ${service}"
    systemctl start "${service}"
}

################################################################################
# Stop service
# Arguments:
#   $1 - Service name
################################################################################
stop_service() {
    local service="$1"
    log_info "Stopping service: ${service}"
    systemctl stop "${service}"
}

################################################################################
# Enable service
# Arguments:
#   $1 - Service name
################################################################################
enable_service() {
    local service="$1"
    log_info "Enabling service: ${service}"
    systemctl enable "${service}"
}

################################################################################
# Restart service
# Arguments:
#   $1 - Service name
################################################################################
restart_service() {
    local service="$1"
    log_info "Restarting service: ${service}"
    systemctl restart "${service}"
}

################################################################################
# Get service status
# Arguments:
#   $1 - Service name
################################################################################
get_service_status() {
    systemctl status "$1" --no-pager
}

################################################################################
# Wait for service to start
# Arguments:
#   $1 - Service name
#   $2 - Timeout in seconds (default: 30)
################################################################################
wait_for_service() {
    local service="$1"
    local timeout="${2:-30}"
    local elapsed=0
    
    log_debug "Waiting for service ${service} to start..."
    
    while [[ $elapsed -lt $timeout ]]; do
        if is_service_running "${service}"; then
            log_debug "Service ${service} is running"
            return 0
        fi
        sleep 1
        ((elapsed++))
    done
    
    log_error "Service ${service} failed to start within ${timeout} seconds"
    return 1
}

################################################################################
# Check if URL is accessible
# Arguments:
#   $1 - URL
#   $2 - Expected HTTP code (default: 200)
################################################################################
is_url_accessible() {
    local url="$1"
    local expected_code="${2:-200}"
    
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "${url}" 2>/dev/null)
    [[ "${http_code}" == "${expected_code}" ]]
}

################################################################################
# Download file
# Arguments:
#   $1 - URL
#   $2 - Output path
################################################################################
download_file() {
    local url="$1"
    local output="$2"
    
    log_debug "Downloading: ${url} -> ${output}"
    
    if command_exists curl; then
        curl -fsSL "${url}" -o "${output}"
    elif command_exists wget; then
        wget -q "${url}" -O "${output}"
    else
        log_error "Neither curl nor wget is available"
        return 1
    fi
}

################################################################################
# Create backup of file
# Arguments:
#   $1 - File path
################################################################################
backup_file() {
    local file="$1"
    
    if [[ -f "${file}" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        log_debug "Creating backup: ${file} -> ${backup}"
        cp "${file}" "${backup}"
    fi
}

################################################################################
# Restore file from backup
# Arguments:
#   $1 - File path
################################################################################
restore_file() {
    local file="$1"
    local backup=$(ls -t "${file}.backup."* 2>/dev/null | head -n1)
    
    if [[ -f "${backup}" ]]; then
        log_debug "Restoring backup: ${backup} -> ${file}"
        cp "${backup}" "${file}"
        return 0
    else
        log_warning "No backup found for: ${file}"
        return 1
    fi
}

################################################################################
# Ask yes/no question
# Arguments:
#   $1 - Question
#   $2 - Default answer (y/n)
################################################################################
ask_yes_no() {
    local question="$1"
    local default="${2:-y}"
    local prompt="[Y/n]"
    
    if [[ "${default}" == "n" ]]; then
        prompt="[y/N]"
    fi
    
    read -p "${question} ${prompt}: " -r answer
    answer="${answer:-${default}}"
    
    [[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]]
}

################################################################################
# Format bytes to human readable
# Arguments:
#   $1 - Bytes
################################################################################
format_bytes() {
    local bytes=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while [[ $bytes -ge 1024 && $unit -lt 4 ]]; do
        bytes=$((bytes / 1024))
        ((unit++))
    done
    
    echo "${bytes}${units[$unit]}"
}

################################################################################
# Get elapsed time in human readable format
# Arguments:
#   $1 - Start timestamp (seconds)
################################################################################
get_elapsed_time() {
    local start=$1
    local end=$(date +%s)
    local elapsed=$((end - start))
    
    local hours=$((elapsed / 3600))
    local minutes=$(((elapsed % 3600) / 60))
    local seconds=$((elapsed % 60))
    
    if [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif [[ $minutes -gt 0 ]]; then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}

################################################################################
# Validate email address
# Arguments:
#   $1 - Email address
################################################################################
is_valid_email() {
    local email="$1"
    [[ "${email}" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]
}

################################################################################
# Validate domain name
# Arguments:
#   $1 - Domain name
################################################################################
is_valid_domain() {
    local domain="$1"
    [[ "${domain}" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]
}

################################################################################
# Validate IP address
# Arguments:
#   $1 - IP address
################################################################################
is_valid_ip() {
    local ip="$1"
    [[ "${ip}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

################################################################################
# Get public IP address
################################################################################
get_public_ip() {
    curl -s https://api.ipify.org 2>/dev/null || \
    curl -s https://ifconfig.me 2>/dev/null || \
    curl -s https://icanhazip.com 2>/dev/null || \
    echo "unknown"
}

################################################################################
# Check internet connectivity
################################################################################
has_internet() {
    ping -c 1 -W 2 8.8.8.8 &>/dev/null || \
    ping -c 1 -W 2 1.1.1.1 &>/dev/null
}

################################################################################
# Trim whitespace
# Arguments:
#   $1 - String
################################################################################
trim() {
    local var="$1"
    # Remove leading whitespace
    var="${var#"${var%%[![:space:]]*}"}"
    # Remove trailing whitespace
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

################################################################################
# Convert to lowercase
# Arguments:
#   $1 - String
################################################################################
to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

################################################################################
# Convert to uppercase
# Arguments:
#   $1 - String
################################################################################
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Export all functions
export -f command_exists
export -f is_root
export -f get_os_type
export -f get_os_version
export -f is_os_supported
export -f get_package_manager
export -f install_package
export -f update_package_cache
export -f get_available_space
export -f get_total_ram
export -f get_cpu_cores
export -f is_port_in_use
export -f get_port_process
export -f generate_password
export -f generate_random_string
export -f service_exists
export -f is_service_running
export -f is_service_enabled
export -f start_service
export -f stop_service
export -f enable_service
export -f restart_service
export -f get_service_status
export -f wait_for_service
export -f is_url_accessible
export -f download_file
export -f backup_file
export -f restore_file
export -f ask_yes_no
export -f format_bytes
export -f get_elapsed_time
export -f is_valid_email
export -f is_valid_domain
export -f is_valid_ip
export -f get_public_ip
export -f has_internet
export -f trim
export -f to_lowercase
export -f to_uppercase
