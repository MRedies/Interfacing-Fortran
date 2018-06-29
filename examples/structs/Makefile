all:
	gcc -c struct.c -o c_struct.o
	gfortran -c struct.f90 -o f_struct.o

	# make sure to link c-standart libray using "-lc" (or c++ using "-lstdc++")
	gfortran f_struct.o c_struct.o -o struct.x -lc