/*
 * repmat.h
 *
 * Code generation for function 'repmat'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

#ifndef __REPMAT_H__
#define __REPMAT_H__
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
extern void b_repmat(const real_T a[50], real_T b[2500]);
extern void c_repmat(const real_T a[63], real_T b[3969]);
extern void d_repmat(const real_T a[63], real_T b[3969]);
extern void repmat(const real_T a[50], real_T b[2500]);
#ifdef __cplusplus
}
#endif
#endif
/* End of code generation (repmat.h) */
