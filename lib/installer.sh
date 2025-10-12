#!/bin/bash

################################################################################
# Installer Library
# Component installation functions
################################################################################

# Installation state tracking
declare -A INSTALLED_COMPONENTS

################################################################################
# Install component with progress tracking
# Arguments:
#   $1 - Component name
#   $2 - Installation function
################################################################################
install_component() {
    local component="$1"
    local install_func="$2"
    local start_time=$(date +%s)
    
    print_step "${INSTALL_STEP:-1}" "${TOTAL_STEPS:-10}" "Installing ${component}"
    
    log_install_start "${component}"
    
    if [[ "${DRY_RUN}" == true ]]; then
        log_info "[DRY RUN] Would install ${component}"
        print_success "${component} (dry run)"
        INSTALLED_COMPONENTS["${component}"]="dry-run"
        return 0
    fi
    
    # Run installation function
    if ${install_func}; then
        local duration=$(($(date +%s) - start_time))
        log_install_success "${component}" "${duration}"
        print_success "${component} installed (${duration}s)"
        INSTALLED_COMPONENTS["${component}"]="success"
        return 0
    else
        log_install_failure "${component}" "Installation function failed"
        print_error "${component} installation failed"
        INSTALLED_COMPONENTS["${component}"]="failed"
        return 1
    fi
}

################################################################################
# Update system packages
################################################################################
update_system_packages() {
    log_info "Updating system packages..."
    
    local pkg_manager=$(get_package_manager)
    
    case "${pkg_manager}" in
        apt)
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -qq
            apt-get upgrade -y -qq
            apt-get install -y software-properties-common apt-transport-https ca-certificates curl wget gnupg lsb-release
            ;;
        yum|dnf)
            ${pkg_manager} update -y -q
            ${pkg_manager} install -y -q curl wget ca-certificates
            ;;
        *)
            log_error "Unknown package manager"
            return 1
            ;;
    esac
    
    return 0
}

################################################################################
# Install Node.js
################################################################################
install_nodejs() {
    if ! should_install "nodejs"; then
        return 0
    fi
    
    local version="${CONFIG[nodejs_version]:-20}"
    log_info "Installing Node.js ${version}..."
    
    # Check if Node.js is already installed
    if command_exists node; then
        local current_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ "${current_version}" == "${version}" ]]; then
            log_info "Node.js ${version} is already installed"
            return 0
        else
            log_info "Upgrading Node.js from ${current_version} to ${version}"
        fi
    fi
    
    local pkg_manager=$(get_package_manager)
    
    case "${pkg_manager}" in
        apt)
            # Add NodeSource repository
            curl -fsSL "https://deb.nodesource.com/setup_${version}.x" | bash -
            apt-get install -y nodejs
            ;;
        yum|dnf)
            # Add NodeSource repository
            curl -fsSL "https://rpm.nodesource.com/setup_${version}.x" | bash -
            ${pkg_manager} install -y nodejs
            ;;
        *)
            log_error "Unsupported package manager for Node.js installation"
            return 1
            ;;
    esac
    
    # Verify installation
    if ! command_exists node; then
        log_error "Node.js installation failed"
        return 1
    fi
    
    local installed_version=$(node --version)
    log_info "Node.js installed: ${installed_version}"
    log_info "npm installed: $(npm --version)"
    
    # Install global npm packages
    npm install -g npm@latest
    
    return 0
}

################################################################################
# Install MongoDB
################################################################################
install_mongodb() {
    if ! should_install "mongodb"; then
        return 0
    fi
    
    local version="${CONFIG[mongodb_version]:-7.0}"
    log_info "Installing MongoDB ${version}..."
    
    # Check if MongoDB is already installed
    if command_exists mongod; then
        log_info "MongoDB is already installed"
        # TODO: Check version and upgrade if needed
    fi
    
    local pkg_manager=$(get_package_manager)
    local os_type=$(get_os_type)
    local os_version=$(get_os_version)
    
    case "${pkg_manager}" in
        apt)
            # Import MongoDB GPG key
            curl -fsSL "https://www.mongodb.org/static/pgp/server-${version}.asc" | \
                gpg --dearmor -o /usr/share/keyrings/mongodb-server-${version}.gpg
            
            # Add MongoDB repository
            if [[ "${os_type}" == "ubuntu" ]]; then
                local codename=$(lsb_release -cs)
                echo "deb [signed-by=/usr/share/keyrings/mongodb-server-${version}.gpg] https://repo.mongodb.org/apt/ubuntu ${codename}/mongodb-org/${version} multiverse" | \
                    tee /etc/apt/sources.list.d/mongodb-org-${version}.list
            elif [[ "${os_type}" == "debian" ]]; then
                local codename=$(lsb_release -cs)
                echo "deb [signed-by=/usr/share/keyrings/mongodb-server-${version}.gpg] https://repo.mongodb.org/apt/debian ${codename}/mongodb-org/${version} main" | \
                    tee /etc/apt/sources.list.d/mongodb-org-${version}.list
            fi
            
            # Update and install
            apt-get update -qq
            apt-get install -y mongodb-org
            ;;
        yum|dnf)
            # Add MongoDB repository
            cat > /etc/yum.repos.d/mongodb-org-${version}.repo << EOF
