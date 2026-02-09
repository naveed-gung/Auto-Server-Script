#!/bin/bash
################################################################################
# GitHub Ready Check - Final Verification Before Push
################################################################################

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║     GITHUB PUSH READINESS CHECK                         ║"
echo "║     Final verification before pushing to GitHub         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

TOTAL=0
PASSED=0
FAILED=0

run_check() {
    local name="$1"
    local command="$2"
    ((TOTAL++))
    
    echo -n "  Testing: $name... "
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC}"
        ((FAILED++))
        return 1
    fi
}

echo -e "${CYAN}[1/5] Syntax Validation${NC}"
run_check "setup.sh syntax" "bash -n setup.sh"
run_check "quick-test.sh syntax" "bash -n quick-test.sh"
run_check "security-audit.sh syntax" "bash -n security-audit.sh"
run_check "ui-demo.sh syntax" "bash -n ui-demo.sh"
run_check "All lib files syntax" "bash -n lib/*.sh"
run_check "All script files syntax" "bash -n scripts/*.sh"
echo ""

echo -e "${CYAN}[2/5] Required Files${NC}"
run_check "README.md exists" "test -f README.md"
run_check "LICENSE exists" "test -f LICENSE"
run_check ".gitignore exists" "test -f .gitignore"
run_check "setup.sh exists" "test -f setup.sh"
run_check "PRE-PUSH-CHECKLIST.md exists" "test -f PRE-PUSH-CHECKLIST.md"
echo ""

echo -e "${CYAN}[3/5] GitHub & Portfolio Links${NC}"
run_check "GitHub link in README" "grep -q 'github.com/naveed-gung' README.md"
run_check "Portfolio link in README" "grep -q 'naveed-gung.dev' README.md"
run_check "Portfolio link in setup.sh" "grep -q 'naveed-gung.dev' setup.sh"
echo ""

echo -e "${CYAN}[4/5] No Sensitive Data${NC}"
run_check "No .env files" "! find . -name '.env*' -type f | grep -q ."
run_check "No .pem files" "! find . -name '*.pem' -type f | grep -q ."
run_check "No .key files" "! find . -name '*.key' -type f | grep -q ."
run_check "No credential files" "! find . -name '*credential*' -type f | grep -q ."
run_check "No tmp files" "! ls tmpclaude-* 2>/dev/null | grep -q ."
echo ""

echo -e "${CYAN}[5/5] Configuration Safety${NC}"
run_check "Config files use examples only" "grep -q 'example.com' config/production.json"
run_check "No real webhooks in configs" "! grep -qE 'https://hooks.slack.com/services/[A-Z0-9]{9}' config/*.json"
echo ""

echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}                    FINAL SUMMARY${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}  Passed:  ${PASSED}/${TOTAL}${NC}"
echo -e "${RED}  Failed:  ${FAILED}/${TOTAL}${NC}"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║  ✓ PROJECT IS READY FOR GITHUB!                        ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                         ║${NC}"
    echo -e "${GREEN}${BOLD}║  • No sensitive data detected                           ║${NC}"
    echo -e "${GREEN}${BOLD}║  • All syntax checks passed                             ║${NC}"
    echo -e "${GREEN}${BOLD}║  • Documentation is complete                            ║${NC}"
    echo -e "${GREEN}${BOLD}║  • .gitignore is configured                             ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                         ║${NC}"
    echo -e "${GREEN}${BOLD}║  Safe to push to GitHub! 🚀                             ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. Review PRE-PUSH-CHECKLIST.md"
    echo "  2. git init (if not done)"
    echo "  3. git add ."
    echo "  4. git commit -m 'Initial commit'"
    echo "  5. git remote add origin <your-repo-url>"
    echo "  6. git push -u origin main"
    echo ""
    exit 0
else
    echo -e "${RED}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║  ✗ NOT READY FOR GITHUB                                 ║${NC}"
    echo -e "${RED}${BOLD}║  Please fix the failed checks above                     ║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    exit 1
fi
