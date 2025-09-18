# ContinuedExponential
A dual C++ and Fortran implementation for computing convergence criteria of continued exponentials with high precision.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the information here.

## Working Effectively

### Bootstrap, Build, and Test the Repository

The repository supports both C++ and Fortran implementations. Each can be built and tested independently.

#### C++ Implementation
- Install build tools (if needed):
  - `sudo apt-get update && sudo apt-get install -y build-essential g++` -- installs C++ compiler toolchain
- Basic build: 
  - `g++ -o main main.cpp` -- basic compilation, takes ~0.4 seconds
- Optimized build (recommended):
  - `g++ -O2 -std=c++14 -o main_optimized main.cpp` -- optimized build with C++14 support for complex literals, takes ~0.4 seconds

#### Fortran Implementation  
- Install build tools (if needed):
  - `sudo apt-get update && sudo apt-get install -y gfortran` -- installs Fortran compiler
- Build using Makefile (recommended):
  - `make` -- builds Fortran program as `continued_exponential`, takes ~0.4 seconds
  - `make release` -- optimized build with `-O3 -march=native`, takes ~0.4 seconds
- Direct compilation:
  - `gfortran -std=f2018 -O2 -o continued_exponential continued_exponential.f90` -- basic build
- NEVER CANCEL builds - they complete very quickly (under 2 seconds)

### Run the Application

Both implementations have similar command-line interfaces and produce comparable results.

#### C++ Implementation
- ALWAYS build the application first using the optimized build command
- Basic execution with default parameters:
  - `./main_optimized` -- uses default complex plane region [-1, 0.5] x [2, 3] with 20x20 resolution, takes ~0.18 seconds
- Custom parameters:
  - `./main_optimized minRe maxRe minIm maxIm numRe numIm [eps] [VECLENGTH]`
  - Example: `./main_optimized -1 0.5 2 3 10 10` -- 10x10 grid, takes ~0.05 seconds
  - Example: `./main_optimized -1 0.5 2 3 50 50` -- 50x50 grid, takes ~1.1 seconds
  - Example: `./main_optimized -1 0.5 2 3 100 100` -- 100x100 grid, takes ~4.4 seconds

#### Fortran Implementation  
- ALWAYS build the application first using make
- Basic execution with default parameters:
  - `./continued_exponential` -- uses default complex plane region [-1, 0.5] x [2, 3] with 20x20 resolution, takes ~0.18 seconds
- Custom parameters:
  - `./continued_exponential minRe maxRe minIm maxIm numRe numIm [eps] [vecLength]`
  - Example: `./continued_exponential -1 0.5 2 3 10 10` -- 10x10 grid, takes ~0.05 seconds
  - Example: `./continued_exponential -1 0.5 2 3 50 50` -- 50x50 grid, takes ~1.1 seconds
  - Example: `./continued_exponential -1 0.5 2 3 100 100` -- 100x100 grid, takes ~4.4 seconds

#### Unified Build and Test
- Build both implementations: `make all cpp`
- Test both implementations: `make test`
- Compare outputs: `make compare`

- NEVER CANCEL program execution - even large grids (100x100) complete in under 5 seconds

## Validation

## Validation

### Testing Scenarios

#### C++ Implementation
- ALWAYS test basic compilation: `g++ -o main main.cpp && ./main`
- ALWAYS test optimized compilation: `g++ -O2 -std=c++14 -o main_optimized main.cpp && ./main_optimized`
- Test with different grid sizes to verify functionality:
  - Small: `./main_optimized -1 0.5 2 3 5 5` (~0.01 seconds)
  - Medium: `./main_optimized -1 0.5 2 3 20 20` (~0.18 seconds)
  - Large: `./main_optimized -1 0.5 2 3 50 50` (~1.1 seconds)

#### Fortran Implementation
- ALWAYS test basic compilation: `make && ./continued_exponential`
- ALWAYS test optimized compilation: `make release && ./continued_exponential`
- Test with different grid sizes to verify functionality:
  - Small: `./continued_exponential -1 0.5 2 3 5 5` (~0.01 seconds)
  - Medium: `./continued_exponential -1 0.5 2 3 20 20` (~0.18 seconds)
  - Large: `./continued_exponential -1 0.5 2 3 50 50` (~1.1 seconds)

