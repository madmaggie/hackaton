/*
 * round80.c
 *
 * Code generation for function 'round80'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "round80.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
real_T round80(real_T n)
{
  real_T n_int;
  if (n > floor(n) + 0.8) {
    n_int = ceil(n);
  } else {
    n_int = floor(n);
  }

  return n_int;
}

/* End of code generation (round80.c) */
