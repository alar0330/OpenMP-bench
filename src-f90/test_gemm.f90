!------------------------------------------
!  Benchmark for matrix multiplication
!      subroutines from multiplex module
!------------------------------------------

program test_gemm
use multiplex

implicit none
integer, parameter:: p=kind(0.d0) 
integer, parameter :: n = 512, benchmax = 5
integer :: i, j
real(p) :: dtime, omp_get_wtime
logical :: dbug = .false.
real(p) :: results(5, benchmax)
real(p) :: one = 1.0, zero = 0.0

real(p) :: A(n,n) = 0.0
real(p) :: B(n,n) = 0.0
real(p) :: C(n,n) = 0.0

do i = 1,n
    do j = 1,n
        A(i,j) = rand(0) * 100
        B(i,j) = rand(0) * 100
    end do
end do

!do i = 1,n
!    B(i,i) = 1.0
!end do

print '(A20, I4, A3, I4)', 'Dims of A are: ', size(A, 1), ' x ', size(A, 2)
print '(A20, I4, A3, I4)', 'Dims of B are: ', size(A, 1), ' x ', size(A, 2)

do i = 1, benchmax

    print '(1X, /, "---- Benchrun: ", I2)', i

    dtime = omp_get_wtime()
    call gemm(A,B,C,n)
    dtime = omp_get_wtime() - dtime
    
    results(1, i) = dtime
    print '("[gemm] Time = ",f6.3," seconds.")', dtime

    dtime = omp_get_wtime()
    call gemm_omp(A,B,C,n)
    dtime = omp_get_wtime() - dtime

    results(2, i) = dtime
    print '("[gemm_omp] Time = ",f6.3," seconds.")', dtime

    dtime = omp_get_wtime()
    call gemmT(A,B,C,n)
    dtime = omp_get_wtime() - dtime

    results(3, i) = dtime
    print '("[gemmT] Time = ",f6.3," seconds.")', dtime

    dtime = omp_get_wtime()
    call gemmT_omp(A,B,C,n)
    dtime = omp_get_wtime() - dtime

    results(4, i) = dtime
    print '("[gemmT_omp] Time = ",f6.3," seconds.")', dtime
    
    dtime = omp_get_wtime()
    call dgemm('N', 'N', n, n, n, one, A, n, B, n, zero, C, n)
    dtime = omp_get_wtime() - dtime

    results(5, i) = dtime
    print '("[DGEMM*] Time = ",f6.3," seconds.")', dtime
        
end do

print *,
print '(48("-"))',
print "(' RESULTS OF BENCHMARK (', I0 , ' x ', I0 , '):')", N, N
print '(48("-"))',

print *, '[gemm]      :', sum(results(1, :)) / benchmax, ' sec'
print *, '[gemm_omp]  :', sum(results(2, :)) / benchmax, ' sec'
print *, '[gemmT]     :', sum(results(3, :)) / benchmax, ' sec'
print *, '[gemmT_omp] :', sum(results(4, :)) / benchmax, ' sec'
print *, '[DGEMM*]    :', sum(results(5, :)) / benchmax, ' sec'
print *,
print *, '* Reference BLAS/Win32 (netlib.org):'
print *, '                        - single-threaded'
print *, '                        - not optimized for speed'

if (dbug) then

    print '(1X, /, A30)', 'Matrix A:'

    do i = 1, n
        print *, A(i,:)
    enddo

    print '(1X, /, A30)', 'Matrix B:'

    do i = 1, n
        print *, B(i,:)
    enddo

    print '(1X, /, A30)', 'Matrix C = A*B:'

    do i = 1, n
        print *, C(i,:)
    end do
    
end if

end program