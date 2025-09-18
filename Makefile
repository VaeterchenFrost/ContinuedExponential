# Makefile for Continued Exponential Calculator
# Fortran 2023 implementation

# Compiler settings
FC = gfortran
FFLAGS = -std=f2018 -Wall -Wextra -pedantic -fcheck=all -g -O2
FFLAGS_RELEASE = -std=f2018 -O3 -march=native

# Program names
FORTRAN_PROG = continued_exponential
CPP_PROG = main_test

# Source files
FORTRAN_SRC = continued_exponential.f90
CPP_SRC = main.cpp

# Object files
FORTRAN_OBJ = $(FORTRAN_SRC:.f90=.o)

# Default target
all: $(FORTRAN_PROG)

# Build Fortran program
$(FORTRAN_PROG): $(FORTRAN_OBJ)
	$(FC) $(FFLAGS) -o $@ $^

# Compile Fortran source
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

# Build C++ reference for comparison
cpp: $(CPP_PROG)

$(CPP_PROG): $(CPP_SRC)
	g++ -std=c++11 -fext-numeric-literals -O2 -o $@ $<

# Release build
release: FFLAGS = $(FFLAGS_RELEASE)
release: clean $(FORTRAN_PROG)

# Test both implementations
test: $(FORTRAN_PROG) $(CPP_PROG)
	@echo "=== Testing Fortran implementation ==="
	./$(FORTRAN_PROG)
	@echo ""
	@echo "=== Testing C++ reference ==="
	./$(CPP_PROG)

# Run comprehensive test suite
test-suite: $(FORTRAN_PROG)
	@echo "=== Running comprehensive test suite ==="
	./run_tests.sh

# Compare outputs (basic comparison)
compare: $(FORTRAN_PROG) $(CPP_PROG)
	@echo "=== Comparing Fortran vs C++ outputs ==="
	./$(FORTRAN_PROG) > fortran_output.txt 2>&1
	./$(CPP_PROG) > cpp_output.txt 2>&1
	@echo "Output files generated: fortran_output.txt, cpp_output.txt"
	@echo "Manual comparison recommended due to formatting differences"

# Clean build artifacts
clean:
	rm -f *.o *.mod $(FORTRAN_PROG) $(CPP_PROG)
	rm -f fortran_output.txt cpp_output.txt
	rm -f test*_output.txt temp_*.txt

# Install dependencies (placeholder)
deps:
	@echo "Fortran compiler (gfortran) and standard libraries required"
	@echo "On Ubuntu/Debian: sudo apt-get install gfortran"

# Help
help:
	@echo "Available targets:"
	@echo "  all      - Build Fortran program (default)"
	@echo "  cpp      - Build C++ reference program"
	@echo "  release  - Build optimized version"
	@echo "  test     - Run both implementations"
	@echo "  test-suite - Run comprehensive test suite with validation"
	@echo "  compare  - Compare outputs of both implementations"
	@echo "  clean    - Remove build artifacts"
	@echo "  deps     - Show dependency information"
	@echo "  help     - Show this help"

.PHONY: all cpp release test test-suite compare clean deps help