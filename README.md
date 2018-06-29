# Interfacing-Fortran
A complete tutorial on interfacing Fortran with C

## Reading C-Strings
In C strings are represented as ```char *``` arrays, terminated by the ```\NUL``` charakter. Unlike fortran these string do not have a fixed size. To convert them to Fortran style characters one can use C's strlen function:

```Fortran
function get_string(c_pointer) result(f_string)
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
end function get_string
```

A full working example can be found in example/char_arrays/.
