#!/bin/bash
################################################################################
# Security Audit - Check for Sensitive Information
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     SECURITY AUDIT - SENSITIVE DATA CHECK                ║"
echo "║     Scanning for credentials before GitHub push          ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

ISSUES_FOUND=0

# Check 1: Hardcoded passwords
echo -e "${CYAN}[1/10] Checking for hardcoded passwords${NC}"
passwords=$(grep -rn 'password.*=.*["\x27][a-zA-Z0-9]' lib/*.sh setup.sh config/*.json 2>/dev/null | \
            grep -v 'admin_password=\$\|generate_password\|read\|PLACEHOLDER\|example\|your_password\|MONGO_PASSWORD\|admin_password_env\|grep.*password\|api_key\|secret' | wc -l)
if [ "$passwords" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No hardcoded passwords found"
else
    echo -e "  ${RED}✗${NC} Found $passwords potential hardcoded passwords"
    grep -rn 'password.*=.*["\x27][a-zA-Z0-9]' lib/*.sh setup.sh config/*.json 2>/dev/null | \
    grep -v 'admin_password=\$\|generate_password\|read\|PLACEHOLDER\|example\|your_password\|MONGO_PASSWORD\|admin_password_env\|grep.*password'
    ((ISSUES_FOUND++))
fi

# Check 2: API keys and tokens
echo -e "${CYAN}[2/10] Checking for API keys/tokens${NC}"
api_keys=$(grep -rni '["\x27][A-Za-z0-9]{32,}["\x27]' lib/*.sh setup.sh config/*.json 2>/dev/null | \
           grep -i 'api\|token\|key' | grep -v 'example\|TODO\|PLACEHOLDER\|grep' | wc -l)
if [ "$api_keys" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No API keys/tokens found"
else
    echo -e "  ${RED}✗${NC} Found $api_keys potential API keys"
    ((ISSUES_FOUND++))
fi

# Check 3: Private keys
echo -e "${CYAN}[3/10] Checking for private keys${NC}"
priv_keys=$(find . -name "*.pem" -o -name "*.key" -o -name "id_rsa" -o -name "*.p12" 2>/dev/null | wc -l)
if [ "$priv_keys" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No private key files found"
else
    echo -e "  ${RED}✗${NC} Found $priv_keys private key files"
    ((ISSUES_FOUND++))
fi

# Check 4: Real email addresses (not examples)
echo -e "${CYAN}[4/10] Checking for real email addresses${NC}"
real_emails=$(grep -roh '[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}' . --include="*.sh" --include="*.json" 2>/dev/null | \
              grep -v 'example.com\|test.com\|localhost\|PLACEHOLDER\|admin@example\|user@example\|noreply@' | sort | uniq)
if [ -z "$real_emails" ]; then
    echo -e "  ${GREEN}✓${NC} No real email addresses found (only examples)"
else
    echo -e "  ${YELLOW}⚠${NC} Found potential real emails:"
    echo "$real_emails" | while read email; do
        echo -e "    ${YELLOW}•${NC} $email"
    done
    ((ISSUES_FOUND++))
fi

# Check 5: Real IP addresses (not local/example)
echo -e "${CYAN}[5/10] Checking for real IP addresses${NC}"
real_ips=$(grep -roP '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b' . --include="*.sh" --include="*.json" 2>/dev/null | \
           grep -v '127.0.0.1\|192.168.\|10.0.\|172.16.\|0.0.0.0\|255.255.' | sort | uniq)
if [ -z "$real_ips" ]; then
    echo -e "  ${GREEN}✓${NC} No external IP addresses found"
else
    echo -e "  ${YELLOW}⚠${NC} Found potential external IPs"
fi

# Check 6: Real webhook URLs
echo -e "${CYAN}[6/10] Checking for real webhook URLs${NC}"
webhooks=$(grep -roh 'https://hooks.slack.com/services/[a-zA-Z0-9/]\+\|https://discord.com/api/webhooks/[0-9]\+/[a-zA-Z0-9_-]\+' lib/*.sh setup.sh config/*.json 2>/dev/null)
if [ -z "$webhooks" ]; then
    echo -e "  ${GREEN}✓${NC} No real webhook URLs found"
else
    echo -e "  ${RED}✗${NC} Found real webhook URLs - Remove these before pushing!"
    echo "$webhooks" | while read webhook; do
        echo -e "    ${RED}•${NC} $webhook"
    done
    ((ISSUES_FOUND++))
fi

# Check 7: Database connection strings
echo -e "${CYAN}[7/10] Checking for database connection strings${NC}"
db_strings=$(grep -rn 'mongodb://.*:.*@\|mysql://.*:.*@\|postgresql://.*:.*@' . --include="*.sh" 2>/dev/null | \
             grep -v 'localhost\|127.0.0.1\|example.com\|PLACEHOLDER\|\$' | wc -l)
if [ "$db_strings" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No hardcoded connection strings"
else
    echo -e "  ${RED}✗${NC} Found $db_strings connection strings with credentials"
    ((ISSUES_FOUND++))
fi

# Check 8: SSH keys in code
echo -e "${CYAN}[8/10] Checking for SSH keys in files${NC}"
ssh_keys=$(grep -rn '^-----BEGIN.*PRIVATE KEY-----' lib/*.sh setup.sh config/*.json 2>/dev/null | wc -l)
if [ "$ssh_keys" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No SSH keys embedded in files"
else
    echo -e "  ${RED}✗${NC} Found $ssh_keys SSH keys in files - CRITICAL SECURITY ISSUE!"
    ((ISSUES_FOUND++))
fi

# Check 9: AWS/Cloud credentials
echo -e "${CYAN}[9/10] Checking for cloud provider credentials${NC}"
cloud_creds=$(grep -rn '^AWS_ACCESS_KEY\|^AWS_SECRET\|^AZURE_\|^GCP_\|^DO_API_TOKEN' lib/*.sh setup.sh config/*.json 2>/dev/null | \
              grep -v 'PLACEHOLDER\|example\|your_key\|TODO\|grep' | wc -l)
if [ "$cloud_creds" -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No cloud provider credentials found"
else
    echo -e "  ${RED}✗${NC} Found $cloud_creds potential cloud credentials"
    ((ISSUES_FOUND++))
fi

# Check 10: .gitignore exists and is proper
echo -e "${CYAN}[10/10] Checking .gitignore configuration${NC}"
if [ -f ".gitignore" ]; then
    echo -e "  ${GREEN}✓${NC} .gitignore exists"
    
    # Check for important patterns
    patterns=("*.pem" "*.key" ".env" "credentials" "secrets")
    for pattern in "${patterns[@]}"; do
        if grep -q "$pattern" .gitignore 2>/dev/null; then
            echo -e "    ${GREEN}✓${NC} Ignores $pattern"
        else
            echo -e "    ${YELLOW}⚠${NC} Missing pattern: $pattern"
        fi
    done
else
    echo -e "  ${YELLOW}⚠${NC} .gitignore not found - creating one"
    ((ISSUES_FOUND++))
fi

echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}                    AUDIT SUMMARY${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${NC}"
echo ""

if [ "$ISSUES_FOUND" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ NO SECURITY ISSUES FOUND!${NC}"
    echo -e "${GREEN}  Project is safe to push to GitHub${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}${BOLD}✗ FOUND $ISSUES_FOUND POTENTIAL SECURITY ISSUES${NC}"
    echo -e "${YELLOW}  Please review and fix before pushing to GitHub${NC}"
    echo ""
    exit 1
fi
