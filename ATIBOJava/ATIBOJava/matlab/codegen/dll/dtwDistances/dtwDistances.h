/*
 * dtwDistances.h
 *
 * Code generation for function 'dtwDistances'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

#ifndef __DTWDISTANCES_H__
#define __DTWDISTANCES_H__
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
extern void dtwDistances(const real_T letterModel_data[6000], const int32_T letterModel_size[2], const real_T letterTest_data[6000], const int32_T letterTest_size[2], real_T *DistX, real_T *DistY, real_T *DistU, real_T *DistR);
#ifdef __cplusplus
}
#endif
#endif
/* End of code generation (dtwDistances.h) */
