/*
 * main.c
 * 
 */

#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include "fixed_point.h"
#include "perceptron_comm.h"
#include "learning.h"

#define DEV_FILE "/dev/ttyUSB1"

#define P 10
#define S 12

#define OR_N 4

learn_set_pair learn_set_OR[OR_N] = {
    {float_to_fixed(0.1, P), float_to_fixed(0.1, P), float_to_fixed(0.1, P)},
    {float_to_fixed(0.1, P), float_to_fixed(0.9, P), float_to_fixed(0.9, P)},
    {float_to_fixed(0.9, P), float_to_fixed(0.1, P), float_to_fixed(0.9, P)},
    {float_to_fixed(0.9, P), float_to_fixed(0.9, P), float_to_fixed(0.9, P)}
};

// Perform tests on perceptron
int test_perceptron(FILE *fp);
int learn(learn_set_pair* learn_set, int N, FILE *fp);

int main(int agc, char **argv) {
    FILE *fp;
    
    // open file
    fp = fopen(DEV_FILE, "a+");
    if (fp == NULL) {
        printf("\nERROR: Could not connect to device");
        return 0;
    }

    //printf("\n  PERFORMING TESTS\n  ================================");
    //test_perceptron(fp);
    
    printf("\n  LEARNING 'OR' FUNCTION\n  ================================");
    learn(learn_set_OR, OR_N, fp);

    return 0;
}

int test_perceptron(FILE *fp) {
    
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
    dou = fixed_to_float(fix, 12, 16);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);
    
    printf("\n\nformat = (4,12). number = 2.867");
    fix = float_to_fixed(2.867, 12);
    dou = fixed_to_float(fix, 12, 16);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);

    printf("\n\nformat = (12,4). number = -0.4589");
    fix = float_to_fixed(-0.4589, 4);
    dou = fixed_to_float(fix, 4, 16);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);    

    printf("\n\nformat = (12,4). number = 2.867");
    fix = float_to_fixed(2.867, 4);
    dou = fixed_to_float(fix, 4, 16);
    printf("\nfixed: %d", (ufixed16)fix);
    printf("\ndouble: %f", dou);    
    

    printf("\n\nWrite test:\n=========================");
    p.operation = 0;
    p.weight1 = float_to_fixed(1.375, P);
    p.weight2 = float_to_fixed(-4, P);
    p.input1 = float_to_fixed(-2, P);
    p.input2 = float_to_fixed(0.25, P);
    p.result = 0;
    
    printf("\nValues: ");
    printf("\n\t- weight1 = %f (%x)", fixed_to_float(p.weight1, P, S), p.weight1);
    printf("\n\t- weight2 = %f (%x)", fixed_to_float(p.weight2, P, S), p.weight2);
    printf("\n\t- input1  = %f (%x)", fixed_to_float(p.input1, P, S), p.input1);
    printf("\n\t- input2  = %f (%x)", fixed_to_float(p.input2, P, S), p.input2);
    
    res = write_weights(&p, fp);
    printf("\nWrite response: %d", res);

    res = write_inputs(&p, fp);
    printf("\nWrite response: %d", res);
    
    
    res = read_perceptron(&r, fp);
    printf("\nWrite response: %d", res);
 
    printf("\nRead Values: ");
    printf("\n\t- weight1 = %f (%x)", fixed_to_float(r.weight1, P, S), r.weight1);
    printf("\n\t- weight2 = %f (%x)", fixed_to_float(r.weight2, P, S), r.weight2);
    printf("\n\t- result  = %f (%x)", fixed_to_float(r.result, P, S), r.result);
    
    printf("\n");
    return 0;  
}


int learn(learn_set_pair* learn_set, int N, FILE *fp) {
    double learn_rate = 0.005;
    double e = 0.1;
    double error;
    int res;
    int i = 0;
    perceptron_package_t r;
    
    printf("\n\nLearn logic function\n--------------------------");
    do {
        
        // Make a learn step
        res = learn_step(learn_set, N, learn_rate, P, S, fp);
        if (res != 0) {
            printf("\nlearn_OR: [ERROR %d] While making the learn step %d", res, i);
            return -1;
        }
        
        // Compute error
        res = learn_compute_error(learn_set, N, &error, P, S, &r, fp);
        if (res != 0) {
            printf("\nlearn_OR: [ERROR %d] While computing perceptron deviation, step %d", res, i);
            return -1;
        }
        
        printf("\n======================================> Step: %d, Deviation: %f ", i, error);
        printf("\nw1 = %f (%x)", fixed_to_float(r.weight1, P, S), r.weight1);
        printf(" | w2 = %f (%x)", fixed_to_float(r.weight2, P, S), r.weight2);
        i++;
    } while(error > e);
    
    
    
    printf("\n\nFinished learning function\n--------------------------");
    
    // Show weights
    // Show the result to all the pairs in the learning set and the corresponding errors
    
    
    return 0;
}
