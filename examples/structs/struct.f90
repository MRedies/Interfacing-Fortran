module c_struct
use, intrinsic :: iso_c_binding
    type, bind(c) :: compact
        integer(kind=c_int)              :: number
        real(kind=c_double)              :: static_array(10)
        integer(kind=c_size_t)           :: length_dyn
        type(c_ptr)                      :: dynamic_array   
    end type compact
end module c_struct

program main
    use, intrinsic :: iso_c_binding
    use c_struct
    implicit none
    type(c_ptr)                      :: c_pointer
    type(compact), pointer           :: f_pointer
    integer                          :: i 
    real(kind=c_double), pointer     :: dynamic_array(:)

    interface
        function get_struct() bind ( C, name = "get_struct" )&
                              result(c_pointer) 
        use, intrinsic :: iso_c_binding
            type(c_ptr)        :: c_pointer
        end function get_struct
    end interface

    ! call C to get struct * pointer
    c_pointer = get_struct()
    
    ! associate it with c
    call c_f_pointer(c_pointer, f_pointer)

    write (*,*) "number = ", f_pointer%number

    write (*,*) "shape(static) = ", shape(f_pointer%static_array)
    write (*,*) "static = "
    do i = 1,size(f_pointer%static_array)
        write (*,*) i, f_pointer%static_array(i)
    end do

    ! associate dynamic c-array with correct length
    call c_f_pointer(f_pointer%dynamic_array, dynamic_array,&
                     shape=[f_pointer%length_dyn])

    write (*,*) "dynamic shape = ", shape(dynamic_array)
    do i = 1,size(dynamic_array)
        write (*,*) i, dynamic_array(i)
    end do
end program main