#include <stdio.h>
#include <omp.h>
#include <array>
#include <numeric>
#include "../inc/laroff.hpp"
#include "../inc/multiplex.hpp"

using std::array;
using std::accumulate;

int main() {
  
    // List of tests:
    const int MAXTESTS = 9;
    const char* stest[MAXTESTS] = {
      "[C++/gemm]       ",
      "[C++/gemm_omp]   ",
      "[C++/gemmT]      ",
      "[C++/gemmT_omp]  ",
      "[F90/gemm]       ",
      "[F90/gemm_omp]   ",
      "[F90/gemmT]      ",
      "[F90/gemmT_omp]  ",
      "[F90/dgemm_BLAS] "
    };
    
    // Benchmark settings:
    using Real = double;
    const int N_THREADS = 4;
    const int N = 512, REP = 5;
    
    double dtime = 0.0;
    array<array<double, REP>, MAXTESTS> res;
    
    Real *A = new Real[N*N];
    Real *B = new Real[N*N];
    Real *C = new Real[N*N];
    
    for(int i=0; i<N*N; i++) {
      A[i] = rand()/double(RAND_MAX); 
      B[i] = 0.95 * A[i];
    }
    
    omp_set_num_threads(N_THREADS); 
    
    for(int j = 0; j < REP; j++) {
      
      int s = 0;
      
      printf("\n---- Benchrun: %d\n", j+1);

      // Native C++ calls
      dtime = omp_get_wtime();
      gemm<Real>(A,B,C, N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      dtime = omp_get_wtime();
      gemm_omp<Real>(A,B,C, N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;

      dtime = omp_get_wtime();
      gemmT<Real>(A,B,C, N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;

      dtime = omp_get_wtime();
      gemmT_omp<Real>(A,B,C, N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      // Calls to Fortran subroutines:
      //   ( notice reverse matrix-order 
      //     due to Fortran memory patterns )
      dtime = omp_get_wtime();
      fgemm(B,A,C,&N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      dtime = omp_get_wtime();
      fgemm_omp(B,A,C,&N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      dtime = omp_get_wtime();
      fgemmT(B,A,C,&N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      dtime = omp_get_wtime();
      fgemmT_omp(B,A,C,&N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
      
      dtime = omp_get_wtime();
      fdgemm_blas(B,A,C,&N);
      dtime = omp_get_wtime() - dtime;
      printf("%s: %.5f sec\n", stest[s], dtime);
      res[s++][j] = dtime;
 
    }
    
    printf("\n\n---------------------------------------\n");
    printf(" RESULTS OF BENCHMARK ( %d x %d ):\n", N, N);
    printf("---------------------------------------\n");
    for(int s = 0; s < MAXTESTS; s++) {
      printf("%s: %.5f sec\n", stest[s], accumulate(res[s].begin(), res[s].end(), double(0.0)) / REP);
    }

    printf("\nINFO:\n");
    #pragma omp parallel
    #pragma omp single
    printf(" - NUM_THREADS = %d\n", omp_get_num_threads());
    printf(" - Reference BLAS used\n");
    printf("---------------------------------------\n");
    
    delete[] A;
    delete[] B;
    delete[] C;

    return 0;
}