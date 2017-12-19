# OpenMP-bench

OpenMP Benchmarks of matrix multiplication for Fortran.

TODO: also consider BLAS and OpenBLAS

Results (4 threads):

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
