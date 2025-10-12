#!/bin/bash

################################################################################
# Notifications Library
# Send notifications via multiple channels (Slack, Discord, Email)
################################################################################

################################################################################
# Send notification to all configured channels
# Arguments:
#   $1 - Title
#   $2 - Message
#   $3 - Level (info, success, warning, error) [optional]
################################################################################
send_notification() {
    local title="$1"
    local message="$2"
    local level="${3:-info}"
    
    log_debug "Sending notification: ${title}"
    
    # Send to Slack
    if [[ -n "${SLACK_WEBHOOK}" ]]; then
        send_slack_notification "${title}" "${message}" "${level}"
    fi
    
    # Send to Discord
    if [[ -n "${DISCORD_WEBHOOK}" ]]; then
        send_discord_notification "${title}" "${message}" "${level}"
    fi
    
    # Send email
    if [[ -n "${CONFIG[notification_email]}" ]]; then
        send_email_notification "${title}" "${message}" "${level}"
    fi
}

################################################################################
# Send Slack notification
# Arguments:
#   $1 - Title
#   $2 - Message
#   $3 - Level
################################################################################
send_slack_notification() {
    local title="$1"
    local message="$2"
    local level="${3:-info}"
    
    if [[ -z "${SLACK_WEBHOOK}" ]]; then
        return 0
    fi
    
    log_debug "Sending Slack notification..."
    
    # Determine color based on level
    local color="#36a64f"  # Green
    case "${level}" in
        success) color="#36a64f" ;;  # Green
        warning) color="#ff9900" ;;  # Orange
        error) color="#ff0000" ;;    # Red
        info) color="#0099ff" ;;     # Blue
    esac
    
    # Create JSON payload
    local payload=$(cat <<EOF
{
  "username": "Elite Setup Bot",
  "icon_emoji": ":rocket:",
  "attachments": [
    {
      "color": "${color}",
      "title": "${title}",
      "text": "${message}",
      "footer": "Elite Auto Server Setup",
      "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png",
      "ts": $(date +%s),
      "fields": [
        {
          "title": "Hostname",
          "value": "$(hostname)",
          "short": true
        },
        {
          "title": "IP Address",
          "value": "$(get_public_ip)",
          "short": true
        }
      ]
    }
  ]
}
EOF
)
    
    # Send webhook request
    curl -X POST "${SLACK_WEBHOOK}" \
        -H 'Content-Type: application/json' \
        -d "${payload}" \
        --silent --output /dev/null || {
        log_warning "Failed to send Slack notification"
        return 1
    }
    
    log_debug "Slack notification sent successfully"
    return 0
}

################################################################################
# Send Discord notification
# Arguments:
#   $1 - Title
#   $2 - Message
#   $3 - Level
################################################################################
send_discord_notification() {
    local title="$1"
    local message="$2"
    local level="${3:-info}"
    
    if [[ -z "${DISCORD_WEBHOOK}" ]]; then
        return 0
    fi
    
    log_debug "Sending Discord notification..."
    
    # Determine color based on level (decimal format for Discord)
    local color=3447003  # Blue
    case "${level}" in
        success) color=3066993 ;;   # Green
        warning) color=15844367 ;;  # Orange
        error) color=15158332 ;;    # Red
        info) color=3447003 ;;      # Blue
    esac
    
    # Create JSON payload
    local payload=$(cat <<EOF
{
  "username": "Elite Setup Bot",
  "avatar_url": "https://cdn.discordapp.com/embed/avatars/0.png",
  "embeds": [
    {
      "title": "${title}",
      "description": "${message}",
      "color": ${color},
      "footer": {
        "text": "Elite Auto Server Setup"
      },
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
      "fields": [
        {
          "name": "Hostname",
          "value": "$(hostname)",
          "inline": true
        },
        {
          "name": "IP Address",
          "value": "$(get_public_ip)",
          "inline": true
        }
      ]
    }
  ]
}
EOF
)
    
    # Send webhook request
    curl -X POST "${DISCORD_WEBHOOK}" \
        -H 'Content-Type: application/json' \
        -d "${payload}" \
        --silent --output /dev/null || {
        log_warning "Failed to send Discord notification"
        return 1
    }
    
    log_debug "Discord notification sent successfully"
    return 0
}

################################################################################
# Send email notification
# Arguments:
#   $1 - Title
#   $2 - Message
#   $3 - Level
################################################################################
send_email_notification() {
    local title="$1"
    local message="$2"
    local level="${3:-info}"
    local to_email="${CONFIG[notification_email]}"
    
    if [[ -z "${to_email}" ]]; then
        return 0
    fi
    
    log_debug "Sending email notification to: ${to_email}"
    
    # Check if mail command is available
    if ! command_exists mail && ! command_exists sendmail; then
        log_warning "No mail command available, skipping email notification"
        return 1
    fi
    
    # Create email content
    local email_body=$(cat <<EOF
Elite Auto Server Setup - Notification
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

${title}

${message}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Server Details:
  Hostname: $(hostname)
  IP Address: $(get_public_ip)
  Time: $(date)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This is an automated message from Elite Setup.
EOF
)
    
    # Send email
    if command_exists mail; then
        echo "${email_body}" | mail -s "[Elite Setup] ${title}" "${to_email}" || {
            log_warning "Failed to send email notification"
            return 1
        }
    elif command_exists sendmail; then
        {
            echo "Subject: [Elite Setup] ${title}"
            echo "To: ${to_email}"
            echo "From: noreply@$(hostname)"
            echo ""
            echo "${email_body}"
        } | sendmail -t || {
            log_warning "Failed to send email notification"
            return 1
        }
    fi
    
    log_debug "Email notification sent successfully"
    return 0
}

