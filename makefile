# OpenMP-bench: makefile

src90 = src-f90
libdir = lib
lapack = $(libdir)/libblas.lib $(libdir)/liblapack.lib

make0:
	gfortran -o openmp_bench.exe -Wall -pedantic -O0 -fopenmp \
	-L$(libdir)/ -lblas \
	$(src90)/multiplex.f90 $(src90)/test_gemm.f90 $(lapack)
run0:
	gfortran -o openmp_bench.exe -Wall -pedantic -O0 -fopenmp \
	$(src90)/multiplex.f90 $(src90)/test_gemm.f90 $(lapack) && openmp_bench.exe
clean:
	del multiplex.mod openmp_bench.exe
# End of the makefile