/*******************************************************************************
 *	fixed_point.h
 *
 *  Definition of fixed point numbers and its corresponding functionality
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

#include <limits.h>
#include <stdint.h>
#include <math.h>

// Definition of a signed fixed point number with 16 bit procession
    typedef int16_t fixed16;
    typedef uint16_t ufixed16;

// Definition of a signed fixed point number with 8 bit procession
    typedef int8_t fixed8;
    typedef uint8_t ufixed8;

// Macros to convert between double and fixed
// num is the number to convert and n_frac is the number of bits of the
// fractional part in the fixed point format.
#define float_to_fixed(num, n_frac)    ((fixed16)((num) * pow(2, (n_frac))))

#define fixed_to_float(num, n_frac, n)    ( (double)((fixed16)(num << 16-n ) >> (16-n)) / pow(2, n_frac))

