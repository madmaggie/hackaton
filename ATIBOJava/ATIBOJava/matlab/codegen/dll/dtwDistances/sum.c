/*
 * sum.c
 *
 * Code generation for function 'sum'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "sum.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void b_sum(const real_T x[2500], real_T y[50])
{
  int32_T iy;
  int32_T ixstart;
  int32_T j;
  int32_T ix;
  real_T s;
  int32_T k;
  iy = -1;
  ixstart = -1;
  for (j = 0; j < 50; j++) {
    ixstart++;
    ix = ixstart;
    s = x[ixstart];
    for (k = 0; k < 49; k++) {
      ix += 50;
      s += x[ix];
    }

    iy++;
    y[iy] = s;
  }
}

void c_sum(const real_T x[3969], real_T y[63])
{
  int32_T ix;
  int32_T iy;
  int32_T i;
  int32_T ixstart;
  real_T s;
  ix = -1;
  iy = -1;
  for (i = 0; i < 63; i++) {
    ixstart = ix + 1;
    ix++;
    s = x[ixstart];
    for (ixstart = 0; ixstart < 62; ixstart++) {
      ix++;
      s += x[ix];
    }

    iy++;
    y[iy] = s;
  }
}

void sum(const real_T x[2500], real_T y[50])
{
  int32_T ix;
  int32_T iy;
  int32_T i;
  int32_T ixstart;
  real_T s;
  ix = -1;
  iy = -1;
  for (i = 0; i < 50; i++) {
    ixstart = ix + 1;
    ix++;
    s = x[ixstart];
    for (ixstart = 0; ixstart < 49; ixstart++) {
      ix++;
      s += x[ix];
    }

    iy++;
    y[iy] = s;
  }
}

/* End of code generation (sum.c) */
