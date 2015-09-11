/*
 * power.c
 *
 * Code generation for function 'power'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "power.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void b_power(const real_T a[3969], real_T y[3969])
{
  int32_T k;
  for (k = 0; k < 3969; k++) {
    y[k] = rt_powd_snf(a[k], 2.0);
  }
}

void power(const real_T a[2500], real_T y[2500])
{
  int32_T k;
  for (k = 0; k < 2500; k++) {
    y[k] = rt_powd_snf(a[k], 2.0);
  }
}

/* End of code generation (power.c) */
