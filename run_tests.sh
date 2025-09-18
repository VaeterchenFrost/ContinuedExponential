#!/bin/bash
# Test script for Fortran Continued Exponential implementation
# This script runs specific test cases and compares with expected results

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running Fortran Continued Exponential Tests${NC}"
echo "=============================================="

# Build the program if needed
if [ ! -f "./continued_exponential" ]; then
    echo "Building Fortran program..."
    make clean && make
fi

# Test case 1: Small grid for precise validation
echo -e "\n${YELLOW}Test 1: Small grid calculation${NC}"
./continued_exponential -0.5 0.5 1.0 2.0 3 3 1e-15 100 > test1_output.txt 2>&1

# Test case 2: Single point calculation (same as in main program)
echo -e "\n${YELLOW}Test 2: Specific complex point validation${NC}"  
./continued_exponential -2.5 -2.4 4.1 4.2 1 1 1e-16 1900 > test2_output.txt 2>&1

# Test case 3: Edge case with different precision
echo -e "\n${YELLOW}Test 3: High precision edge case${NC}"
./continued_exponential 0.0 0.1 0.0 0.1 2 2 1e-18 500 > test3_output.txt 2>&1

echo -e "\n${GREEN}Test outputs generated:${NC}"
echo "- test1_output.txt: Small grid calculation"
echo "- test2_output.txt: Specific complex point"  
echo "- test3_output.txt: High precision edge case"

echo -e "\n${YELLOW}Comparing with expected results...${NC}"

# Function to compare results
compare_results() {
    local test_file=$1
    local expected_file=$2
    local test_name=$3
    
    if [ -f "$expected_file" ]; then
        # Extract just the grid calculation part for comparison
        if grep -q "calcMField" "$test_file" && grep -q "calcMField" "$expected_file"; then
            # Compare the grid output (lines after "d(Re)=" until end)
            sed -n '/d(Re)=/,$p' "$test_file" > temp_actual.txt
            sed -n '/d(Re)=/,$p' "$expected_file" > temp_expected.txt
            
            if cmp -s temp_actual.txt temp_expected.txt; then
                echo -e "${GREEN}✓ $test_name: PASSED${NC}"
                return 0
            else
                echo -e "${RED}✗ $test_name: FAILED - Results differ${NC}"
                echo "  Run 'diff temp_expected.txt temp_actual.txt' to see differences"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠ $test_name: Cannot compare - missing calculation section${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ $test_name: No expected results file found${NC}"
        return 1
    fi
}

# Compare with expected results if they exist
compare_results "test1_output.txt" "test1_expected.txt" "Test 1"
compare_results "test2_output.txt" "test2_expected.txt" "Test 2"  
compare_results "test3_output.txt" "test3_expected.txt" "Test 3"

# Cleanup temporary files
rm -f temp_actual.txt temp_expected.txt

echo -e "\n${YELLOW}Test Summary:${NC}"
echo "Generated test outputs for validation against expected results."
echo "To create expected results, run this script and verify outputs manually,"
echo "then copy the *_output.txt files to *_expected.txt files."

echo -e "\n${GREEN}Test script completed.${NC}"