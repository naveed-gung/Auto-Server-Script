#!/bin/bash

################################################################################
# Logger Library
# Provides structured logging with multiple severity levels
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

# Log levels
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3
readonly LOG_LEVEL_CRITICAL=4

# Default log level
LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Log file paths (LOG_DIR must be defined before sourcing this library)
LOG_FILE="${LOG_DIR}/install.log"
ERROR_LOG_FILE="${LOG_DIR}/error.log"
DEBUG_LOG_FILE="${LOG_DIR}/debug.log"

################################################################################
# Initialize logging system
################################################################################
init_logging() {
    # Create log directory
    mkdir -p "${LOG_DIR}"
    chmod 755 "${LOG_DIR}"
    
    # Create log files
    touch "${LOG_FILE}" "${ERROR_LOG_FILE}" "${DEBUG_LOG_FILE}"
    chmod 644 "${LOG_FILE}" "${ERROR_LOG_FILE}" "${DEBUG_LOG_FILE}"
    
    # Log session start
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "==============================================================" >> "${LOG_FILE}"
    echo "  Elite Setup Session Started: ${timestamp}" >> "${LOG_FILE}"
    echo "  Hostname: $(hostname)" >> "${LOG_FILE}"
    echo "  User: $(whoami)" >> "${LOG_FILE}"
    echo "  OS: $(get_os_info)" >> "${LOG_FILE}"
    echo "==============================================================" >> "${LOG_FILE}"
    echo "" >> "${LOG_FILE}"
}

################################################################################
# Get OS information
################################################################################
get_os_info() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${PRETTY_NAME:-Unknown}"
    else
        echo "Unknown"
    fi
}

################################################################################
# Log message with level
# Arguments:
#   $1 - Log level
#   $2 - Message
#   $3 - Additional context (optional)
################################################################################
log_message() {
    local level=$1
    local message="$2"
    local context="${3:-}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local level_name=""
    local color=""
    
    # Determine level name and color
    case $level in
        $LOG_LEVEL_DEBUG)
            level_name="DEBUG"
            color="${DIM}"
            ;;
        $LOG_LEVEL_INFO)
            level_name="INFO"
            color="${CYAN}"
            ;;
        $LOG_LEVEL_WARN)
            level_name="WARN"
            color="${YELLOW}"
            ;;
        $LOG_LEVEL_ERROR)
            level_name="ERROR"
            color="${RED}"
            ;;
        $LOG_LEVEL_CRITICAL)
            level_name="CRITICAL"
            color="${BOLD_RED}"
            ;;
    esac
    
    # Format log entry
    local log_entry="[${timestamp}] [${level_name}] ${message}"
    if [[ -n "${context}" ]]; then
        log_entry="${log_entry} | Context: ${context}"
    fi
    
    # Write to appropriate log files
    echo "${log_entry}" >> "${LOG_FILE}"
    
    if [[ $level -ge $LOG_LEVEL_ERROR ]]; then
        echo "${log_entry}" >> "${ERROR_LOG_FILE}"
    fi
    
    if [[ $level -eq $LOG_LEVEL_DEBUG ]]; then
        echo "${log_entry}" >> "${DEBUG_LOG_FILE}"
    fi
    
    # Print to console if not silent
    if [[ "${SILENT:-false}" == false ]] && [[ $level -ge $LOG_LEVEL ]]; then
        case $level in
            $LOG_LEVEL_DEBUG)
                echo -e "${color}[DEBUG] ${message}${NC}"
                ;;
            $LOG_LEVEL_INFO)
                echo -e "${color}${ICON_INFO} ${message}${NC}"
                ;;
            $LOG_LEVEL_WARN)
                echo -e "${color}${ICON_WARNING} ${message}${NC}"
                ;;
            $LOG_LEVEL_ERROR)
                echo -e "${color}${ICON_ERROR} ${message}${NC}" >&2
                ;;
            $LOG_LEVEL_CRITICAL)
                echo -e "${color}${ICON_CROSS} CRITICAL: ${message}${NC}" >&2
                ;;
        esac
    fi
}

################################################################################
# Log debug message
################################################################################
log_debug() {
    log_message $LOG_LEVEL_DEBUG "$1" "${2:-}"
}

################################################################################
# Log info message
################################################################################
log_info() {
    log_message $LOG_LEVEL_INFO "$1" "${2:-}"
}

################################################################################
# Log warning message
################################################################################
log_warning() {
    log_message $LOG_LEVEL_WARN "$1" "${2:-}"
}

################################################################################
# Log error message
################################################################################
log_error() {
    log_message $LOG_LEVEL_ERROR "$1" "${2:-}"
}

################################################################################
# Log critical message
################################################################################
log_critical() {
    log_message $LOG_LEVEL_CRITICAL "$1" "${2:-}"
}

