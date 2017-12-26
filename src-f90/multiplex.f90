
!-----multiplex----------------------------------------------------
!
!  INFO:
!     Benchmark routines for matrix multiplication,
!     consider also testing agains BLAS and OpenBLAS.
!
!  C-BINDING:
!     use -D CBINDING flag to compile with C-bindings
!
!  CONTAINS:
!     - trpose(A, B, n)
!     - gemm(A, B, C, n)
!     - gemm_omp(A, B, C, n)
!     - gemmT(A, B, C, n)
!     - gemmT_omp(A, B, C, n)
!     - dgemm_blas(A, B, C, n)     
!
!---------------------------------------------------------------------

module multiplex

#ifdef CBINDING

use ISO_C_BINDING
#define cbind(NAME) bind(c, name=NAME)
#define DKIND C_DOUBLE
#define IKIND C_INT
  
#else

#define cbind(NAME)
#define DKIND kind(0.d0)
#define IKIND kind(0)

#endif

implicit none

integer, parameter, private :: kd = DKIND
integer, parameter, private :: ki = IKIND

contains
    subroutine trpose(A, B, n)
    
    !---------------------
    !  Matrix transpose
    !---------------------
    
        integer :: i,j
        integer(ki), intent(in) :: n
        real(kd), intent(out) :: B(n*n)
        real(kd), intent(in) :: A(n*n)
                
        do i = 1, n
            do j = 1, n
                B( (j-1) * n + i ) = A( (i-1) * n + j )
            end do
        end do
        
    end subroutine trpose
    
    subroutine gemm(A, B, C, n) cbind("fgemm")
    
    !-------------------------------------
    !  Matrix multiplication: C = A * B
    !-------------------------------------
    
        integer(ki), intent(in) :: n
        real(kd), intent(in)    :: A(n*n), B(n*n)
        real(kd), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(kd) :: dot
        
        do i = 1, n
            do j = 1, n
            
                dot = 0
                
                do k = 1, n
                    dot = dot + A( (k-1) * n + i ) * B( (j-1) * n + k )
                end do
                
                C((j-1)*n + i) = dot
            
            end do
        end do
        
    end subroutine gemm
    
    subroutine gemm_omp(A, B, C, n) cbind("fgemm_omp")
    
    !-------------------------------------
    !  Matrix multiplication: C = A * B
    !     with OpenMP
    !-------------------------------------
    
        integer(ki), intent(in) :: n
        real(kd), intent(in)    :: A(n*n), B(n*n)
        real(kd), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(kd) :: dot
        
!$OMP PARALLEL PRIVATE(i,j,k,dot) SHARED(A,B,C)
!$OMP DO

        do i = 1, n
            do j = 1, n
            
                dot = 0
                
                do k = 1, n
                    dot = dot + A( (k-1) * n + i ) * B( (j-1) * n + k )
                end do
                
                C((j-1)*n + i) = dot
            
            end do
        end do
        
!$OMP END DO
!$OMP END PARALLEL        
        
    end subroutine gemm_omp
    
    
    subroutine gemmT(A, B, C, n) cbind("fgemmT")
    
    !---------------------------------------------
    !  Matrix multiplication: C = A * B
    !     using A-transpose to exploit Fortran's
    !     column-major storage for arrays
    !---------------------------------------------
    
        integer(ki), intent(in) :: n
        real(kd), intent(in)    :: A(n*n), B(n*n)
        real(kd), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(kd) :: dot
        !real, allocatable :: AT(:)
        real(kd) :: AT(n*n)
        
        !allocate(AT(n*n))
        
        call trpose(A, AT, n)
                
        do i = 1, n
            do j = 1, n
            
                dot = 0
                
                do k = 1, n
                    dot = dot + AT( (i-1) * n + k ) * B( (j-1) * n + k )
                end do
                
                C( (j-1)*n + i ) = dot
            
            end do
        end do
        
        !deallocate(AT)
        
    end subroutine gemmT
    
    subroutine gemmT_omp(A, B, C, n) cbind("fgemmT_omp")
     
    !---------------------------------------------
    !  Matrix multiplication: C = A * B
    !     using A-transpose to exploit Fortran's
    !     column-major storage for arrays
    !     with OpenMP
    !---------------------------------------------
    
        integer(ki), intent(in) :: n
        real(kd), intent(in)    :: A(n*n), B(n*n)
        real(kd), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(kd) :: dot
        !real, allocatable :: AT(:)
        real(kd) :: AT(n*n)
        
        !allocate(AT(n*n))
        
        call trpose(A, AT, n)
        
!$OMP PARALLEL PRIVATE(i,j,k,dot) SHARED(AT,B,C)
!$OMP DO
                
        do i = 1, n
            do j = 1, n
            
                dot = 0
                
                do k = 1, n
                    dot = dot + AT( (i-1) * n + k ) * B( (j-1) * n + k )
                end do
                
                C( (j-1)*n + i ) = dot
            
            end do
        end do
        
!$OMP END DO
!$OMP END PARALLEL 
        
        !deallocate(AT)
        
    end subroutine gemmT_omp
    
    subroutine dgemm_blas(A, B, C, n) cbind("fdgemm_blas")
    
    !-------------------------------------
    !  Matrix multiplication: C = A * B
    !     wrapper for the DGEMM from BLAS
    !-------------------------------------
    
        integer(ki), intent(in) :: n
        real(kd), intent(in)  :: A(n*n), B(n*n)
        real(kd), intent(out) :: C(n*n)
        
        integer, parameter:: dp=kind(0.d0) 
        real(dp) :: one = 1.0, zero = 0.0
        
        call dgemm('N', 'N', n, n, n, one, A, n, B, n, zero, C, n)
        
    end subroutine dgemm_blas
        
end module multiplex
