#include "../inc/laroff.hpp"
#include "gtest/gtest.h"
#include "boost/numeric/ublas/matrix.hpp"
#include "boost/numeric/ublas/io.hpp"
#include <iostream>

/**------------------------------------------------------
*
*  GOOGLETEST Unit Testing
*
*  C++ Suites:
*    -> CppTestSuiteTranspose: playing with gtest
*    -> CppTestSuiteGEMM: misc test cases 
*           incl. BOOST/uBLAS cross-checks
*
*-------------------------------------------------------**/

TEST(CppTestSuiteTranspose, doubleOneDynamic) {
  
  // Init
  double* A = new double[1*1] {100};
  double* AT = new double[1*1] {};
  
  // Test
  trpose<double>(A, AT, 1);
  EXPECT_DOUBLE_EQ(100, AT[0]);
  
  //Clean up
  delete[] A; delete[] AT;
}

TEST(CppTestSuiteTranspose, doubleNineDynamic) {
  
  // Init
  const int N = 3;
  double* B = new double[N*N] { 100, 200, 300, 400, 500, 600, 700, 800, 900 };
  double* BT = new double[N*N] {};
  
  // Test
  trpose<double>(B, BT, N);
  const double BX[9] = {100, 400, 700, 200, 500, 800, 300, 600, 900};
  for(int i = 0; i < 9; i++) {
    EXPECT_DOUBLE_EQ(BX[i], BT[i]);
  }
  
  // Clean up
  delete[] B; delete[] BT;
}

TEST(CppTestSuiteTranspose, floatNineDynamic) {
  
  // Init
  const int N = 3;
  float* C = new float[N*N] { 10, 20, 30, 40, 50, 60, 70, 80, 90 };
  float* CT = new float[N*N] {};
  
  // Test
  trpose<float>(C, CT, N);
  const float CX[3] = {10, 50, 90};
  for(int i = 0; i < 3; i++) {
    EXPECT_FLOAT_EQ(CX[i], CT[i*N + i]);
  }
   
  // Clean up
  delete[] C; delete[] CT;
}

TEST(CppTestSuiteTranspose, float2KDynamic) {
  
  // Init
  const int N = 2000;
  float* D = new float[N*N]; 
  for(int i = 0; i<N; i++)
    for(int j = 0; j<N; j++)      
      D[i*N + j] = (i == j) ? 66.66f : 33.33f;

  float* DT = new float[N*N] {};
  
  // Test
  trpose<float>(D, DT, N);
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      if(i == j)
        EXPECT_FLOAT_EQ(66.66, DT[i*N + j]);
      else
        EXPECT_FLOAT_EQ(33.33, DT[i*N + j]);
    }
  }
   
  // Clean up
  delete[] D; delete[] DT;
}

TEST(CppTestSuiteTranspose, double2DDynamic) {
  
  // Init
  const int N = 2;
  double E[N][N] = {{1, 2}, {3, 4}};
  double ET[N][N];
  
  // Test
  trpose<double>(&E[0][0], &ET[0][0], N);
  {
    EXPECT_DOUBLE_EQ(1.0, ET[0][0]);
    EXPECT_DOUBLE_EQ(3.0, ET[0][1]);
    EXPECT_DOUBLE_EQ(2.0, ET[1][0]);
    EXPECT_DOUBLE_EQ(4.0, ET[1][1]);
  }
}

TEST(CppTestSuiteTranspose, boostDynamic) {
  
  using namespace boost::numeric::ublas;
  
  // Init
  const int N = 100;
  double F[N][N] = {};
  double FT[N][N];
  matrix<double> M(N,N);
  matrix<double> MT(N,N);
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      F[i][j] = rand()/double(RAND_MAX);
      M(i, j) = F[i][j];
      //std::cout << F[i][j] << " ";
    }
  }
  
  // Test
  trpose<double>(&F[0][0], &FT[0][0], N);
  MT = trans(M);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(MT(i,j), FT[i][j]);
}

TEST(CppTestSuiteGEMM, boostStaticAllGEMM) {
  
  using namespace boost::numeric::ublas;
  
  // Init
  const int N = 10;
  double A[N][N], B[N][N], C[N][N];
  matrix<double> UA(N,N), UB(N,N), UC(N,N);
  //
  for(int i = 0; i < N; i++) {
    for(int j = 0; j < N; j++) {
      A[i][j] = rand()/double(RAND_MAX);
      B[i][j] = A[i][j] + 10 * i/double(1+j);
      UA(i, j) = A[i][j];
      UB(i, j) = B[i][j];
    }
  }
  
  // Tests
  UC = prod(UA, UB);
  //
  gemm<double>((double*)A, (double*)B, (double*)C, N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  gemm_omp<double>((double*)A, (double*)B, (double*)C, N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  gemmT<double>((double*)A, (double*)B, (double*)C, N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  gemmT_omp<double>((double*)A, (double*)B, (double*)C, N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
}