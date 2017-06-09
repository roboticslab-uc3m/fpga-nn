/*
 * perceptron.c
 * 
 */

#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include "fixed_point.h"
#include "perceptron_comm.h"




int main(int agc, char **argv) {
    
    // 16 bit fixed point (4 int: 12 frac)
    fixed16 fix;
    double dou;
    perceptron_package_t p, r;
    
    uint8_t res = 0;
    
    int8_t val;
    
    // Initialice structures
    p.operation = 0;
    p.weight1 = 0;
    p.weight2 = 0;
    p.input1 = 0;
    p.input2 = 0;
    p.result = 0;
    r.operation = 0;
    r.weight1 = 0;
    r.weight2 = 0;
    r.input1 = 0;
    r.input2 = 0;
    r.result = 0;
    
    printf("Fixed point tests:\n=========================");
    
    printf("\nsize of fix: %lu bits", sizeof(fixed16)*8);
    printf("\nsize of int8: %lu bits", sizeof(int8_t)*8);
    
    printf("\n\nformat = (4,12). number = -0.4589");
    fix = float_to_fixed(-0.4589, 12);
    dou = fixed_to_float(fix, 12);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);
    
    printf("\n\nformat = (4,12). number = 2.867");
    fix = float_to_fixed(2.867, 12);
    dou = fixed_to_float(fix, 12);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);

    printf("\n\nformat = (12,4). number = -0.4589");
    fix = float_to_fixed(-0.4589, 4);
    dou = fixed_to_float(fix, 4);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);    

    printf("\n\nformat = (12,4). number = 2.867");
    fix = float_to_fixed(2.867, 4);
    dou = fixed_to_float(fix, 4);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);    
    

    printf("\n\nWrite test:\n=========================");
    p.operation = 0;
    p.weight1 = float_to_fixed(1.375, 4);
    p.weight2 = float_to_fixed(-4, 4);
    p.input1 = float_to_fixed(-2, 4);
    p.input2 = float_to_fixed(0.25, 4);
    p.result = 0;
    
    printf("\nValues: ");
    printf("\n\t- weight1 = %f (%x)", fixed_to_float(p.weight1, 4), p.weight1);
    printf("\n\t- weight2 = %f (%x)", fixed_to_float(p.weight2, 4), p.weight2);
    printf("\n\t- input1  = %f (%x)", fixed_to_float(p.input1, 4), p.input1);
    printf("\n\t- input2  = %f (%x)", fixed_to_float(p.input2, 4), p.input2);
    
    res = write_weights(&p);
    printf("\nWrite response: %d", res);
    
    
    res = read_perceptron(&r);
    printf("\nWrite response: %d", res);
 
    printf("\nRead Values: ");
    printf("\n\t- weight1 = %f (%x)", fixed_to_float((fixed8)r.weight1, 4), (fixed8)r.weight1);
    printf("\n\t- weight2 = %f (%x)", fixed_to_float((fixed8)r.weight2, 4), (fixed8)r.weight2);
    printf("\n\t- result  = %x", (fixed8)r.result);
    
    printf("\n");
    return 0;
}
