/*
 * repmat.c
 *
 * Code generation for function 'repmat'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "repmat.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void b_repmat(const real_T a[50], real_T b[2500])
{
  int32_T ia;
  int32_T ib;
  int32_T iacol;
  int32_T jcol;
  int32_T itilerow;
  ia = 1;
  ib = 0;
  iacol = 1;
  for (jcol = 0; jcol < 50; jcol++) {
    for (itilerow = 0; itilerow < 50; itilerow++) {
      b[ib] = a[iacol - 1];
      ia = iacol + 1;
      ib++;
    }

    iacol = ia;
  }
}

void c_repmat(const real_T a[63], real_T b[3969])
{
  int32_T ib;
  int32_T jtilecol;
  int32_T ia;
  int32_T k;
  ib = 0;
  for (jtilecol = 0; jtilecol < 63; jtilecol++) {
    ia = 0;
    for (k = 0; k < 63; k++) {
      b[ib] = a[ia];
      ia++;
      ib++;
    }
  }
}

void d_repmat(const real_T a[63], real_T b[3969])
{
  int32_T ia;
  int32_T ib;
  int32_T iacol;
  int32_T jcol;
  int32_T itilerow;
  ia = 1;
  ib = 0;
  iacol = 1;
  for (jcol = 0; jcol < 63; jcol++) {
    for (itilerow = 0; itilerow < 63; itilerow++) {
      b[ib] = a[iacol - 1];
      ia = iacol + 1;
      ib++;
    }

    iacol = ia;
  }
}

void repmat(const real_T a[50], real_T b[2500])
{
  int32_T ib;
  int32_T jtilecol;
  int32_T ia;
  int32_T k;
  ib = 0;
  for (jtilecol = 0; jtilecol < 50; jtilecol++) {
    ia = 0;
    for (k = 0; k < 50; k++) {
      b[ib] = a[ia];
      ia++;
      ib++;
    }
  }
}

/* End of code generation (repmat.c) */
