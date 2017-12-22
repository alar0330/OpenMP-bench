
!-----multiplex----------------------------------------------------
!
!  INFO:
!     Benchmark routines for matrix multiplication,
!     consider also testing agains BLAS and OpenBLAS.
!
!  CONTAINS:
!     - trpose(A, B, n)
!     - gemm(A, B, C, n)
!     - gemm_omp(A, B, C, n)
!     - gemmT(A, B, C, n)
!     - gemmT_omp(A, B, C, n)
!     
!
!---------------------------------------------------------------------

module multiplex
implicit none

integer, parameter, private :: d=kind(0.d0) 

contains
    subroutine trpose(A, B, n)
    
    !---------------------
    !  Matrix transpose
    !---------------------
    
        integer :: i,j
        integer, intent(in) :: n
        real(d), intent(out) :: B(n*n)
        real(d), intent(in) :: A(n*n)
                
        do i = 1, n
            do j = 1, n
                B( (i-1) * n + j ) = A( (j-1) * n + i )
            end do
        end do
        
    end subroutine trpose
    
    subroutine gemm(A, B, C, n)
    
    !-------------------------------------
    !  Matrix multiplication: C = A * B
    !-------------------------------------
    
        integer, intent(in) :: n
        real(d), intent(in)    :: A(n*n), B(n*n)
        real(d), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(d) :: dot
        
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
    
    subroutine gemm_omp(A, B, C, n)
    
    !-------------------------------------
    !  Matrix multiplication: C = A * B
    !     with OpenMP
    !-------------------------------------
    
        integer, intent(in) :: n
        real(d), intent(in)    :: A(n*n), B(n*n)
        real(d), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(d) :: dot
        
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
    
    
    subroutine gemmT(A, B, C, n)
    
    !---------------------------------------------
    !  Matrix multiplication: C = A * B
    !     using A-transpose to exploit Fortran's
    !     column-major storage for arrays
    !---------------------------------------------
    
        integer, intent(in) :: n
        real(d), intent(in)    :: A(n*n), B(n*n)
        real(d), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(d) :: dot
        !real, allocatable :: AT(:)
        real(d) :: AT(n*n)
        
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
    
    subroutine gemmT_omp(A, B, C, n)
    
    !---------------------------------------------
    !  Matrix multiplication: C = A * B
    !     using A-transpose to exploit Fortran's
    !     column-major storage for arrays
    !     with OpenMP
    !---------------------------------------------
    
        integer, intent(in) :: n
        real(d), intent(in)    :: A(n*n), B(n*n)
        real(d), intent(out)   :: C(n*n)
        integer :: i, j, k
        real(d) :: dot
        !real, allocatable :: AT(:)
        real(d) :: AT(n*n)
        
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
        
end module multiplex

