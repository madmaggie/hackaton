/*
 * dtw.h
 *
 * Code generation for function 'dtw'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

#ifndef __DTW_H__
#define __DTW_H__
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
extern real_T b_dtw(const emxArray_real_T *r, const emxArray_real_T *t);
extern real_T dtw(const real_T r[50], const real_T t[50]);
#ifdef __cplusplus
}
#endif
#endif
/* End of code generation (dtw.h) */
