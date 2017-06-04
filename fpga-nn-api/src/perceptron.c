/*
 * perceptron.c
 * 
 */

#include <stdio.h>
#include <math.h>
#include "fixed_point.h"
#include "perceptron_comm.h"




int main(int agc, char **argv) {
    
    // 16 bit fixed point (4 int: 12 frac)
    fixed fix;
    double dou;
    perceptron_package_t p;
    byte response;
    
    fix = float_to_fixed(2.4589, 12);
    
    dou = fixed_to_float(fix, 12);
    
    int i = 3145872;
    
    printf("\nsize of fix: %lu", sizeof(short int));
    
    printf("\nfixed: %d", fix);
    printf("\ndouble: %f", dou);
    
    p.operation = 0;
    p.weight1 = float_to_fixed(2.5467, 12);
    p.weight2 = float_to_fixed(3.1134, 12);
    p.input1 = 0;
    p.input2 = 0;
    p.result = 0;
    
    response = write_weights(&p);
    printf("\nWrite response: %d", response);
    
    printf("\n");
    return 0;
}
