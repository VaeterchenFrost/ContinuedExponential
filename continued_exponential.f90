!> @brief Fortran 2023 Implementation of Continued Exponential Calculator
!> @author Martin Roebke (original C++ version), Fortran translation 2024
!> @details Side project inspired by Mathematical Physics 05 - Carl Bender
!>          https://www.youtube.com/watch?v=LMw0NZDM5B4
!>
!>          Implementation for computing convergence-criteria of continued exponentials.
!>          The result is a human-readable output of integer values approximating 
!>          the number of accumulation points in a user defined rectangle with 
!>          evenly distributed selectable resolution.
!>
!>          Formula: F(n) = exp(z * F(n-1))
!>          
!>          Pretty cool points:
!>            -2.5 + 1 I  
!>            -1.3333333 + 2 I

program continued_exponential
    use iso_fortran_env, only: real64, real128, int32, output_unit, error_unit
    use ieee_arithmetic, only: ieee_is_nan
    implicit none
    
    ! Precision parameters - using real128 for high precision like C++ long double
    ! Fall back to real64 if real128 is not available
    integer, parameter :: wp = merge(real128, real64, real128 > 0)
    integer, parameter :: ip = int32
    
    ! Program constants
    real(wp), parameter :: safe_zero = 1.0e-18_wp
    real(wp), parameter :: default_eps = 1.0e-16_wp
    integer(ip), parameter :: default_max_cycle = 255
    
    ! Main program variables
    complex(wp) :: z1
    complex(wp), allocatable :: test_vec(:)
    integer(ip) :: cycle_result
    integer :: alloc_stat
    
    ! Parameters for field calculation
    real(wp) :: min_re, max_re, min_im, max_im
    real(wp) :: eps
    integer(ip) :: num_re, num_im, vec_length
    complex(wp), allocatable :: impl_vec(:)
    
    ! Command line processing
    integer :: argc, stat
    character(len=32) :: arg_buffer
    
    write(output_unit, '(A)') "-------- Program to calculate Continued Exponential --------"
    write(output_unit, '(A)') "F(n) = exp(z * F(n-1))"
    if (wp == real128) then
        write(output_unit, '(A)') "with dtype: real128 (equivalent to C++ long double)"
    else
        write(output_unit, '(A)') "with dtype: real64 (real128 not available)"
    end if
    write(output_unit, '(A)') ""
    
    call print_precision_info()
    call print_limits_info()
    
    ! Test Area
    write(output_unit, '(A)') ""
    write(output_unit, '(A)') "TestArea: ================================="
    
    z1 = cmplx(-2.475409836065573771_wp, 4.175609756097561132_wp, kind=wp)
    allocate(test_vec(10), stat=alloc_stat)
    if (alloc_stat /= 0) error stop "Failed to allocate test vector"
    
    cycle_result = safe_calc_long_at_z(z1, test_vec)
    write(output_unit, '(A,I0)', advance='no') "Ergebnis Berechnung: ", cycle_result
    call print_vector(test_vec)
    
    deallocate(test_vec)
    
    ! Main Implementation
    write(output_unit, '(A)') ""
    write(output_unit, '(A)') ""
    write(output_unit, '(A)') "Proceeding with specific calculation..."
    
    ! Default parameters
    min_re = -1.0_wp
    max_re = 0.5_wp
    min_im = 2.0_wp
    max_im = 3.0_wp
    num_re = 20
    num_im = 20
    eps = default_eps
    vec_length = 1900
    
    ! Parse command line arguments
    argc = command_argument_count()
    
    if (argc <= 4) then
        if (argc > 1) then
            write(output_unit, '(A)') ""
            write(output_unit, '(A)') "Error parsing parameters: Using STANDARD PARAMETERS"
        end if
        
        write(output_unit, '(A)') ""
        write(output_unit, '(A)') "Input of parameters via arguments:"
        write(output_unit, '(A,F0.3,A,F0.3,A,F0.3,A,F0.3,A,I0,A,I0,A,ES12.5,A,I0,A)') &
            "arg: [min Real=", min_re, ", maxReal=", max_re, &
            ", minImaginary=", min_im, ", maxImaginary=", max_im, &
            "], [ticks on real-axis=", num_re, ", ticks on imag-axis=", num_im, &
            "], [epsilon for zero-detection=", eps, &
            "], [maximum steps for computation at every point=", vec_length, "]"
    end if
    
    if (argc > 4) then
        call get_command_argument(1, arg_buffer, status=stat)
        if (stat == 0) read(arg_buffer, *, iostat=stat) min_re
        call get_command_argument(2, arg_buffer, status=stat)
        if (stat == 0) read(arg_buffer, *, iostat=stat) max_re
        call get_command_argument(3, arg_buffer, status=stat)
        if (stat == 0) read(arg_buffer, *, iostat=stat) min_im
        call get_command_argument(4, arg_buffer, status=stat)
        if (stat == 0) read(arg_buffer, *, iostat=stat) max_im
        
        if (argc > 6) then
            call get_command_argument(5, arg_buffer, status=stat)
            if (stat == 0) read(arg_buffer, *, iostat=stat) num_re
            call get_command_argument(6, arg_buffer, status=stat)
            if (stat == 0) read(arg_buffer, *, iostat=stat) num_im
            
            if (argc > 7) then
                call get_command_argument(7, arg_buffer, status=stat)
                if (stat == 0) read(arg_buffer, *, iostat=stat) eps
            end if
            
            if (argc > 8) then
                call get_command_argument(8, arg_buffer, status=stat)
                if (stat == 0) read(arg_buffer, *, iostat=stat) vec_length
            end if
        end if
        
        write(output_unit, '(A,ES12.5,A,I0,A,I0,A,I0)') &
            "using eps= ", eps, ", ticks on real/imag axis: (", num_re, ", ", num_im, &
            "), using vector of length ", vec_length
    end if
    
    allocate(impl_vec(vec_length), stat=alloc_stat)
    if (alloc_stat /= 0) error stop "Failed to allocate implementation vector"
    
    call calc_m_field(min_re, max_re, min_im, max_im, num_re, num_im, impl_vec, eps)
    
    deallocate(impl_vec)

