// Fortran-bindings
extern "C" {
  void fgemm(double* A, double* B, double* C, const int* n);
  void fgemm_omp(double* A, double* B, double* C, const int* n);
  void fgemmT(double* A, double* B, double* C, const int* n);
  void fgemmT_omp(double* A, double* B, double* C, const int* n);
  void fdgemm_blas(double* A, double* B, double* C, const int* n);
}