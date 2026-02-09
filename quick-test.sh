#!/bin/bash
################################################################################
# Elite Validation Script - Quick Professional Test Suite
# Safe to run on any platform without installation
# Author: naveed-gung (github.com/naveed-gung)
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test counters
PASS=0
FAIL=0
WARN=0
TOTAL=0

# ANSI colors
G='\033[0;32m'  # Green
R='\033[0;31m'  # Red
Y='\033[0;33m'  # Yellow
C='\033[0;36m'  # Cyan
B='\033[1m'     # Bold
NC='\033[0m'    # No Color

pass() {
    echo -e "${G}[✓]${NC} $1"
    ((PASS++)); ((TOTAL++))
}

fail() {
    echo -e "${R}[✗]${NC} $1${2:+ → $2}"
    ((FAIL++)); ((TOTAL++))
}

warn() {
    echo -e "${Y}[⚠]${NC} $1${2:+ → $2}"
    ((WARN++))
}

section() {
    echo -e "\n${B}${C}═══════════════════════════════════════════════${NC}"
    echo -e "${B}${C}  $1${NC}"
    echo -e "${B}${C}═══════════════════════════════════════════════${NC}\n"
}

clear
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║   ELITE AUTO SETUP - VALIDATION SUITE            ║
║   Enterprise-Grade Testing Framework             ║
║   Created by: naveed-gung (github.com/naveed-gung) ║
╚═══════════════════════════════════════════════════╝

EOF

echo -e "${C}Platform:${NC} $(uname -s)"
echo -e "${C}Directory:${NC} ${SCRIPT_DIR}"
echo ""

################################################################################
# Test 1: File Structure
################################################################################
section "1. FILE STRUCTURE VALIDATION"

if [[ -f "${SCRIPT_DIR}/setup.sh" ]]; then
    pass "Main script: setup.sh"
else
    fail "Missing: setup.sh" "CRITICAL"
fi

if [[ -f "${SCRIPT_DIR}/README.md" ]]; then
    pass "Documentation: README.md"
else
    fail "Missing: README.md" "HIGH"
fi

if [[ -f "${SCRIPT_DIR}/LICENSE" ]]; then
    pass "License file: LICENSE"
else
    warn "Missing: LICENSE"
fi

# Library modules
for lib in colors logger utils preflight config installer security reporting notifications; do
    if [[ -f "${SCRIPT_DIR}/lib/${lib}.sh" ]]; then
        lines=$(wc -l < "${SCRIPT_DIR}/lib/${lib}.sh" 2>/dev/null || echo 0)
        pass "Library: lib/${lib}.sh (${lines} lines)"
    else
        fail "Missing: lib/${lib}.sh" "CRITICAL"
    fi
done

# Config files
for cfg in production development; do
    [[ -f "${SCRIPT_DIR}/config/${cfg}.json" ]] && pass "Config: config/${cfg}.json" || fail "Missing: config/${cfg}.json"
done

# Templates
for tpl in nginx.conf mongod.conf ecosystem.config.js; do
    [[ -f "${SCRIPT_DIR}/templates/${tpl}" ]] && pass "Template: templates/${tpl}" || warn "Missing: templates/${tpl}"
done

# Scripts
for scr in health-check.sh rollback.sh; do
    [[ -f "${SCRIPT_DIR}/scripts/${scr}" ]] && pass "Script: scripts/${scr}" || warn "Missing: scripts/${scr}"
done

################################################################################
# Test 2: Syntax Validation
################################################################################
section "2. BASH SYNTAX VALIDATION"

