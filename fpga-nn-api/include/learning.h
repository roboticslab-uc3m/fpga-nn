/*
 * perceptron.c
 * 
 */

#ifndef __LEARNING_H
#define __LEARNING_H

#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include "fixed_point.h"
#include "perceptron_comm.h"

#define ABS(n) (((n) >=0)? (n): -(n))

typedef struct {
    fixed16 in1;
    fixed16 in2;
    fixed16 result;
} learn_set_pair;


int learn_step(learn_set_pair* learn_set, int N, double learn_rate, uint8_t P, uint8_t S, FILE *fp);
int learn_compute_error(learn_set_pair* learn_set, int N, double* error, uint8_t P, uint8_t S, perceptron_package_t* r, FILE *fp);


#endif /* __LEARNING_H */
