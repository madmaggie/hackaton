/*
 * correctCentroids.h
 *
 * Code generation for function 'correctCentroids'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

#ifndef __CORRECTCENTROIDS_H__
#define __CORRECTCENTROIDS_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_defines.h"
#include "rt_nonfinite.h"

#include "rtwtypes.h"
#include "dtwDistances_types.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
#ifdef __cplusplus
extern "C" {
#endif
extern void b_correctCentroids(const emxArray_real_T *bitmapLetter, real_T *x, real_T *y);
extern void correctCentroids(const real_T bitmapLetter[2500], real_T *x, real_T *y);
#ifdef __cplusplus
}
#endif
#endif
/* End of code generation (correctCentroids.h) */
