# Fortran 2023 Implementation of Continued Exponential Calculator

## Overview

This directory contains a modern Fortran implementation of the Continued Exponential Calculator, translated from the original C++ version. The program calculates continued exponentials of the form:

**F(n) = exp(z * F(n-1))**

where z is a complex number and the iteration starts with F(0) = 1.

## Features

### Modern Fortran Standards Compliance
- **Fortran 2018/2023 compliant** code using modern best practices
- **Automatic precision selection** (real128 if available, fallback to real64)
- **IEEE arithmetic support** for robust NaN and infinity handling
- **Memory-safe design** with allocatable arrays and automatic cleanup
- **Comprehensive error checking** for memory allocation and numerical issues

### Technical Improvements over C++ Version
- **Higher numerical precision** (33 decimal digits vs 19 in C++)
- **Automatic memory management** (no manual allocation/deallocation)
- **Better error handling** using IEEE intrinsics
- **Modern array processing** using Fortran intrinsic functions
- **Improved portability** with precision fallback mechanism

## Building and Running

### Prerequisites
- GNU Fortran (gfortran) 9.0 or later
- Standard Fortran 2018+ compliant compiler

### Build Commands
```bash
# Build the main program
make

# Build both Fortran and C++ versions
make all cpp

# Build optimized release version
make release

# Clean build artifacts
make clean

# Show help
make help
```

### Running the Program

#### Basic execution (default parameters):
```bash
./continued_exponential
```

#### With custom parameters:
```bash
./continued_exponential minRe maxRe minIm maxIm numRe numIm eps vecLength
```

**Example:**
```bash
./continued_exponential -1.0 0.5 2.0 3.0 20 20 1e-16 1900
```

**Parameters:**
- `minRe, maxRe`: Real axis bounds
- `minIm, maxIm`: Imaginary axis bounds  
- `numRe, numIm`: Number of grid points on each axis
- `eps`: Tolerance for cycle detection
- `vecLength`: Maximum iterations per point

## Output Format

The program outputs:
1. **System information**: Precision details and numeric limits
2. **Test calculation**: Results for a specific complex point
3. **Grid calculation**: Convergence analysis over a complex plane region

The grid output shows integer codes for each point:
- **Positive values**: Cycle length detected
- **0**: No cycle found within iteration limit
- **-1**: NaN encountered (divergence)

## Algorithm Details

### Core Calculation
For each complex point z in the specified region:
1. Initialize F(0) = 1
2. Iterate F(n) = exp(z * F(n-1)) up to maximum steps
3. Detect convergence patterns:
   - **Near-zero values** (potential fixed points)
   - **Cycle detection** (repeating sequences)
   - **NaN detection** (numerical overflow/underflow)

### Numerical Robustness
- **IEEE arithmetic compliance** for proper NaN/infinity handling
- **Configurable precision** with automatic fallback
- **Comprehensive bounds checking** in debug builds
- **Memory safety** through automatic allocation management

## Differences from C++ Version

### Improvements
1. **Higher precision arithmetic** (real128 vs long double)
2. **Better memory management** (automatic vs manual)
3. **Enhanced error detection** (IEEE vs manual checking)
4. **Modern language features** (array intrinsics, parameterized types)

### Minor Differences
1. **Output formatting** (scientific notation style differences)
2. **Numerical precision** (may cause minor result variations)
3. **Command line parsing** (more robust in Fortran version)

## Testing and Validation

### Comparison with C++ Reference
```bash
# Run comparison test
make compare

# This generates:
# - fortran_output.txt
# - cpp_output.txt
```

### Expected Results
The Fortran implementation should produce results that are:
- **Functionally identical** to the C++ version
- **Numerically consistent** to ~15 decimal places
- **Algorithmically equivalent** in convergence detection

## Performance Characteristics

### Compilation Options
- **Debug build**: `-fcheck=all -g` (default)
- **Release build**: `-O3 -march=native` (via `make release`)

### Memory Usage
- **Automatic scaling** based on vector length parameter
- **Efficient allocation** using Fortran allocatable arrays
- **No memory leaks** due to automatic cleanup

### Precision Trade-offs
- **real128**: Higher accuracy, slightly slower
- **real64**: Faster execution, lower precision (if real128 unavailable)

## Development Notes

### Code Structure
- **Single source file** for simplicity
- **Internal procedures** for modular design  
- **Comprehensive documentation** using structured comments
- **Modern Fortran idioms** throughout

### Extensibility
The implementation is designed for easy extension:
- **Parameterized precision** for different accuracy requirements
- **Modular procedures** for algorithm customization
- **Clean interfaces** for integration with other codes

## Future Enhancements

Potential improvements identified:
1. **Parallel processing** using `do concurrent`
2. **Object-oriented design** with derived types
3. **NetCDF output** for large dataset handling
4. **Module-based architecture** for reusability

## Author and License

- **Original C++ Implementation**: Martin Roebke (2018)
- **Fortran Translation**: 2024
- **License**: GNU General Public License v3.0

## References

- Original inspiration: Mathematical Physics 05 - Carl Bender
- YouTube: https://www.youtube.com/watch?v=LMw0NZDM5B4
- Related research on continued exponentials and complex dynamics