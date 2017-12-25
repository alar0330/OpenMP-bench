#include "../inc/multiplex.hpp"
#include "gtest/gtest.h"
#include "boost/numeric/ublas/matrix.hpp"
#include "boost/numeric/ublas/io.hpp"
#include <iostream>

/**------------------------------------------------------
*
*  GOOGLETEST Unit Testing
*
*  F90 Suites:
*    -> F90TestSuiteGEMM: misc test cases 
*             incl. BOOST/uBLAS cross-checks
*
*-------------------------------------------------------**/

TEST(F90TestSuiteGEMM, boostStaticAllGEMM) {
  
  using namespace boost::numeric::ublas;
  
  // Init
  const int N = 15;
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
  fgemm((double*)B, (double*)A, (double*)C, &N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  /*
  fgemm_omp(&A[0][0], &B[0][0], &C[0][0], N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  fgemmT(&A[0][0], &B[0][0], &C[0][0], N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  //  
  fgemmT_omp(&A[0][0], &B[0][0], &C[0][0], N);
  for(int i = 0; i < N; i++)
    for(int j = 0; j < N; j++)
      EXPECT_DOUBLE_EQ(UC(i,j), C[i][j]);
  */
}

TEST(F90TestSuiteGEMM, boostStaticFlattenMM) {
  
  using namespace boost::numeric::ublas;
  
  // ---> TODO
  
}