#### Comprehensive Testing
- Run automated test suite: `make test-suite` -- runs comprehensive Fortran tests with validation
- Cross-implementation testing: `make test` -- runs both C++ and Fortran versions
- Output comparison: `make compare` -- generates output files for manual comparison

#### Output Verification (Both Implementations)
- Verify the output contains:
  - Program header with "Program to calculate Continued Exponential"
  - Precision information (C++: long double, Fortran: real128)
  - Test calculation results
  - Grid calculation results as integer matrix

### Manual Validation Requirements

#### C++ Implementation
- ALWAYS execute the program after building to ensure it runs without errors
- Verify the program displays precision information correctly (long double, ~19 decimal places)
- Check that the numerical output matrix contains expected values (integers and -1 for NaN cases)
- Confirm timing performance matches expectations based on grid size

#### Fortran Implementation
- ALWAYS execute the program after building to ensure it runs without errors
- Verify the program displays precision information correctly (real128, ~33 decimal places)
- Check that the numerical output matrix contains expected values (integers and -1 for NaN cases)
- Confirm timing performance matches expectations based on grid size
- Validate that real128 precision is being used (higher accuracy than C++ version)

#### Cross-Implementation Validation
- Results should be functionally identical between C++ and Fortran
- Minor numerical differences expected due to precision differences (real128 vs long double)
- Grid output patterns should match, with possible minor variations in edge cases

## Build Details

### Compiler Requirements

#### C++ Implementation
- g++ (GNU C++ compiler) version 13.3.0 or compatible
- C++14 standard support required for complex number literals (suffix 'i')
- Standard library support for complex numbers, vectors, and mathematical functions

#### Fortran Implementation
- GNU Fortran (gfortran) 9.0 or later
- Fortran 2018+ compliant compiler
- real128 support for quadruple precision (fallback to real64 if unavailable)
- IEEE arithmetic support for robust NaN handling

### Build Flags and Optimization

#### C++ Build Flags
- Basic: No special flags needed
- Recommended: `-O2 -std=c++14` for optimized performance with C++14 features
- The code compiles cleanly with no warnings on g++ 13.3.0

#### Fortran Build Flags
- Debug build (default): `-std=f2018 -Wall -Wextra -pedantic -fcheck=all -g -O2`
- Release build: `-std=f2018 -O3 -march=native` (via `make release`)
- The code compiles with minimal warnings on gfortran 9.0+

### Build Times and Timeouts
- NEVER CANCEL any build operation
- C++ basic build: ~0.4 seconds (set timeout to 30 seconds minimum)
- C++ optimized build: ~0.4 seconds (set timeout to 30 seconds minimum)
- Fortran build: ~0.4 seconds (set timeout to 30 seconds minimum)
- There are no long-running builds in this project

## Program Behavior and Parameters

### Command Line Arguments

Both implementations use identical command-line interfaces:

- No arguments: Uses standard parameters [-1, 0.5] x [2, 3], 20x20 grid, eps=1e-16, vector length=1900
- 4+ arguments: minRe, maxRe, minIm, maxIm (required)
- 6+ arguments: adds numRe, numIm (grid resolution)
- 7+ arguments: adds eps (epsilon for zero-detection)
- 8+ arguments: adds vector length (maximum iteration steps)

### Performance Characteristics
- Execution time scales roughly with grid size (numRe × numIm)
- 5x5 grid: ~0.01 seconds
- 10x10 grid: ~0.05 seconds
- 20x20 grid: ~0.18 seconds  
- 50x50 grid: ~1.1 seconds
- 100x100 grid: ~4.4 seconds
- NEVER CANCEL program execution - even largest typical grids complete quickly

### Output Format

Both implementations produce similar output with minor formatting differences:

#### Common Output Elements
- Program header and precision information
- Test calculation with complex result vector
- Main calculation displaying integer matrix representing convergence properties
- Values: positive integers (convergence order), 0 (filled/no cycle), -1 (NaN/divergent)

#### Implementation-Specific Differences
- **C++ Output**: Scientific notation, long double precision (~19 digits)
- **Fortran Output**: Enhanced precision display, real128 precision (~33 digits)
- **Numerical Values**: Functionally identical, minor precision variations expected

## Project Structure

### Key Files

#### C++ Implementation
- `main.cpp` - Primary C++ source file containing all implementation
- `main_optimized` - Compiled optimized C++ executable

