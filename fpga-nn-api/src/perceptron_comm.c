/*******************************************************************************
 *	perceptron_comm.c
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


#include "perceptron_comm.h"
#include <stdio.h>
#include <stdlib.h>
#include "fixed_point.h"

int write_weights(perceptron_package_t *p, FILE *fp) {
    uint8_t response = 0;
    uint8_t package[5];

    p->operation = WRITE_WEIGHTS;
    
    // write data
    package[0] = p->operation;
    package[1] = ((uint8_t*)(&p->weight1))[1];    // w1 high
    package[2] = ((uint8_t*)(&p->weight1))[0];    // w1 low
    package[3] = ((uint8_t*)(&p->weight2))[1];    // w2 high
    package[4] = ((uint8_t*)(&p->weight2))[0];    // w2 low
    
    fwrite(package, sizeof(uint8_t)*5, 1, fp);
    // flush data
    fflush(fp);
    
    // read response
    fread(&response, sizeof(uint8_t), 1, fp);
    //response = WRITE_OK;
    
    return response;
}


int write_inputs(perceptron_package_t *p, FILE *fp) {
    uint8_t response;
    uint8_t package[5];
    
    p->operation = WRITE_INPUTS;
    
    // write data
    package[0] = p->operation;
    package[1] = ((uint8_t*)(&p->input1))[1];    // i1 high
    package[2] = ((uint8_t*)(&p->input1))[0];    // i1 low
    package[3] = ((uint8_t*)(&p->input2))[1];    // i2 high
    package[4] = ((uint8_t*)(&p->input2))[0];    // i2 low
    
    fwrite(package, sizeof(uint8_t)*5, 1, fp);
    
    // flush data
    fflush(fp);
    
      
    // read response
    fread(&response, sizeof(uint8_t), 1, fp);
    //response = WRITE_OK;
    
    return response;
}

int read_perceptron(perceptron_package_t *p, FILE *fp) {
    uint8_t response;
    uint8_t package[7];
    
    p->operation = READ;
    
    
    // write command
    package[0] = p->operation;
    fwrite(package, sizeof(uint8_t), 1, fp);
    
    // flush data
    fflush(fp);
    
    // read data
    fread(package, sizeof(uint8_t)*7, 1, fp);
 
    
    p->operation = package[0];
    ((uint8_t*)(&p->weight1))[1] = package[1];
    ((uint8_t*)(&p->weight1))[0] = package[2];
    ((uint8_t*)(&p->weight2))[1] = package[3];
    ((uint8_t*)(&p->weight2))[0] = package[4];
    ((uint8_t*)(&p->result))[1]  = package[5];
    ((uint8_t*)(&p->result))[0]  = package[6];
    
    //printf("\n - (%x)", package[0]);
    //printf("\n - (%x)", package[1]);
    //printf("\n - (%x)", package[2]);
    //printf("\n - (%x)", package[3]);
    //printf("\n - (%x)", package[4]);
    //printf("\n - (%x)", package[5]);
    //printf("\n - (%x)", package[6]);
    
    return p->operation;
}
