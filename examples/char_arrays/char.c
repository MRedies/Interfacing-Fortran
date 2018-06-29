#include <stdio.h>
#include <stdlib.h>

char * get_str(){
    char *str = (char *) malloc(sizeof(char) * 25);
    str = "Good night and good luck.";
    printf("String in C       = '%s'\n", str);

    return str;
}