[mongodb-org-${version}]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/${version}/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-${version}.asc
EOF
            
            # Install
            ${pkg_manager} install -y mongodb-org
            ;;
        *)
            log_error "Unsupported package manager for MongoDB installation"
            return 1
            ;;
    esac
    
    # Configure MongoDB
    configure_mongodb
    
    # Start and enable MongoDB
    systemctl daemon-reload
    systemctl enable mongod
    systemctl start mongod
    
    # Wait for MongoDB to start
    wait_for_service "mongod" 30
    
    # Verify installation
    if ! systemctl is-active --quiet mongod; then
        log_error "MongoDB failed to start"
        return 1
    fi
    
    log_info "MongoDB installed and running"
    return 0
}

################################################################################
# Configure MongoDB
################################################################################
configure_mongodb() {
    log_info "Configuring MongoDB..."
    
    local config_file="/etc/mongod.conf"
    backup_file "${config_file}"
    
    # Enable authentication if required
    if [[ "${CONFIG[mongodb_auth]}" == "true" ]]; then
        log_info "Enabling MongoDB authentication..."
        
        # Create admin user
        local admin_user="${CONFIG[mongodb_user]:-admin}"
        local admin_password=$(generate_password 32)
        
        # Store credentials securely
        mkdir -p "${CONFIG_DIR}"
        chmod 700 "${CONFIG_DIR}"
        
        cat > "${CONFIG_DIR}/mongodb-credentials.txt" << EOF
MongoDB Credentials
==================
Username: ${admin_user}
Password: ${admin_password}
Connection String: mongodb://${admin_user}:${admin_password}@localhost:27017/admin
EOF
        chmod 600 "${CONFIG_DIR}/mongodb-credentials.txt"
        
        # Create admin user (wait for MongoDB to be ready)
        sleep 2
        mongosh admin --eval "db.createUser({user:'${admin_user}',pwd:'${admin_password}',roles:['root']})" || true
        
        # Enable authentication in config
        sed -i 's/#security:/security:\n  authorization: enabled/' "${config_file}"
        
        # Restart MongoDB
        systemctl restart mongod
        wait_for_service "mongod" 30
        
        log_info "MongoDB authentication enabled"
        log_info "Credentials saved to: ${CONFIG_DIR}/mongodb-credentials.txt"
    fi
    
    return 0
}

################################################################################
# Install Nginx
################################################################################
install_nginx() {
    if ! should_install "nginx"; then
        return 0
    fi
    
    log_info "Installing Nginx..."
    
    # Check if Nginx is already installed
    if command_exists nginx; then
        log_info "Nginx is already installed"
        local version=$(nginx -v 2>&1 | cut -d'/' -f2)
        log_info "Current version: ${version}"
    fi
    
    local pkg_manager=$(get_package_manager)
    
    # Install Nginx
    case "${pkg_manager}" in
        apt)
            apt-get install -y nginx
            ;;
        yum|dnf)
            ${pkg_manager} install -y nginx
            ;;
        *)
            log_error "Unsupported package manager for Nginx installation"
            return 1
            ;;
    esac
    
    # Configure Nginx
    configure_nginx
    
    # Start and enable Nginx
    systemctl enable nginx
    systemctl start nginx
    
    # Verify installation
    if ! systemctl is-active --quiet nginx; then
        log_error "Nginx failed to start"
        return 1
    fi
    
    log_info "Nginx installed and running"
    return 0
}

################################################################################
# Configure Nginx
################################################################################
configure_nginx() {
    log_info "Configuring Nginx..."
    
    local config_file="/etc/nginx/nginx.conf"
    backup_file "${config_file}"
    
    # Create default server block
    if [[ -n "${DOMAIN}" ]]; then
        create_nginx_server_block
    fi
    
    # Install SSL certificate if enabled
    if [[ "${CONFIG[nginx_ssl]}" == "true" ]]; then
        install_ssl_certificate
    fi
    
    # Test Nginx configuration
    if ! nginx -t; then
        log_error "Nginx configuration test failed"
        restore_file "${config_file}"
        return 1
    fi
    
    # Reload Nginx
    systemctl reload nginx
    
    return 0
}

