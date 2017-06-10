/*
 * learning.c
 * 
 */

#include "learning.h"

#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include "fixed_point.h"
#include "perceptron_comm.h"

int learn_step(learn_set_pair* learn_set, int N, double learn_rate, uint8_t P, uint8_t S, FILE *fp) {
    perceptron_package_t p, r;
    int i;
    uint8_t res;
    double w1_new, w2_new;
    
    for (i = 0 ; i < N; i++) {
        // Write inputs and get result
        p.input1 = learn_set[i].in1;
        p.input2 = learn_set[i].in2;
        
        res = write_inputs(&p, fp);
        if (res != WRITE_OK) return -1;
        
        res = read_perceptron(&r, fp);
        if (res != READ_RESPONSE) return -2;
        
        // compute W(t+1)
        w1_new = fixed_to_float(r.weight1, P, S) + learn_rate*( fixed_to_float(learn_set[i].result, P, S) - fixed_to_float(r.result, P, S) )*fixed_to_float(learn_set[i].in1, P, S);
        w2_new = fixed_to_float(r.weight2, P, S) + learn_rate*( fixed_to_float(learn_set[i].result, P, S) - fixed_to_float(r.result, P, S) )*fixed_to_float(learn_set[i].in2, P, S);
        
        //printf("\n%f, %f, %f, %f", fixed_to_float(learn_set[i].in1, P, S), fixed_to_float(r.weight1, P, S), fixed_to_float(learn_set[i].result, P, S), fixed_to_float(r.result, P, S) );
        //printf("\n%f, %f, %f, %f", fixed_to_float(learn_set[i].in2, P, S), fixed_to_float(r.weight2, P, S), fixed_to_float(learn_set[i].result, P, S), fixed_to_float(r.result, P, S) );
        //printf("\nw1_delta = %f, w2_delta = %f", w1_new - fixed_to_float(r.weight1, P, S), w2_new - fixed_to_float(r.weight2, P, S));
        //printf("\nw1 = %f, w2 = %f", fixed_to_float(float_to_fixed(w1_new, P), P, S), fixed_to_float(float_to_fixed(w2_new, P), P, S));
        
        // Send perceptron weigths
        p.weight1 = float_to_fixed(w1_new, P);
        p.weight2 = float_to_fixed(w2_new, P);
        
        res = write_weights(&p, fp);  
        if (res != WRITE_OK) return -3;
    }
    
    return 0; 
}


int learn_compute_error(learn_set_pair* learn_set, int N, double* error, uint8_t P, uint8_t S, perceptron_package_t* r, FILE *fp) {
    perceptron_package_t p;
    int i;
    uint8_t res;
    double sum = 0;
    
    for ( i = 0 ; i < N; i++) {
        // Write inputs and get output
        p.input1 = learn_set[i].in1;
        p.input2 = learn_set[i].in2;
        res = write_inputs(&p, fp);
        if (res != WRITE_OK) return -1;
        
        res = read_perceptron(r, fp);
        if (res != READ_RESPONSE) return -2;
        
        // compute sumj = sumj-1 + abs(dj - y(Xj))
        sum = sum + ABS(fixed_to_float(learn_set[i].result, P, S) - fixed_to_float(r->result, P, S)); 
    }
    
    *error = sum/N;
    
    return 0;
}
