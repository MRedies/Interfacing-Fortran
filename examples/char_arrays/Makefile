all:
	gcc -c char.c -o c_char.o
	gfortran -c char.f90 -o f_char.o

	# make sure to link c-standart libray using "-lc" (or c++ using "-lstdc++")
	gfortran f_char.o c_char.o -o char.x -lc