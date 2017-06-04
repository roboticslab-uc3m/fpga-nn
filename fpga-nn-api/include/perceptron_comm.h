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

#define WRITE_WEIGHTS   (100)
#define WRITE_INPUTS    (90)
#define READ            (5)
#define READ_RESPONSE   (6)
#define WRITE_OK        (101)
#define WRITE_ERROR     (102)

#define FILE_NAME "./device"

typedef char byte;

typedef struct {
    byte operation;
    fixed weight1;
    fixed weight2;
    fixed input1;
    fixed input2;
    fixed result; 
} perceptron_package_t;


int write_weights(perceptron_package_t *weights);


#endif  /* __PERCEPTRON_COMM_H */