################################################################################
# Log command execution
# Arguments:
#   $@ - Command to execute and log
################################################################################
log_exec() {
    local cmd="$*"
    log_debug "Executing: ${cmd}"
    
    local output
    local exit_code
    
    if [[ "${DRY_RUN:-false}" == true ]]; then
        log_info "[DRY RUN] Would execute: ${cmd}"
        return 0
    fi
    
    # Execute command and capture output
    output=$($cmd 2>&1)
    exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        log_debug "Command succeeded: ${cmd}"
        if [[ -n "${output}" ]]; then
            log_debug "Output: ${output}"
        fi
    else
        log_error "Command failed (exit code ${exit_code}): ${cmd}"
        if [[ -n "${output}" ]]; then
            log_error "Error output: ${output}"
        fi
    fi
    
    return $exit_code
}

################################################################################
# Log component installation start
################################################################################
log_install_start() {
    local component="$1"
    log_info "Installing ${component}..."
    echo "" >> "${LOG_FILE}"
    echo "--- Installing ${component} ---" >> "${LOG_FILE}"
}

################################################################################
# Log component installation success
################################################################################
log_install_success() {
    local component="$1"
    local duration="${2:-}"
    
    local msg="Successfully installed ${component}"
    if [[ -n "${duration}" ]]; then
        msg="${msg} (${duration}s)"
    fi
    
    log_info "${msg}"
    echo "--- ${component} installation completed ---" >> "${LOG_FILE}"
    echo "" >> "${LOG_FILE}"
}

################################################################################
# Log component installation failure
################################################################################
log_install_failure() {
    local component="$1"
    local error="${2:-Unknown error}"
    
    log_error "Failed to install ${component}: ${error}"
    echo "--- ${component} installation failed ---" >> "${LOG_FILE}"
    echo "" >> "${LOG_FILE}"
}

################################################################################
# Log system metrics
################################################################################
log_system_metrics() {
    log_debug "=== System Metrics ==="
    log_debug "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    log_debug "Memory Usage: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
    log_debug "Disk Usage: $(df -h / | awk 'NR==2{printf "%s", $5}')"
    log_debug "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
}

################################################################################
# Create log archive
################################################################################
archive_logs() {
    local archive_name="elite-setup-logs-$(date +%Y%m%d-%H%M%S).tar.gz"
    local archive_path="${LOG_DIR}/${archive_name}"
    
    log_info "Creating log archive: ${archive_name}"
    
    tar -czf "${archive_path}" -C "${LOG_DIR}" \
        install.log error.log debug.log 2>/dev/null || true
    
    if [[ -f "${archive_path}" ]]; then
        log_info "Log archive created: ${archive_path}"
        return 0
    else
        log_warning "Failed to create log archive"
        return 1
    fi
}

################################################################################
# Rotate logs
################################################################################
rotate_logs() {
    local max_logs=10
    
    for log_file in "${LOG_FILE}" "${ERROR_LOG_FILE}" "${DEBUG_LOG_FILE}"; do
        if [[ -f "${log_file}" ]]; then
            local file_size=$(stat -f%z "${log_file}" 2>/dev/null || stat -c%s "${log_file}" 2>/dev/null || echo "0")
            
            # Rotate if larger than 10MB
            if [[ $file_size -gt 10485760 ]]; then
                log_debug "Rotating log file: ${log_file}"
                
                # Remove oldest log
                rm -f "${log_file}.${max_logs}" 2>/dev/null || true
                
                # Rotate logs
                for i in $(seq $((max_logs - 1)) -1 1); do
                    if [[ -f "${log_file}.$i" ]]; then
                        mv "${log_file}.$i" "${log_file}.$((i + 1))"
                    fi
                done
                
                # Move current log
                mv "${log_file}" "${log_file}.1"
                touch "${log_file}"
                chmod 644 "${log_file}"
            fi
        fi
    done
}

################################################################################
# Tail logs in real-time
################################################################################
tail_logs() {
    local num_lines="${1:-50}"
    tail -n "${num_lines}" -f "${LOG_FILE}"
}

################################################################################
# Search logs
# Arguments:
#   $1 - Search pattern
#   $2 - Log file (default: install.log)
################################################################################
search_logs() {
    local pattern="$1"
    local log_file="${2:-${LOG_FILE}}"
    
    if [[ ! -f "${log_file}" ]]; then
        log_error "Log file not found: ${log_file}"
        return 1
    fi
    
    grep -i "${pattern}" "${log_file}" || true
}

################################################################################
# Export logs to JSON
################################################################################
export_logs_json() {
    local output_file="${1:-${LOG_DIR}/logs.json}"
    
    log_info "Exporting logs to JSON: ${output_file}"
    
    cat > "${output_file}" << 'EOF'
{
  "session": {
    "started": "TIMESTAMP",
    "hostname": "HOSTNAME",
    "user": "USER"
  },
  "logs": []
}
EOF
    
    # TODO: Parse logs and convert to JSON format
    log_info "JSON export complete: ${output_file}"
}

# Export functions
export -f init_logging
export -f log_debug
export -f log_info
export -f log_warning
export -f log_error
export -f log_critical
export -f log_exec
export -f log_install_start
export -f log_install_success
export -f log_install_failure
export -f log_system_metrics
export -f archive_logs
export -f rotate_logs
export -f tail_logs
export -f search_logs
export -f export_logs_json