contains

    !> @brief Calculate vector at complex point z
    !> @param[in] z Complex point
    !> @param[inout] vec Vector to fill with results
    subroutine calc_vector_at_z(z, vec)
        complex(wp), intent(in) :: z
        complex(wp), intent(inout) :: vec(:)
        
        complex(wp) :: result
        integer :: i
        
        result = cmplx(1.0_wp, 0.0_wp, kind=wp)
        
        do i = 1, size(vec)
            result = exp(z * result)
            vec(i) = result
        end do
    end subroutine calc_vector_at_z

    !> @brief Safe calculation at complex point z with error detection
    !> @param[in] z Complex point
    !> @param[inout] vec Vector to fill with results
    !> @return Error code: 0=success, positive=found cycle, negative=NaN detected
    function safe_calc_long_at_z(z, vec) result(error_code)
        complex(wp), intent(in) :: z
        complex(wp), intent(inout) :: vec(:)
        integer(ip) :: error_code
        
        complex(wp) :: func
        integer :: n, i
        
        func = cmplx(1.0_wp, 0.0_wp, kind=wp)
        n = 1
        
        do i = 1, size(vec)
            n = n + 1
            func = exp(z * func)
            vec(i) = func
            
            ! Check for NaN
            if (ieee_is_nan(real(func)) .or. ieee_is_nan(aimag(func))) then
                error_code = -1
                return
            end if
            
            ! Check for near-zero (cycle detection)
            if (abs(func) < safe_zero) then
                error_code = n
                return
            end if
        end do
        
        error_code = 0
    end function safe_calc_long_at_z

    !> @brief Detect cycles in the computed vector
    !> @param[in] vec Vector to analyze
    !> @param[in] eps Tolerance for cycle detection
    !> @param[in] max_check Maximum number of elements to check backwards
    !> @return Cycle length (0 if no cycle found)
    function cycle_detect_long(vec, eps, max_check) result(cycle_length)
        complex(wp), intent(in) :: vec(:)
        real(wp), intent(in), optional :: eps
        integer(ip), intent(in), optional :: max_check
        integer(ip) :: cycle_length
        
        real(wp) :: tolerance
        integer(ip) :: max_iter, last_idx, i
        complex(wp) :: last_elem, current_elem
        
        tolerance = default_eps
        if (present(eps)) tolerance = eps
        
        max_iter = default_max_cycle
        if (present(max_check)) max_iter = max_check
        
        cycle_length = 0
        last_idx = size(vec)
        last_elem = vec(last_idx)
        
        do i = last_idx - 1, max(1, last_idx - max_iter), -1
            cycle_length = cycle_length + 1
            current_elem = vec(i)
            
            if (abs(current_elem - last_elem) < tolerance) then
                return
            end if
        end do
        
        cycle_length = 0
    end function cycle_detect_long

    !> @brief Print value with optional z coordinate
    !> @param[in] value Value to print
    !> @param[in] z Complex coordinate (optional)
    !> @param[in] print_z Whether to print z coordinate
    subroutine print_value_at_z(value, z, print_z)
        integer(ip), intent(in) :: value
        complex(wp), intent(in), optional :: z
        logical, intent(in), optional :: print_z
        
        logical :: show_z
        
        show_z = .false.
        if (present(print_z)) show_z = print_z
        
        if (show_z .and. present(z)) then
            write(output_unit, '(I0,A,F0.15,A,F0.15,A)') value, " at z=", real(z), "+", aimag(z), "i"
        else
            write(output_unit, '(I0,A)', advance='no') value, " "
        end if
    end subroutine print_value_at_z

    !> @brief Calculate field over complex domain  
    !> @param[in] min_re Minimum real value
    !> @param[in] max_re Maximum real value
    !> @param[in] min_im Minimum imaginary value
    !> @param[in] max_im Maximum imaginary value
    !> @param[in] num_re Number of real axis divisions
    !> @param[in] num_im Number of imaginary axis divisions
    !> @param[inout] vec Work vector for calculations
    !> @param[in] eps Tolerance for cycle detection
    subroutine calc_m_field(min_re, max_re, min_im, max_im, num_re, num_im, vec, eps)
        real(wp), intent(in) :: min_re, max_re, min_im, max_im
        integer(ip), intent(in) :: num_re, num_im
        complex(wp), intent(inout) :: vec(:)
        real(wp), intent(in) :: eps
        
        complex(wp) :: z0, z
        real(wp) :: re_delta, im_delta
        integer(ip) :: result_code
        integer :: im_n, re_n
        
        ! Validate input
        if (min_re > max_re .or. min_im > max_im) then
            write(output_unit, '(A,F0.3,A,F0.3,A,F0.3,A,F0.3,A)') &
                "Invalid area [", min_re, ",", max_re, "] ; [", min_im, ",", max_im, "]"
            return
        end if
        
        ! Calculate step sizes
        z0 = cmplx(min_re, max_im, kind=wp)
        re_delta = (max_re - min_re) / real(1 + num_re, wp)
        im_delta = (max_im - min_im) / real(1 + num_im, wp)
        
        write(output_unit, '(A,F0.3,A,F0.3,A,F0.3,A,F0.3,A)') &
            "calcMField [", min_re, ", ", max_re, "][", min_im, ", ", max_im, "]"
        write(output_unit, '(A,ES15.8,A,ES15.8)') "d(Re)=", re_delta, " d(Im)=", im_delta
        
        ! Iterate over imaginary axis
        do im_n = 0, num_im - 1
            z = z0
            z = cmplx(real(z), aimag(z) - real(im_n, wp) * im_delta, kind=wp)
            
            result_code = safe_calc_long_at_z(z, vec)
            if (result_code == 0) then
                result_code = cycle_detect_long(vec, eps)
            end if
            
            write(output_unit, '(A)', advance='no') new_line('A')
            call print_value_at_z(result_code, z)
            
            ! Add real axis steps
            do re_n = 0, num_re - 1
                z = z + cmplx(re_delta, 0.0_wp, kind=wp)
                result_code = safe_calc_long_at_z(z, vec)
                if (result_code == 0) then
                    result_code = cycle_detect_long(vec, eps)
                end if
                call print_value_at_z(result_code, z)
            end do
        end do
    end subroutine calc_m_field

    !> @brief Print precision information
    subroutine print_precision_info()
        real(real64) :: pi_double
        real(wp) :: pi_quad
        
        pi_double = acos(-1.0_real64)
        pi_quad = acos(-1.0_wp)
        
        write(output_unit, '(A,F0.15)') "'real64' precision:          ", pi_double
        if (wp == real128) then
            write(output_unit, '(A,F0.18)') "'real128' precision:         ", pi_quad
            write(output_unit, '(A,I0)') "size of real128: ", storage_size(pi_quad)/8
        else
            write(output_unit, '(A,F0.15)') "'real64' precision (fallback):", pi_quad
            write(output_unit, '(A,I0)') "size of real64: ", storage_size(pi_quad)/8
        end if
        write(output_unit, '(A,I0)') "size of real64: ", storage_size(pi_double)/8
    end subroutine print_precision_info

    !> @brief Print numeric limits information  
    subroutine print_limits_info()
        if (wp == real128) then
            write(output_unit, '(A,ES15.8)') "Minimum value for real128: ", tiny(1.0_wp)
            write(output_unit, '(A,ES15.8)') "Maximum value for real128: ", huge(1.0_wp)
            write(output_unit, '(A,ES15.8)') "epsilon for real128: ", epsilon(1.0_wp)
            write(output_unit, '(A,I0)') "precision for real128: ", precision(1.0_wp)
            write(output_unit, '(A,I0)') "range for real128: ", range(1.0_wp)
            write(output_unit, '(A,I0)') "radix for real128: ", radix(1.0_wp)
        else
            write(output_unit, '(A,ES15.8)') "Minimum value for real64: ", tiny(1.0_wp)
            write(output_unit, '(A,ES15.8)') "Maximum value for real64: ", huge(1.0_wp)
            write(output_unit, '(A,ES15.8)') "epsilon for real64: ", epsilon(1.0_wp)
            write(output_unit, '(A,I0)') "precision for real64: ", precision(1.0_wp)
            write(output_unit, '(A,I0)') "range for real64: ", range(1.0_wp)
            write(output_unit, '(A,I0)') "radix for real64: ", radix(1.0_wp)
        end if
    end subroutine print_limits_info

    !> @brief Print complex vector contents
    !> @param[in] vec Vector to print
    subroutine print_vector(vec)
        complex(wp), intent(in) :: vec(:)
        integer :: i
        
        write(output_unit, '(A)', advance='no') new_line('A')
        do i = 1, size(vec)
            write(output_unit, '(I0,A,F0.15,A,F0.15,A)', advance='no') &
                i, ": (", real(vec(i)), ",", aimag(vec(i)), ") "
        end do
    end subroutine print_vector

end program continued_exponential