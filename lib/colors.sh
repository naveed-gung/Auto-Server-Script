#!/bin/bash

################################################################################
# Colors and Formatting Library
# Provides color codes and text formatting for terminal output
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

# Reset
readonly NC='\033[0m'       # No Color / Reset

# Regular Colors
readonly BLACK='\033[0;30m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[0;37m'

# Bold Colors
readonly BOLD_BLACK='\033[1;30m'
readonly BOLD_RED='\033[1;31m'
readonly BOLD_GREEN='\033[1;32m'
readonly BOLD_YELLOW='\033[1;33m'
readonly BOLD_BLUE='\033[1;34m'
readonly BOLD_MAGENTA='\033[1;35m'
readonly BOLD_CYAN='\033[1;36m'
readonly BOLD_WHITE='\033[1;37m'

# Background Colors
readonly BG_BLACK='\033[40m'
readonly BG_RED='\033[41m'
readonly BG_GREEN='\033[42m'
readonly BG_YELLOW='\033[43m'
readonly BG_BLUE='\033[44m'
readonly BG_MAGENTA='\033[45m'
readonly BG_CYAN='\033[46m'
readonly BG_WHITE='\033[47m'

# Text Formatting
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly UNDERLINE='\033[4m'
readonly BLINK='\033[5m'
readonly REVERSE='\033[7m'
readonly HIDDEN='\033[8m'

# Status Icons (Unicode)
readonly ICON_SUCCESS="✓"
readonly ICON_ERROR="✗"
readonly ICON_WARNING="⚠"
readonly ICON_INFO="ℹ"
readonly ICON_ARROW="→"
readonly ICON_ROCKET="🚀"
readonly ICON_CHECK="✅"
readonly ICON_CROSS="❌"
readonly ICON_GEAR="⚙"
readonly ICON_LOCK="🔒"

################################################################################
# Print colored message
# Arguments:
#   $1 - Color code
#   $2 - Message
################################################################################
print_color() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

################################################################################
# Print success message
################################################################################
print_success() {
    echo -e "${GREEN}${ICON_SUCCESS} $1${NC}"
}

################################################################################
# Print error message
################################################################################
print_error() {
    echo -e "${RED}${ICON_ERROR} $1${NC}" >&2
}

################################################################################
# Print warning message
################################################################################
print_warning() {
    echo -e "${YELLOW}${ICON_WARNING} $1${NC}"
}

################################################################################
# Print info message
################################################################################
print_info() {
    echo -e "${CYAN}${ICON_INFO} $1${NC}"
}

################################################################################
# Print header
################################################################################
print_header() {
    local header="$1"
    local length=${#header}
    local line=$(printf '═%.0s' $(seq 1 $((length + 4))))
    
    echo ""
    echo -e "${BOLD_CYAN}╔${line}╗${NC}"
    echo -e "${BOLD_CYAN}║  ${header}  ║${NC}"
    echo -e "${BOLD_CYAN}╚${line}╝${NC}"
    echo ""
}

################################################################################
# Print progress bar
# Arguments:
#   $1 - Current value
#   $2 - Maximum value
#   $3 - Description (optional)
################################################################################
print_progress() {
    local current=$1
    local max=$2
    local description="${3:-Processing}"
    local percent=$((current * 100 / max))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    printf "\r${CYAN}${description}: ${NC}["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] ${BOLD}${percent}%%${NC}"
    
    if [[ $current -eq $max ]]; then
        echo ""
    fi
}

################################################################################
# Print spinner
# Arguments:
#   $1 - PID of process to monitor
#   $2 - Message
################################################################################
print_spinner() {
    local pid=$1
    local message="${2:-Processing}"
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local temp
    
    while kill -0 $pid 2>/dev/null; do
        temp="${spinstr#?}"
        printf "\r${CYAN}%c${NC} %s" "$spinstr" "$message"
        spinstr="$temp${spinstr%"$temp"}"
        sleep 0.1
    done
    
    wait $pid
    local exit_code=$?
    
    printf "\r"
    if [[ $exit_code -eq 0 ]]; then
        print_success "$message"
    else
        print_error "$message"
    fi
    
    return $exit_code
}

################################################################################
# Print box
# Arguments:
#   $@ - Lines to print in box
################################################################################
print_box() {
    local lines=("$@")
    local max_length=0
    
    # Find longest line
    for line in "${lines[@]}"; do
        local len=${#line}
        if [[ $len -gt $max_length ]]; then
            max_length=$len
        fi
    done
    
    # Print top border
    echo -e "${BOLD_CYAN}╔$(printf '═%.0s' $(seq 1 $((max_length + 2))))╗${NC}"
    
    # Print lines
    for line in "${lines[@]}"; do
        local padding=$((max_length - ${#line}))
        printf "${BOLD_CYAN}║${NC} %s%${padding}s ${BOLD_CYAN}║${NC}\n" "$line" ""
    done
    
    # Print bottom border
    echo -e "${BOLD_CYAN}╚$(printf '═%.0s' $(seq 1 $((max_length + 2))))╝${NC}"
}

################################################################################
# Print step
# Arguments:
#   $1 - Step number
#   $2 - Total steps
#   $3 - Step description
################################################################################
print_step() {
    local step=$1
    local total=$2
    local description="$3"
    
    echo ""
    echo -e "${BOLD_BLUE}[${step}/${total}]${NC} ${BOLD}${description}${NC}"
    echo -e "${DIM}$(printf '─%.0s' $(seq 1 60))${NC}"
}

################################################################################
# Print table row
# Arguments:
#   $1 - Column 1
#   $2 - Column 2
#   $3 - Optional color
################################################################################
print_table_row() {
    local col1="$1"
    local col2="$2"
    local color="${3:-$NC}"
    
    printf "${color}%-30s : %s${NC}\n" "$col1" "$col2"
}

################################################################################
# Clear line
################################################################################
clear_line() {
    printf "\r\033[K"
}

################################################################################
# Move cursor up
# Arguments:
#   $1 - Number of lines (default: 1)
################################################################################
move_cursor_up() {
    local lines="${1:-1}"
    printf "\033[${lines}A"
}

################################################################################
# Save cursor position
################################################################################
save_cursor() {
    printf "\033[s"
}

################################################################################
# Restore cursor position
################################################################################
restore_cursor() {
    printf "\033[u"
}

################################################################################
# Hide cursor
################################################################################
hide_cursor() {
    printf "\033[?25l"
}

################################################################################
# Show cursor
################################################################################
show_cursor() {
    printf "\033[?25h"
}

# Export all functions
export -f print_color
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
export -f print_header
export -f print_progress
export -f print_spinner
export -f print_box
export -f print_step
export -f print_table_row
export -f clear_line
export -f move_cursor_up
export -f save_cursor
export -f restore_cursor
export -f hide_cursor
export -f show_cursor