for script in setup.sh lib/*.sh scripts/*.sh tests/*.sh; do
    [[ ! -f "${SCRIPT_DIR}/${script}" ]] && continue
    
    if bash -n "${SCRIPT_DIR}/${script}" 2>/dev/null; then
        pass "Syntax OK: ${script}"
    else
        fail "Syntax error: ${script}" "$(bash -n "${SCRIPT_DIR}/${script}" 2>&1 | head -1)"
    fi
done

################################################################################
# Test 3: JSON Configuration
################################################################################
section "3. JSON CONFIGURATION VALIDATION"

if command -v jq &>/dev/null; then
    for json in config/*.json; do
        [[ ! -f "${SCRIPT_DIR}/${json}" ]] && continue
        
        if jq empty "${SCRIPT_DIR}/${json}" 2>/dev/null; then
            keys=$(jq 'keys | length' "${SCRIPT_DIR}/${json}")
            pass "JSON valid: ${json} (${keys} keys)"
        else
            fail "JSON invalid: ${json}"
        fi
    done
else
    warn "JSON validation skipped" "jq not installed"
fi

################################################################################
# Test 4: Security Checks
################################################################################
section "4. SECURITY ANALYSIS"

# Check for hardcoded credentials
cred_issues=$(grep -riP "password\s*=|api_key\s*=|secret\s*=" "${SCRIPT_DIR}"/{*.sh,lib/*.sh} 2>/dev/null | \
              grep -v "TODO\|EXAMPLE\|PLACEHOLDER\|read" | wc -l || echo 0)
[[ $cred_issues -eq 0 ]] && pass "No hardcoded credentials" || fail "Found ${cred_issues} potential credential exposures"

# Check for unsafe commands
unsafe=$(grep -rP "rm -rf /|chmod 777|chmod -R 777" "${SCRIPT_DIR}"/{*.sh,lib/*.sh} 2>/dev/null | wc -l || echo 0)
[[ $unsafe -eq 0 ]] && pass "No unsafe commands" || fail "Found ${unsafe} unsafe commands"

# Check file permissions
world_write=$(find "${SCRIPT_DIR}" -type f -perm -002 2>/dev/null | wc -l || echo 0)
[[ $world_write -eq 0 ]] && pass "File permissions secure" || warn "Found ${world_write} world-writable files"

################################################################################
# Test 5: Code Quality
################################################################################
section "5. CODE QUALITY METRICS"

# Total lines of code
total_lines=0
for file in lib/*.sh; do
    [[ ! -f "${SCRIPT_DIR}/${file}" ]] && continue
    lines=$(grep -cvE "^\s*#|^\s*$" "${SCRIPT_DIR}/${file}" 2>/dev/null || echo 0)
    total_lines=$((total_lines + lines))
done

if [[ $total_lines -gt 3000 ]]; then
    pass "Codebase size: ${total_lines} lines of code"
elif [[ $total_lines -gt 1000 ]]; then
    warn "Codebase: ${total_lines} lines (expected >3000)"
else
    fail "Small codebase: ${total_lines} lines"
fi

# Function count
func_count=0
for file in lib/*.sh; do
    [[ ! -f "${SCRIPT_DIR}/${file}" ]] && continue
    funcs=$(grep -cE "^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "${SCRIPT_DIR}/${file}" 2>/dev/null || echo 0)
    func_count=$((func_count + funcs))
done

[[ $func_count -gt 30 ]] && pass "Functions: ${func_count} defined" || warn "Only ${func_count} functions"

# Modularity
lib_count=$(find "${SCRIPT_DIR}/lib" -name "*.sh" 2>/dev/null | wc -l)
[[ $lib_count -ge 8 ]] && pass "Modular architecture: ${lib_count} libraries" || warn "Limited modularity: ${lib_count} libraries"

################################################################################
# Test 6: Documentation Quality
################################################################################
section "6. DOCUMENTATION QUALITY"

if [[ -f "${SCRIPT_DIR}/README.md" ]]; then
    readme_lines=$(wc -l < "${SCRIPT_DIR}/README.md")
    readme_words=$(wc -w < "${SCRIPT_DIR}/README.md")
    
    if [[ $readme_lines -gt 200 ]]; then
        pass "README.md: ${readme_lines} lines, ${readme_words} words"
    elif [[ $readme_lines -gt 50 ]]; then
        warn "README.md: ${readme_lines} lines (recommended: 200+)"
    else
        fail "README.md too short: ${readme_lines} lines"
    fi
    
    # Check for key sections
    for section in "Installation" "Usage" "Configuration" "Examples"; do
        grep -qi "^#.*${section}" "${SCRIPT_DIR}/README.md" && \
            pass "README section: ${section}" || \
            warn "Missing section: ${section}"
    done
    
    # Code examples
    code_blocks=$(grep -c '```' "${SCRIPT_DIR}/README.md" || echo 0)
    [[ $code_blocks -gt 10 ]] && pass "Code examples: $((code_blocks / 2)) blocks" || \
        warn "Limited examples: $((code_blocks / 2)) blocks"
else
    fail "README.md missing" "CRITICAL"
fi

# Inline comments
total_comments=0
total_code=0
for file in lib/*.sh; do
    [[ ! -f "${SCRIPT_DIR}/${file}" ]] && continue
    comments=$(grep -cE "^\s*#" "${SCRIPT_DIR}/${file}" 2>/dev/null || echo 0)
    code=$(grep -cvE "^\s*#|^\s*$" "${SCRIPT_DIR}/${file}" 2>/dev/null || echo 0)
    total_comments=$((total_comments + comments))
    total_code=$((total_code + code))
done

if [[ $total_code -gt 0 ]]; then
    comment_ratio=$((total_comments * 100 / total_code))
    if [[ $comment_ratio -gt 20 ]]; then
        pass "Inline documentation: ${comment_ratio}% (${total_comments} comments)"
    elif [[ $comment_ratio -gt 10 ]]; then
        warn "Comment density: ${comment_ratio}% (recommended: 20%+)"
    else
        fail "Insufficient comments: ${comment_ratio}%"
    fi
fi

################################################################################
# Test 7: Integration Tests
################################################################################
section "7. INTEGRATION & COMPATIBILITY"

# Check library sourcing
if grep -q "source.*lib/.*\.sh" "${SCRIPT_DIR}/setup.sh" 2>/dev/null; then
    sourced=$(grep -c "source.*lib/.*\.sh" "${SCRIPT_DIR}/setup.sh")
    pass "Library sourcing: ${sourced} libraries"
else
    fail "No library sourcing in main script"
fi

# Command availability
for cmd in bash grep sed awk curl; do
    command -v "$cmd" &>/dev/null && pass "Command available: ${cmd}" || warn "Missing command: ${cmd}"
done

# Optional tools
for cmd in jq shellcheck git; do
    command -v "$cmd" &>/dev/null && pass "Optional tool: ${cmd}" || true
done

# Platform check
platform=$(uname -s)
case "$platform" in
    Linux)
        pass "Platform: Linux (primary target)"
        ;;
    Darwin)
        warn "Platform: macOS (some features may not work)"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        warn "Platform: Windows/${platform} (designed for Linux)"
        ;;
    *)
        fail "Unknown platform: ${platform}"
        ;;
esac

################################################################################
# Test 8: Compliance & Standards
################################################################################
section "8. COMPLIANCE & BEST PRACTICES"

# License
[[ -f "${SCRIPT_DIR}/LICENSE" ]] && pass "License file present" || warn "No LICENSE file"

# Version tracking
grep -q "VERSION=" "${SCRIPT_DIR}/setup.sh" 2>/dev/null && \
    pass "Version tracking enabled" || \
    warn "No version information"

# Copyright
copyright=$(grep -r "Copyright\|©" "${SCRIPT_DIR}"/{*.sh,lib/*.sh} 2>/dev/null | wc -l || echo 0)
[[ $copyright -gt 0 ]] && pass "Copyright notices: ${copyright} files" || warn "No copyright notices"

# Exit code handling
exits=$(grep -r "exit [0-9]" "${SCRIPT_DIR}"/{*.sh,lib/*.sh} 2>/dev/null | wc -l || echo 0)
[[ $exits -gt 5 ]] && pass "Exit handling: ${exits} exit points" || warn "Limited exit handling"

################################################################################
# Summary
################################################################################
section "TEST SUMMARY"

echo -e "${B}Total Tests:${NC}    ${TOTAL}"
echo -e "${G}${B}✓ Passed:${NC}       ${PASS}"
echo -e "${R}${B}✗ Failed:${NC}       ${FAIL}"
echo -e "${Y}${B}⚠ Warnings:${NC}     ${WARN}"
echo ""

# Success rate
if [[ $TOTAL -gt 0 ]]; then
    success_rate=$(awk "BEGIN {printf \"%.1f\", ($PASS * 100.0 / $TOTAL)}")
    echo -e "${B}Success Rate:${NC}   ${success_rate}%"
    
    # Progress bar
    filled=$(awk "BEGIN {printf \"%.0f\", ($success_rate / 2)}")
    empty=$((50 - filled))
    printf "["
    printf "${G}%${filled}s${NC}" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "]\n\n"
fi

# Final verdict
if [[ $FAIL -eq 0 ]]; then
    echo -e "${G}${B}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${G}${B}║        ✓ ALL TESTS PASSED!                    ║${NC}"
    echo -e "${G}${B}║   Project is production-ready                 ║${NC}"
    echo -e "${G}${B}╚═══════════════════════════════════════════════╝${NC}"
    
    if [[ $WARN -gt 0 ]]; then
        echo -e "\n${Y}Note: ${WARN} warnings found. Review recommended.${NC}"
    fi
    
    echo -e "\n${C}Next Steps:${NC}"
    echo "  1. Transfer to Linux server: scp -r . user@server:/opt/elite-setup"
    echo "  2. SSH into server: ssh user@server"
    echo "  3. Run installation: cd /opt/elite-setup && sudo ./setup.sh"
    echo ""
    exit 0
else
    echo -e "${R}${B}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${R}${B}║        ✗ TESTS FAILED!                        ║${NC}"
    echo -e "${R}${B}║   Please fix issues before deployment        ║${NC}"
    echo -e "${R}${B}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    exit 1
fi

echo -e "\n${C}Created by: naveed-gung (https://github.com/naveed-gung) | Portfolio: https://naveed-gung.dev${NC}\n"
