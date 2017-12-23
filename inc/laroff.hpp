/**----LAROFF-------------------------------------------
*
*  INFO:
*     Benchmark routines for matrix multiplication,
*              with OpenMP and cache-friendly methods
*
*  CONTAINS:
*     - trpose<T>(T A, T B, n)
*     - gemm<T>(T A, T B, T C, n)
*     - gemm_omp<T>(T A, T B, T C, n)
*     - gemmT<T>(T A, T B, T C, n)
*     - gemmT_omp<T>(T A, T B, T C, n)
*     
*---------------------------------------------------------**/

#pragma once

template <typename T>
void trpose(T *A, T *B, int n) {
    for(int i=0; i<n; i++) {
        for(int j=0; j<n; j++) {
            B[j*n+i] = A[i*n+j];
        }
    }
}

template <typename T>
void gemm(T *A, T *B, T *C, int n) 
{   
    for (int i = 0; i < n; i++) { 
        for (int j = 0; j < n; j++) {
            T dot  = 0;
            for (int k = 0; k < n; k++) {
                dot += A[i*n+k]*B[k*n+j];
            } 
            C[i*n+j ] = dot;
        }
    }
}

template <typename T>
void gemm_omp(T *A, T *B, T *C, int n) 
{   
    #pragma omp parallel default(none) shared(A,B,C,n)
    {
        #pragma omp for
        for (int i = 0; i < n; i++) { 
            for (int j = 0; j < n; j++) {
                T dot  = 0;
                for (int k = 0; k < n; k++) {
                    dot += A[i*n+k]*B[k*n+j];
                } 
                C[i*n+j ] = dot;
            }
        }
    }
}

template <typename T>
void gemmT(T *A, T *B, T *C, int n) 
{   
    int i, j, k;
    T *B2 = new T[n*n];

    trpose<T>(B,B2, n);
    for (i = 0; i < n; i++) { 
        for (j = 0; j < n; j++) {
            T dot  = 0;
            for (k = 0; k < n; k++) {
                dot += A[i*n+k]*B2[j*n+k];
            } 
            C[i*n+j ] = dot;
        }
    }
    delete[] B2;
}

template <typename T>
void gemmT_omp(T *A, T *B, T *C, int n) 
{   
    T *B2 = new T[n*n];

    trpose<T>(B,B2, n);
    #pragma omp parallel default(none) shared(A,B2,C,n)
    {
        #pragma omp for
        for (int i = 0; i < n; i++) { 
            for (int j = 0; j < n; j++) {
                double dot  = 0;
                for (int k = 0; k < n; k++) {
                    dot += A[i*n+k]*B2[j*n+k];
                } 
                C[i*n+j ] = dot;
            }
        }

    }
    delete[] B2;
}