################################################################################
# Send installation start notification
################################################################################
notify_installation_start() {
    local hostname=$(hostname)
    local os_info=$(get_os_info)
    
    send_notification \
        "🚀 Installation Started" \
        "Elite Setup installation has started on ${hostname} running ${os_info}" \
        "info"
}

################################################################################
# Send installation complete notification
# Arguments:
#   $1 - Duration in seconds
################################################################################
notify_installation_complete() {
    local duration=$1
    local hostname=$(hostname)
    local elapsed=$(get_elapsed_time 0 ${duration})
    
    local message="Installation completed successfully in ${elapsed}"
    
    # Add component information
    message+="\n\nInstalled Components:\n"
    for component in "${!INSTALLED_COMPONENTS[@]}"; do
        local status="${INSTALLED_COMPONENTS[$component]}"
        if [[ "${status}" == "success" ]]; then
            message+="✓ ${component}\n"
        fi
    done
    
    message+="\nServer: ${hostname}"
    
    if [[ -n "${DOMAIN}" ]]; then
        message+="\nDomain: ${DOMAIN}"
    fi
    
    send_notification \
        "✅ Installation Complete" \
        "${message}" \
        "success"
}

################################################################################
# Send installation failure notification
# Arguments:
#   $1 - Error message
################################################################################
notify_installation_failure() {
    local error_message="$1"
    local hostname=$(hostname)
    
    local message="Installation failed on ${hostname}"
    
    if [[ -n "${error_message}" ]]; then
        message+="\n\nError: ${error_message}"
    fi
    
    message+="\n\nCheck logs at: ${LOG_DIR}/error.log"
    
    send_notification \
        "❌ Installation Failed" \
        "${message}" \
        "error"
}

################################################################################
# Send component installation notification
# Arguments:
#   $1 - Component name
#   $2 - Status (started, success, failed)
################################################################################
notify_component_installation() {
    local component="$1"
    local status="$2"
    local hostname=$(hostname)
    
    local icon=""
    local level="info"
    local action=""
    
    case "${status}" in
        started)
            icon="⏳"
            action="installation started"
            level="info"
            ;;
        success)
            icon="✅"
            action="installed successfully"
            level="success"
            ;;
        failed)
            icon="❌"
            action="installation failed"
            level="error"
            ;;
    esac
    
    send_notification \
        "${icon} ${component}" \
        "${component} ${action} on ${hostname}" \
        "${level}"
}

################################################################################
# Send security alert
# Arguments:
#   $1 - Alert title
#   $2 - Alert message
################################################################################
send_security_alert() {
    local title="$1"
    local message="$2"
    local hostname=$(hostname)
    
    send_notification \
        "🔒 Security Alert: ${title}" \
        "${message}\n\nServer: ${hostname}" \
        "warning"
}

################################################################################
# Test notification channels
################################################################################
test_notifications() {
    print_header "Testing Notification Channels"
    
    local test_title="Test Notification"
    local test_message="This is a test notification from Elite Setup on $(hostname)"
    
    echo ""
    
    # Test Slack
    if [[ -n "${SLACK_WEBHOOK}" ]]; then
        echo -n "Testing Slack... "
        if send_slack_notification "${test_title}" "${test_message}" "info"; then
            print_success "Sent"
        else
            print_error "Failed"
        fi
    else
        echo "Slack: Not configured"
    fi
    
    # Test Discord
    if [[ -n "${DISCORD_WEBHOOK}" ]]; then
        echo -n "Testing Discord... "
        if send_discord_notification "${test_title}" "${test_message}" "info"; then
            print_success "Sent"
        else
            print_error "Failed"
        fi
    else
        echo "Discord: Not configured"
    fi
    
    # Test Email
    if [[ -n "${CONFIG[notification_email]}" ]]; then
        echo -n "Testing Email... "
        if send_email_notification "${test_title}" "${test_message}" "info"; then
            print_success "Sent"
        else
            print_error "Failed"
        fi
    else
        echo "Email: Not configured"
    fi
    
    echo ""
}

################################################################################
# Configure notification channels (interactive)
################################################################################
configure_notifications() {
    if [[ "${SILENT}" == true ]]; then
        return 0
    fi
    
    print_header "Configure Notifications"
    
    echo ""
    echo "Configure notification channels to receive installation updates."
    echo ""
    
    # Slack
    if ask_yes_no "Configure Slack webhook?" "n"; then
        read -p "Enter Slack webhook URL: " SLACK_WEBHOOK
    fi
    
    # Discord
    if ask_yes_no "Configure Discord webhook?" "n"; then
        read -p "Enter Discord webhook URL: " DISCORD_WEBHOOK
    fi
    
    # Email
    if ask_yes_no "Configure email notifications?" "n"; then
        read -p "Enter email address: " email_address
        if is_valid_email "${email_address}"; then
            CONFIG[notification_email]="${email_address}"
        else
            print_error "Invalid email address"
        fi
    fi
    
    # Test notifications
    if ask_yes_no "Test notification channels?" "y"; then
        test_notifications
    fi
    
    echo ""
}

# Export functions
export -f send_notification
export -f send_slack_notification
export -f send_discord_notification
export -f send_email_notification
export -f notify_installation_start
export -f notify_installation_complete
export -f notify_installation_failure
export -f notify_component_installation
export -f send_security_alert
export -f test_notifications
export -f configure_notifications
