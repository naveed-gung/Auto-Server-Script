#!/bin/bash

################################################################################
# Test Suite for Elite Auto Server Setup
# Tests all core functionality
# Author: naveed-gung (https://github.com/naveed-gung)
################################################################################

set -euo pipefail

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

################################################################################
# Test utilities
################################################################################
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    if [[ "${expected}" == "${actual}" ]]; then
        echo -e "${GREEN}[PASS]${NC} ${test_name}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}[FAIL]${NC} ${test_name}"
        echo "  Expected: ${expected}"
        echo "  Actual: ${actual}"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_true() {
    local condition=$1
    local test_name="$2"
    
    if $condition; then
        echo -e "${GREEN}[PASS]${NC} ${test_name}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}[FAIL]${NC} ${test_name}"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_command_exists() {
    local command="$1"
    local test_name="Test: ${command} command exists"
    
    if command -v "${command}" &> /dev/null; then
        echo -e "${GREEN}[PASS]${NC} ${test_name}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}[FAIL]${NC} ${test_name}"
        ((TESTS_FAILED++))
        return 1
    fi
}

################################################################################
# Test library functions
################################################################################
test_library_functions() {
    echo "Testing library functions..."
    echo ""
    
    # Source libraries
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "${SCRIPT_DIR}/lib/colors.sh"
    source "${SCRIPT_DIR}/lib/utils.sh"
    
    # Test OS detection
    local os_type=$(get_os_type)
    assert_true "[[ -n '${os_type}' ]]" "OS type detection"
    
    # Test package manager detection
    local pkg_mgr=$(get_package_manager)
    assert_true "[[ -n '${pkg_mgr}' ]]" "Package manager detection"
    
    # Test validation functions
    assert_true "is_valid_email 'test@example.com'" "Valid email detection"
    assert_true "! is_valid_email 'invalid-email'" "Invalid email detection"
    
    assert_true "is_valid_domain 'example.com'" "Valid domain detection"
    assert_true "! is_valid_domain 'invalid..domain'" "Invalid domain detection"
    
    # Test string functions
    local result=$(to_lowercase "HELLO")
    assert_equals "hello" "${result}" "String lowercase conversion"
    
    result=$(to_uppercase "hello")
    assert_equals "HELLO" "${result}" "String uppercase conversion"
    
    echo ""
}

################################################################################
# Test configuration loading
################################################################################
test_configuration() {
    echo "Testing configuration..."
    echo ""
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "${SCRIPT_DIR}/lib/config.sh"
    
    # Test profile loading
    load_profile "production"
    assert_equals "true" "${CONFIG[nodejs_enabled]}" "Production profile Node.js enabled"
    assert_equals "true" "${CONFIG[mongodb_auth]}" "Production profile MongoDB auth enabled"
    
    load_profile "development"
    assert_equals "false" "${CONFIG[mongodb_auth]}" "Development profile MongoDB auth disabled"
    
    echo ""
}

################################################################################
# Test preflight checks
################################################################################
test_preflight() {
    echo "Testing preflight checks..."
    echo ""
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "${SCRIPT_DIR}/lib/preflight.sh"
    
    # Test basic system checks
    assert_true "check_internet_connectivity" "Internet connectivity check"
    assert_true "check_disk_space" "Disk space check"
    assert_true "check_memory" "Memory check"
    assert_true "check_cpu" "CPU check"
    
    echo ""
}

################################################################################
# Test file structure
################################################################################
test_file_structure() {
    echo "Testing file structure..."
    echo ""
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    local required_files=(
        "setup.sh"
        "lib/colors.sh"
        "lib/logger.sh"
        "lib/utils.sh"
        "lib/preflight.sh"
        "lib/config.sh"
        "lib/installer.sh"
        "lib/security.sh"
        "lib/reporting.sh"
        "lib/notifications.sh"
        "config/production.json"
        "config/development.json"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "${SCRIPT_DIR}/${file}" ]]; then
            echo -e "${GREEN}[PASS]${NC} File exists: ${file}"
            ((TESTS_PASSED++))
        else
            echo -e "${RED}[FAIL]${NC} File missing: ${file}"
            ((TESTS_FAILED++))
        fi
    done
    
    echo ""
}

################################################################################
# Main test runner
################################################################################
main() {
    echo "========================================="
    echo "  Elite Setup - Test Suite"
    echo "========================================="
    echo ""
    
    test_file_structure
    test_library_functions
    test_configuration
    test_preflight
    
    echo "========================================="
    echo "  Test Results"
    echo "========================================="
    echo -e "${GREEN}Passed:${NC} ${TESTS_PASSED}"
    echo -e "${RED}Failed:${NC} ${TESTS_FAILED}"
    echo ""
    
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo "Some tests failed. Please review the output above."
        exit 1
    else
        echo "All tests passed successfully!"
        exit 0
    fi
}

main "$@"
