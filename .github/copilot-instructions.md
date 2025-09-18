# ContinuedExponential
A C++ implementation for computing convergence criteria of continued exponentials with long double precision.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the information here.

## Working Effectively

### Bootstrap, Build, and Test the Repository
- Install build tools (if needed):
  - `sudo apt-get update && sudo apt-get install -y build-essential g++` -- installs C++ compiler toolchain
- Basic build: 
  - `g++ -o main main.cpp` -- basic compilation, takes ~0.4 seconds
- Optimized build (recommended):
  - `g++ -O2 -std=c++14 -o main_optimized main.cpp` -- optimized build with C++14 support for complex literals, takes ~0.4 seconds
- NEVER CANCEL builds - they complete very quickly (under 2 seconds)

### Run the Application
- ALWAYS build the application first using the optimized build command
- Basic execution with default parameters:
  - `./main_optimized` -- uses default complex plane region [-1, 0.5] x [2, 3] with 20x20 resolution, takes ~0.18 seconds
- Custom parameters:
  - `./main_optimized minRe maxRe minIm maxIm numRe numIm [eps] [VECLENGTH]`
  - Example: `./main_optimized -1 0.5 2 3 10 10` -- 10x10 grid, takes ~0.05 seconds
  - Example: `./main_optimized -1 0.5 2 3 50 50` -- 50x50 grid, takes ~1.1 seconds
  - Example: `./main_optimized -1 0.5 2 3 100 100` -- 100x100 grid, takes ~4.4 seconds
- NEVER CANCEL program execution - even large grids (100x100) complete in under 5 seconds

## Validation

### Testing Scenarios
- ALWAYS test basic compilation: `g++ -o main main.cpp && ./main`
- ALWAYS test optimized compilation: `g++ -O2 -std=c++14 -o main_optimized main.cpp && ./main_optimized`
- Test with different grid sizes to verify functionality:
  - Small: `./main_optimized -1 0.5 2 3 5 5` (~0.01 seconds)
  - Medium: `./main_optimized -1 0.5 2 3 20 20` (~0.18 seconds)
  - Large: `./main_optimized -1 0.5 2 3 50 50` (~1.1 seconds)
- Verify the output contains:
  - Program header with "Program to calculate Continued Exponential"
  - Precision information
  - Test calculation results
  - Grid calculation results as integer matrix

### Manual Validation Requirements
- ALWAYS execute the program after building to ensure it runs without errors
- Verify the program displays precision information correctly
- Check that the numerical output matrix contains expected values (integers and -1 for NaN cases)
- Confirm timing performance matches expectations based on grid size

## Build Details

### Compiler Requirements
- g++ (GNU C++ compiler) version 13.3.0 or compatible
- C++14 standard support required for complex number literals (suffix 'i')
- Standard library support for complex numbers, vectors, and mathematical functions

### Build Flags and Optimization
- Basic: No special flags needed
- Recommended: `-O2 -std=c++14` for optimized performance with C++14 features
- The code compiles cleanly with no warnings on g++ 13.3.0

### Build Times and Timeouts
- NEVER CANCEL any build operation
- Basic build: ~0.4 seconds (set timeout to 30 seconds minimum)
- Optimized build: ~0.4 seconds (set timeout to 30 seconds minimum)
- There are no long-running builds in this project

## Program Behavior and Parameters

### Command Line Arguments
- No arguments: Uses standard parameters [-1, 0.5] x [2, 3], 20x20 grid, eps=1e-16, VECLENGTH=1900
- 4+ arguments: minRe, maxRe, minIm, maxIm (required)
- 6+ arguments: adds numRe, numIm (grid resolution)
- 7+ arguments: adds eps (epsilon for zero-detection)
- 8+ arguments: adds VECLENGTH (maximum iteration steps)

### Performance Characteristics
- Execution time scales roughly with grid size (numRe × numIm)
- 5x5 grid: ~0.01 seconds
- 10x10 grid: ~0.05 seconds
- 20x20 grid: ~0.18 seconds  
- 50x50 grid: ~1.1 seconds
- 100x100 grid: ~4.4 seconds
- NEVER CANCEL program execution - even largest typical grids complete quickly

### Output Format
- Program header and precision information
- Test calculation with complex result vector
- Main calculation displaying integer matrix representing convergence properties
- Values: positive integers (convergence order), 0 (filled/no cycle), -1 (NaN/divergent)

## Project Structure

### Key Files
- `main.cpp` - Primary C++ source file containing all implementation
- `README.md` - Project overview and description
- `LICENSE` - GPL-3.0 license file
- `Blendown.nb` - Mathematica notebook for visualization (ASCII text format)
- `ImportBigData.nb` - Mathematica notebook for data processing (ASCII text format)
- `main.exe` - Windows executable (PE32+ format, not runnable on Linux)
- `main.o` - Compiled object file

### Important Code Sections
- `safeCalcLongAtZ()` - Core function computing continued exponential at complex point z
- `calcMField()` - Main computation loop over complex plane grid
- `CycleDetectDLONG()` - Cycle detection algorithm
- `main()` - Entry point with parameter parsing and execution flow

## Common Tasks

### Testing Changes
- Always build and run after making changes: `g++ -O2 -std=c++14 -o main_optimized main.cpp && ./main_optimized`
- Test with small grid first: `./main_optimized -1 0.5 2 3 5 5`
- Test with standard grid: `./main_optimized -1 0.5 2 3 20 20`
- Verify output format remains consistent

### Debugging
- Compilation errors are typically related to C++ standard compliance
- Use `-std=c++14` for complex literal support
- Runtime errors are rare - the program is mathematically robust
- For performance issues, check grid size parameters

### Dependencies
- No external dependencies beyond standard C++ library
- Uses: iostream, iomanip, stdlib.h, complex, vector, limits, time.h
- All dependencies are part of standard g++ installation

## Verification Commands Summary
```bash
# Essential validation sequence:
g++ -O2 -std=c++14 -o main_optimized main.cpp  # Build (~0.4 sec)
./main_optimized                                # Test default (~0.18 sec)  
./main_optimized -1 0.5 2 3 10 10              # Test custom (~0.05 sec)
```

CRITICAL: NEVER CANCEL any operation in this repository - all builds and executions complete in seconds.