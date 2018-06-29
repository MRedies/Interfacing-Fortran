program main
    use, intrinsic :: iso_c_binding
    implicit none
    character(len=:), allocatable    :: f_string
    type(c_ptr)                      :: c_pointer

    interface
        function get_str() bind ( C, name = "get_str" ) result(c_pointer) 
        use, intrinsic :: iso_c_binding
            type(c_ptr)        :: c_pointer
        end function get_str
    end interface

    ! call C to get char * pointer
    c_pointer = get_str()
    
    ! convert it to fortran-style strings
    f_string  = convert_string(c_pointer)

    write (*,"(A,A,A)") "String in Fortran = '", f_string, "'"

contains

    function convert_string(c_pointer) result(f_string)
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr), intent(in)                 :: c_pointer
        character(len=:), pointer               :: f_ptr
        character(len=:), allocatable           :: f_string
        integer(c_size_t)                       :: l_str
    
        interface
            function c_strlen(str_ptr) bind ( C, name = "strlen" ) result(len)
            use, intrinsic :: iso_c_binding
                type(c_ptr), value              :: str_ptr
                integer(kind=c_size_t)          :: len
            end function c_strlen
        end interface
    
        call c_f_pointer(c_pointer, f_ptr )
        l_str = c_strlen(c_pointer)
    
        f_string = f_ptr(1:l_str)
    end function convert_string
end program main