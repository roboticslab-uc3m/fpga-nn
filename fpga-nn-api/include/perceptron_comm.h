/*******************************************************************************
 *	perceptron_comm.h
 *
 *  Functionality to communicate with the perceptron
 *
 *
 *  This file is part of fpga-nn
 * 
 *  Copyright (C) 2015  Dennis Pinto Rivero
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 ******************************************************************************/

#ifndef __PERCEPTRON_COMM_H
#define __PERCEPTRON_COMM_H

#include "fixed_point.h"
#include <stdio.h>

#define WRITE_WEIGHTS   (50)
#define WRITE_INPUTS    (51)
#define READ            (5)
#define READ_RESPONSE   (100)
#define WRITE_OK        (101)
#define WRITE_ERROR     (102)
#define CONNECT_ERROR   (110)


typedef struct {
    uint8_t operation;
    fixed16 weight1;
    fixed16 weight2;
    fixed16 input1;
    fixed16 input2;
    fixed16 result; 
} perceptron_package_t;


int write_weights(perceptron_package_t *weights, FILE *fp);
int write_inputs(perceptron_package_t *p, FILE *fp);
int read_perceptron(perceptron_package_t *p, FILE *fp);


#endif  /* __PERCEPTRON_COMM_H */
