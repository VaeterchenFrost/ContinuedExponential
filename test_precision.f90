program test_precision
    use iso_fortran_env, only: real64, real128
    implicit none
    
    integer, parameter :: wp = merge(real128, real64, real128 > 0)
    
    write(*,*) "Testing precision selection:"
    write(*,*) "real64 kind:", real64
    write(*,*) "real128 kind:", real128
    write(*,*) "Selected working precision (wp):", wp
    
    if (wp == real128) then
        write(*,*) "Using real128 (quadruple precision)"
    else
        write(*,*) "Using real64 (double precision) - real128 not available"
    end if
    
    write(*,*) "Precision (decimal digits):", precision(1.0_wp)
    write(*,*) "Range (orders of magnitude):", range(1.0_wp)
end program test_precision