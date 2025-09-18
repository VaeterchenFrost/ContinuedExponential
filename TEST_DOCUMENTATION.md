# Test Documentation for Fortran Continued Exponential Implementation

## Overview

This document describes the comprehensive test suite for the Fortran implementation of the Continued Exponential Calculator. The test suite validates the correctness of the implementation against known expected results.

## Test Structure

### Test Files

1. **`run_tests.sh`** - Main test script that executes all test cases
2. **`test1_expected.txt`** - Expected results for small grid calculation 
3. **`test2_expected.txt`** - Expected results for specific complex point validation
4. **`test3_expected.txt`** - Expected results for high precision edge case

### Test Cases

#### Test 1: Small Grid Calculation
- **Parameters**: `-0.5 0.5 1.0 2.0 3 3 1e-15 100`
- **Description**: Tests a small 3×3 grid to verify basic grid calculation functionality
- **Complex domain**: Real ∈ [-0.5, 0.5], Imaginary ∈ [1.0, 2.0]
- **Grid resolution**: 3×3 points
- **Expected pattern**: Shows convergence behavior in different regions

#### Test 2: Specific Complex Point Validation  
- **Parameters**: `-2.5 -2.4 4.1 4.2 1 1 1e-16 1900`
- **Description**: Tests calculation near the known interesting point (-2.475... + 4.175...i)
- **Complex domain**: Real ∈ [-2.5, -2.4], Imaginary ∈ [4.1, 4.2]  
- **Grid resolution**: 1×1 point (single point calculation)
- **Expected result**: Convergence code 14 (cycle of length 14)

#### Test 3: High Precision Edge Case
- **Parameters**: `0.0 0.1 0.0 0.1 2 2 1e-18 500`
- **Description**: Tests behavior near the origin with high precision
- **Complex domain**: Real ∈ [0.0, 0.1], Imaginary ∈ [0.0, 0.1]
- **Grid resolution**: 2×2 points
- **Expected pattern**: Simple convergence pattern (all points converge to cycle length 1)

## Running Tests

### Using Makefile
```bash
# Run comprehensive test suite
make test-suite

# Clean up test artifacts
make clean
```

### Direct Script Execution
```bash
# Make script executable
chmod +x run_tests.sh

# Run tests
./run_tests.sh
```

## Test Validation

### Success Criteria
- All three test cases must pass (✓ PASSED status)
- Generated outputs must match expected results exactly
- No compilation warnings or errors
- Proper memory allocation and cleanup

### Output Interpretation

The test script compares the calculation portions of the output files:
- **Grid output section**: Lines starting from "d(Re)=" to end of file
- **Exact match required**: All numerical values must match exactly
- **Result codes**: 
  - Positive integers: Cycle length detected
  - 0: No cycle found within iteration limit  
  - -1: NaN encountered (divergence)

### Debugging Failed Tests

If tests fail:
1. Check `temp_actual.txt` vs `temp_expected.txt` for differences
2. Run `diff temp_expected.txt temp_actual.txt` to see specific changes
3. Verify compilation succeeded without errors
4. Check for system-specific precision differences

## Expected Results Details

### Test 1 Expected Output Pattern
```
calcMField [-.500, .500][1.000, 2.000]
d(Re)= 2.50000000E-01 d(Im)= 2.50000000E-01

1 0 19 31 
1 1 1 1 
1 1 1 1 
```

### Test 2 Expected Output Pattern  
```
calcMField [-2.500, -2.400][4.100, 4.200]
d(Re)= 5.00000000E-02 d(Im)= 5.00000000E-02

14 14 
```

### Test 3 Expected Output Pattern
```
calcMField [.000, .100][.000, .100]
d(Re)= 3.33333333E-02 d(Im)= 3.33333333E-02

1 1 1 
1 1 1 
```

## Maintenance

### Updating Expected Results
If algorithm changes require updated expected results:
1. Run `./run_tests.sh` to generate new outputs
2. Manually verify the new outputs are correct
3. Copy `test*_output.txt` to `test*_expected.txt`
4. Commit the updated expected results

### Adding New Tests
To add additional test cases:
1. Add new test execution in `run_tests.sh`
2. Generate expected results file
3. Add comparison call in the script
4. Update this documentation

## Integration with CI/CD

The test suite is designed for integration with continuous integration:
- **Exit codes**: Script returns 0 on success, non-zero on failure
- **Automated execution**: Can be run without user interaction
- **Clear output**: Color-coded success/failure indicators
- **Artifact cleanup**: Temporary files are cleaned up automatically

## Performance Characteristics

- **Execution time**: ~10-30 seconds on modern hardware
- **Memory usage**: Minimal (test cases use small grids)
- **Disk usage**: ~50KB for all test files combined
- **Dependencies**: Only requires gfortran and bash