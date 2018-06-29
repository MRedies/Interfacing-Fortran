#include <stdlib.h>

struct compact{
    int number;
    double static_array[10];
    size_t length_dyn;
    double * dynamic_array;
};

struct compact* get_struct(){
    struct compact *ret = malloc(sizeof *ret);

    ret->number = 7;
    ret->length_dyn = 20;
    ret->dynamic_array = (double *) malloc(sizeof(double) * ret->length_dyn);

    for(int i = 0; i < 10; i++){
        ret->static_array[i]  = i*i;
    }

    for(int i = 0; i < ret->length_dyn; i++){
        ret->dynamic_array[i] = - 12 +i;
    }
    return ret;

}