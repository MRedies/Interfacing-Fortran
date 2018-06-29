# Interfacing-Fortran
A complete tutorial on interfacing Fortran with C. Improvement and requests for further examples are welcome.

## Calling C from Fortran
### Reading C-Strings
In C strings are represented as ```char *``` arrays, terminated by the ```\NUL``` charakter. Unlike fortran these string do not have a fixed size. To convert them to Fortran style characters one can use C's ```strlen``` function:

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

The use of ```strlen``` avoids casting a ```char *```-array as a ```character(len=1), dimension(:)```-array, which can cause problems with some compilers. A full working example can be found in [example/char_arrays/](https://github.com/MRedies/Interfacing-Fortran/tree/master/examples/char_arrays).


### Dealing with structures and pointers
Since Fortran 2003 Fortran offers the function ```c_f_pointer```, that allows the user to map a c-pointer onto a Fortran pointer. Using this we can use C's ```struct *``` directly. Take the following C struct:
```C
struct compact{
    int number;
    double static_array[10];
    size_t length_dyn;
    double * dynamic_array;
};
```
First we need to define the corresponding type in Fortran:

```Fortran
module c_struct
use, intrinsic :: iso_c_binding
    type, bind(c) :: compact
        integer(kind=c_int)              :: number
        real(kind=c_double)              :: static_array(10)
        integer(kind=c_size_t)           :: length_dyn
        type(c_ptr)                      :: dynamic_array   
    end type compact
end module c_struct
```

Then we define the interface to a C-function, that returns our C-pointer:
```Fortran
interface
    function get_struct() bind ( C, name = "get_struct" )&
                          result(c_pointer) 
    use, intrinsic :: iso_c_binding
        type(c_ptr)        :: c_pointer
    end function get_struct
end interface
```
and with this we can get the C-pointer and associate it with a pointer to our local type:

```Fortran
type(compact), pointer           :: f_pointe
...
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
```
for the static array we could simple define the length of the array in the type, but for the dynamic array we would not do this. Here we don't deal with the array at all, we just keep the C-pointer in storage. If we then want to access the data in the array we need to know it's length, since C doesn't know it's own arrays length. Taking the length form the type, we can access the data:
```Fortran
! associate dynamic c-array with correct length
call c_f_pointer(f_pointer%dynamic_array, dynamic_array,&
                 shape=[f_pointer%length_dyn])

write (*,*) "dynamic shape = ", shape(dynamic_array)
do i = 1,size(dynamic_array)
    write (*,*) i, dynamic_array(i)
end do
```

The full example can be found in [examples/structs/](https://github.com/MRedies/Interfacing-Fortran/tree/master/examples/structs)