################################################################################
# Create Nginx server block
################################################################################
create_nginx_server_block() {
    local server_block="/etc/nginx/sites-available/${DOMAIN}"
    
    log_info "Creating Nginx server block for ${DOMAIN}..."
    
    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
    
    cat > "${server_block}" << 'EOF'
server {
    listen 80;
    server_name DOMAIN_PLACEHOLDER;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF
    
    sed -i "s/DOMAIN_PLACEHOLDER/${DOMAIN}/g" "${server_block}"
    
    # Enable site
    ln -sf "${server_block}" "/etc/nginx/sites-enabled/${DOMAIN}"
    
    return 0
}

################################################################################
# Install SSL certificate
################################################################################
install_ssl_certificate() {
    local provider="${CONFIG[nginx_ssl_provider]:-letsencrypt}"
    
    log_info "Installing SSL certificate (${provider})..."
    
    case "${provider}" in
        letsencrypt)
            install_letsencrypt_ssl
            ;;
        selfsigned)
            install_selfsigned_ssl
            ;;
        *)
            log_error "Unknown SSL provider: ${provider}"
            return 1
            ;;
    esac
}

################################################################################
# Install Let's Encrypt SSL
################################################################################
install_letsencrypt_ssl() {
    if [[ -z "${DOMAIN}" || -z "${SSL_EMAIL}" ]]; then
        log_error "Domain and email required for Let's Encrypt"
        return 1
    fi
    
    log_info "Installing Certbot..."
    
    local pkg_manager=$(get_package_manager)
    
    case "${pkg_manager}" in
        apt)
            apt-get install -y certbot python3-certbot-nginx
            ;;
        yum|dnf)
            ${pkg_manager} install -y certbot python3-certbot-nginx
            ;;
    esac
    
    log_info "Obtaining SSL certificate from Let's Encrypt..."
    
    # Obtain certificate
    certbot --nginx -d "${DOMAIN}" --non-interactive --agree-tos --email "${SSL_EMAIL}" --redirect
    
    # Setup auto-renewal
    systemctl enable certbot.timer || {
        # Create cron job if timer not available
        echo "0 0,12 * * * root python3 -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" > /etc/cron.d/certbot
    }
    
    log_info "SSL certificate installed successfully"
    return 0
}

################################################################################
# Install self-signed SSL
################################################################################
install_selfsigned_ssl() {
    log_info "Generating self-signed SSL certificate..."
    
    mkdir -p /etc/nginx/ssl
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "/etc/nginx/ssl/${DOMAIN}.key" \
        -out "/etc/nginx/ssl/${DOMAIN}.crt" \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=${DOMAIN}"
    
    log_info "Self-signed certificate generated"
    return 0
}

################################################################################
# Install PM2
################################################################################
install_pm2() {
    if ! should_install "pm2"; then
        return 0
    fi
    
    log_info "Installing PM2..."
    
    # Check if PM2 is already installed
    if command_exists pm2; then
        log_info "PM2 is already installed"
        local version=$(pm2 --version)
        log_info "Current version: ${version}"
    fi
    
    # Install PM2 globally
    npm install -g pm2@latest
    
    # Setup PM2 startup script
    pm2 startup systemd -u root --hp /root
    
    # Enable PM2 to save process list
    pm2 save
    
    log_info "PM2 installed successfully"
    return 0
}

################################################################################
# Install Docker
################################################################################
install_docker() {
    if ! should_install "docker"; then
        return 0
    fi
    
    log_info "Installing Docker..."
    
    # Check if Docker is already installed
    if command_exists docker; then
        log_info "Docker is already installed"
        local version=$(docker --version | cut -d' ' -f3 | tr -d ',')
        log_info "Current version: ${version}"
        return 0
    fi
    
    local pkg_manager=$(get_package_manager)
    local os_type=$(get_os_type)
    
    case "${pkg_manager}" in
        apt)
            # Add Docker's official GPG key
            install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/${os_type}/gpg | \
                gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            chmod a+r /etc/apt/keyrings/docker.gpg
            
            # Add Docker repository
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${os_type} \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            apt-get update -qq
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        yum|dnf)
            # Add Docker repository
            ${pkg_manager} install -y yum-utils
            ${pkg_manager}-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            
            # Install Docker
            ${pkg_manager} install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        *)
            log_error "Unsupported package manager for Docker installation"
            return 1
            ;;
    esac
    
    # Start and enable Docker
    systemctl enable docker
    systemctl start docker
    
    # Verify installation
    if ! systemctl is-active --quiet docker; then
        log_error "Docker failed to start"
        return 1
    fi
    
    log_info "Docker installed successfully"
    docker --version
    docker compose version
    
    return 0
}

################################################################################
# Check if component should be installed
# Arguments:
#   $1 - Component name
################################################################################
should_install() {
    local component="$1"
    local enabled=$(get_config "${component}_enabled" "true")
    
    if [[ "${enabled}" != "true" ]]; then
        log_info "Skipping ${component} (disabled in configuration)"
        return 1
    fi
    
    return 0
}

# Export functions
export -f install_component
export -f update_system_packages
export -f install_nodejs
export -f install_mongodb
export -f configure_mongodb
export -f install_nginx
export -f configure_nginx
export -f create_nginx_server_block
export -f install_ssl_certificate
export -f install_letsencrypt_ssl
export -f install_selfsigned_ssl
export -f install_pm2
export -f install_docker
export -f should_install