#### Fortran Implementation  
- `continued_exponential.f90` - Modern Fortran 2018/2023 source file
- `continued_exponential` - Compiled Fortran executable
- `Makefile` - Build system for Fortran (and C++ reference builds)
- `run_tests.sh` - Comprehensive test suite for Fortran implementation
- `README_FORTRAN.md` - Detailed Fortran implementation documentation
- `TEST_DOCUMENTATION.md` - Test suite documentation
- `FORTRAN_ANALYSIS.md` - Compliance and feature analysis
- `test1_expected.txt`, `test2_expected.txt`, `test3_expected.txt` - Expected test outputs

#### Shared Files
- `README.md` - Project overview and description
- `LICENSE` - GPL-3.0 license file
- `Blendown.nb` - Mathematica notebook for visualization (ASCII text format)
- `ImportBigData.nb` - Mathematica notebook for data processing (ASCII text format)
- `main.exe` - Windows executable (PE32+ format, not runnable on Linux)

### Important Code Sections

#### C++ Implementation
- `safeCalcLongAtZ()` - Core function computing continued exponential at complex point z
- `calcMField()` - Main computation loop over complex plane grid
- `CycleDetectDLONG()` - Cycle detection algorithm
- `main()` - Entry point with parameter parsing and execution flow

#### Fortran Implementation
- `safe_calc_at_z()` - Core function computing continued exponential (equivalent to C++ version)
- `calc_m_field()` - Main computation loop with enhanced precision
- `cycle_detect()` - Cycle detection with IEEE arithmetic support
- `main program` - Entry point with robust parameter parsing

## Common Tasks

### Testing Changes

#### C++ Implementation
- Always build and run after making changes: `g++ -O2 -std=c++14 -o main_optimized main.cpp && ./main_optimized`
- Test with small grid first: `./main_optimized -1 0.5 2 3 5 5`
- Test with standard grid: `./main_optimized -1 0.5 2 3 20 20`
- Verify output format remains consistent

#### Fortran Implementation
- Always build and run after making changes: `make clean && make && ./continued_exponential`
- Test with small grid first: `./continued_exponential -1 0.5 2 3 5 5`
- Test with standard grid: `./continued_exponential -1 0.5 2 3 20 20`
- Run test suite: `make test-suite`
- Verify output format remains consistent

#### Cross-Implementation Testing
- Build both: `make all cpp`
- Test both: `make test`
- Compare outputs: `make compare`

### Debugging

#### C++ Implementation
- Compilation errors are typically related to C++ standard compliance
- Use `-std=c++14` for complex literal support
- Runtime errors are rare - the program is mathematically robust
- For performance issues, check grid size parameters

#### Fortran Implementation
- Compilation errors often related to Fortran standard compliance or real128 availability
- Use `-std=f2018` for modern Fortran features
- Runtime errors are rare due to comprehensive error checking
- Memory allocation errors handled gracefully with fallbacks
- For performance issues, check grid size parameters and precision settings

### Dependencies

#### C++ Dependencies
- No external dependencies beyond standard C++ library
- Uses: iostream, iomanip, stdlib.h, complex, vector, limits, time.h
- All dependencies are part of standard g++ installation

#### Fortran Dependencies  
- GNU Fortran (gfortran) compiler
- Standard Fortran 2018+ library modules: iso_fortran_env, ieee_arithmetic
- No external dependencies beyond standard Fortran library
- All dependencies are part of standard gfortran installation

## Verification Commands Summary

### C++ Implementation
```bash
# Essential C++ validation sequence:
g++ -O2 -std=c++14 -o main_optimized main.cpp  # Build (~0.4 sec)
./main_optimized                                # Test default (~0.18 sec)  
./main_optimized -1 0.5 2 3 10 10              # Test custom (~0.05 sec)
```

### Fortran Implementation
```bash
# Essential Fortran validation sequence:
make clean && make                              # Build (~0.4 sec)
./continued_exponential                         # Test default (~0.18 sec)
./continued_exponential -1 0.5 2 3 10 10       # Test custom (~0.05 sec)
make test-suite                                 # Run comprehensive tests
```

### Unified Testing
```bash
# Build and test both implementations:
make all cpp                                    # Build both versions
make test                                       # Test both versions
make compare                                    # Compare outputs
```

CRITICAL: NEVER CANCEL any operation in this repository - all builds and executions complete in seconds.