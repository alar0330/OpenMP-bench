# OpenMP-bench: makefile
#

# Googletest path and lib
GTEST_PATH = ${GOOGLE_TEST_PATH}
GTEST_LIB = gtest

# Compiler settings
F90 = gfortran
CXX = g++
WFLAGS = -Wall -pedantic
OMPFLAG = -fopenmp
OPTFLAG = -O3
GTESTFLAG = -L$(GTEST_PATH) -l$(GTEST_LIB) -lpthread

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
	$(CXX) $(WFLAGS) -o bench_omp.exe $^ \
	$(OMPFLAG) $(lapack) -lgfortran
	
$(outdir)/bench_omp.o: $(src++)/bench_omp.cpp $(inc++)/laroff.hpp $(inc++)/multiplex.hpp 
	$(CXX) $(OPTFLAG) -o $@ -c $< $(OMPFLAG)
	
$(outdir)/multiplex.o: $(src90)/multiplex.f90
	$(F90) $(OPTFLAG) -o $@ -c $< $(OMPFLAG) -cpp -DCBINDING
	
# Compilation: Unit Tests	
test: unit
	test.exe
	
unit: $(outdir)/test_main.o $(outdir)/multiplex.o
	$(CXX) -o test.exe $^ $(GTESTFLAG) $(OMPFLAG) $(lapack) -lgfortran
	
$(outdir)/test_main.o: $(testdir)/test_main.cpp
	$(CXX) -c $< -o $@ $(WFLAGS) $(OMPFLAG)
	
clean:
	del *.exe *.mod $(outdir)\*.o
