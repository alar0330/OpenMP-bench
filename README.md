# OpenMP-bench

OpenMP Benchmarks of matrix multiplication for Fortran.

TODO: also consider BLAS and OpenBLAS

Setup:
```
>> setx NUM_THREADS(4)
>> gfortran -Wall -fopenmp -O0 -o test_gemm.exe multiplex.f90 test_gemm.f90
```

Benchmark:
```
------------------------------------------------
 RESULTS OF BENCHMARK (256 x 256):
------------------------------------------------
 [gemm]      :  0.184000015      sec
 [gemm_omp]  :  0.120599985      sec
 [gemmT]     :  0.155200019      sec
 [gemmT_omp] :  0.104899988      sec
 
 
------------------------------------------------
 RESULTS OF BENCHMARK (512 x 512):
------------------------------------------------
 [gemm]      :  1.61109996      sec
 [gemm_omp]  :  0.971400023     sec
 [gemmT]     :  1.17280006      sec
 [gemmT_omp] :  0.816900015     sec
 
 
------------------------------------------------
 RESULTS OF BENCHMARK (1024 x 1024):
------------------------------------------------
 [gemm]      :   23.4009991      sec
 [gemm_omp]  :   12.2428999      sec
 [gemmT]     :   9.52110004      sec
 [gemmT_omp] :   6.55910015      sec
 
```

----------

Setup:
```
>> setx NUM_THREADS(4)
>> gfortran -Wall -fopenmp -O3 -o test_gemm.exe multiplex.f90 test_gemm.f90
```

Benchmark:
```
------------------------------------------------
 RESULTS OF BENCHMARK (256 x 256):
------------------------------------------------
 [gemm]      :  0.184000015      sec
 [gemm_omp]  :  0.120599985      sec
 [gemmT]     :  0.155200019      sec
 [gemmT_omp] :  0.104899988      sec
 
 
------------------------------------------------
 RESULTS OF BENCHMARK (512 x 512):
------------------------------------------------
 [gemm]      :  0.41679997881874442       sec
 [gemm_omp]  :  0.23890002613188699       sec
 [gemmT]     :  0.20139996585203335       sec
 [gemmT_omp] :  0.11480001966701821       sec
 
 
------------------------------------------------
 RESULTS OF BENCHMARK (1024 x 1024):
------------------------------------------------
 [gemm]      :   12.626500004192348       sec
 [gemm_omp]  :   7.6188000392750839       sec
 [gemmT]     :   1.7438000003807246       sec
 [gemmT_omp] :  0.93040000190958383       sec
```
