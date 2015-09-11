/*
 * round.c
 *
 * Code generation for function 'round'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "round.h"
#include "anotherRotateImageWithoutImrotate.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void b_round(real_T x_data[3000], int32_T x_size[2])
{
  int32_T i6;
  int32_T k;
  i6 = x_size[1];
  for (k = 0; k <= i6 - 1; k++) {
    x_data[k] = rt_roundd_snf(x_data[k]);
  }
}

/* End of code generation (round.c) */
