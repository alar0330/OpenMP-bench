# OpenMP-bench: makefile
#

# Googletest path and lib
GTEST_PATH = ${GOOGLE_TEST_PATH}
GTEST_LIB = gtest

# Compiler settings
F90 = gfortran
CXX = g++
WFLAGS = -Wall -pedantic
OMPFLAGS = -fopenmp
OPTFLAGS = -O3
GTESTFLAGS = -L$(GTEST_PATH) -l$(GTEST_LIB) -lpthread

# Profiling Setting
PROFLAGS =

# Directory settings
src90 = src-f90
src++ = src-cpp
inc++ = inc
libdir = lib
outdir = out
testdir = test

# LAPACK/BLAS settings 
lapack = $(libdir)/libblas.lib -L$(libdir)/ -lblas

# Phonies
.PHONY = test unit run bin clean

# Compilation: Benchmarks
run: bin
	bench_omp.exe
	
bin: $(outdir)/bench_omp.o $(outdir)/multiplex.o
	$(CXX) -o bench_omp.exe $^ $(OMPFLAGS) $(lapack) $(PROFLAGS) -lgfortran
	
$(outdir)/bench_omp.o: $(src++)/bench_omp.cpp $(inc++)/laroff.hpp $(inc++)/multiplex.hpp 
	$(CXX) $(OPTFLAGS) $(WFLAGS) -o $@ -c $< $(OMPFLAGS) $(PROFLAGS)
	
$(outdir)/multiplex.o: $(src90)/multiplex.f90
	$(F90) $(OPTFLAGS) $(WFLAGS) -o $@ -c $< $(OMPFLAGS) $(PROFLAGS) -cpp -DCBINDING
	
# Compilation: Unit Tests	
test: unit
	test.exe
	
unit: $(outdir)/test_main.o $(outdir)/multiplex.o
	$(CXX) -o test.exe $^ $(GTESTFLAGS) $(OMPFLAGS) $(lapack) -lgfortran
	
$(outdir)/test_main.o: $(testdir)/test_main.cpp $(testdir)/test_cpp.cpp $(testdir)/test_f90.cpp
	$(CXX) -c $< -o $@ $(WFLAGS) $(OMPFLAGS)

# Clean up
clean:
	del *.exe *.mod $(outdir)\*.o *.out
