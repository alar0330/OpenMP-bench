# OpenMP-bench: makefile
#

F90 = gfortran
CXX = g++
WFLAGS = -Wall -pedantic
OMPFLAG = -fopenmp
OPTFLAG = -O3

src90 = src-f90
src++ = src-cpp
inc++ = inc
libdir = lib
outdir = out
lapack = $(libdir)/libblas.lib $(libdir)/liblapack.lib

run: bin
	cfort.exe
	
bin: $(outdir)/bench_omp.o $(outdir)/multiplex.o
	$(CXX) $(WFLAGS) -o cfort.exe $(outdir)/bench_omp.o $(outdir)/multiplex.o \
	$(OMPFLAG) $(lapack) -L$(libdir)/ -lblas -lgfortran
	
$(outdir)/bench_omp.o: $(src++)/bench_omp.cpp $(inc++)/laroff.hpp 
	$(CXX) $(OPTFLAG) -o $@ -c $< $(OMPFLAG)
	
$(outdir)/multiplex.o: $(src90)/multiplex.f90
	$(F90) $(OPTFLAG) -o $@ -c $< $(OMPFLAG) -cpp -DCBINDING
	
clean:
#	del $(TODO)