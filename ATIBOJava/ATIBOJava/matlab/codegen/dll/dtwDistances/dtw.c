/*
 * dtw.c
 *
 * Code generation for function 'dtw'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "dtw.h"
#include "power.h"
#include "dtwDistances_emxutil.h"
#include "repmat.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
real_T b_dtw(const emxArray_real_T *r, const emxArray_real_T *t)
{
  real_T Dist;
  emxArray_real_T *a;
  int32_T jcol;
  int32_T iacol;
  int32_T mv[2];
  int32_T b_a[2];
  int32_T outsize[2];
  emxArray_real_T *c_a;
  int32_T ib;
  int32_T ia;
  int32_T k;
  emxArray_real_T *D;
  uint32_T uv1[2];
  emxArray_real_T *d;
  real_T u0;
  real_T b_u0;
  real_T u1;
  b_emxInit_real_T(&a, 1);

  /*  Dynamic Time Warping Algorithm */
  /*  Dist is unnormalized distance between t and r */
  /*  t is the vector you are testing (test letter) */
  /*  r is the vector you are testing against (model letter) */
  /*  [row,M]=size(r); */
  /*  if (row > M) */
  /*      M=row; */
  /*      r=r'; */
  /*  end; */
  /*   */
  /*  [row,N]=size(t); */
  /*  if (row > N) */
  /*      N=row; */
  /*      t=t'; */
  /*  end; */
  jcol = a->size[0];
  a->size[0] = r->size[1];
  emxEnsureCapacity((emxArray__common *)a, jcol, (int32_T)sizeof(real_T));
  iacol = r->size[1] - 1;
  for (jcol = 0; jcol <= iacol; jcol++) {
    a->data[jcol] = r->data[jcol];
  }

  mv[0] = 1;
  mv[1] = t->size[1];
  b_a[0] = a->size[0];
  b_a[1] = 1;
  for (jcol = 0; jcol < 2; jcol++) {
    outsize[jcol] = b_a[jcol] * mv[jcol];
  }

  emxInit_real_T(&c_a, 2);
  jcol = c_a->size[0] * c_a->size[1];
  c_a->size[0] = outsize[0];
  c_a->size[1] = outsize[1];
  emxEnsureCapacity((emxArray__common *)c_a, jcol, (int32_T)sizeof(real_T));
  if ((c_a->size[0] == 0) || (c_a->size[1] == 0)) {
  } else {
    ib = 0;
    for (iacol = 1; iacol <= mv[1]; iacol++) {
      ia = 0;
      for (k = 1; k <= a->size[0]; k++) {
        c_a->data[ib] = a->data[ia];
        ia++;
        ib++;
      }
    }
  }

  emxFree_real_T(&a);
  mv[0] = r->size[1];
  mv[1] = 1;
  for (jcol = 0; jcol < 2; jcol++) {
    outsize[jcol] = t->size[jcol] * mv[jcol];
  }

  emxInit_real_T(&D, 2);
  jcol = D->size[0] * D->size[1];
  D->size[0] = outsize[0];
  D->size[1] = outsize[1];
  emxEnsureCapacity((emxArray__common *)D, jcol, (int32_T)sizeof(real_T));
  if ((D->size[0] == 0) || (D->size[1] == 0)) {
  } else {
    ia = 1;
    ib = 0;
    iacol = 1;
    for (jcol = 1; jcol <= t->size[1]; jcol++) {
      for (k = 1; k <= mv[0]; k++) {
        D->data[ib] = t->data[iacol - 1];
        ia = iacol + 1;
        ib++;
      }

      iacol = ia;
    }
  }

  jcol = c_a->size[0] * c_a->size[1];
  c_a->size[0] = c_a->size[0];
  c_a->size[1] = c_a->size[1];
  emxEnsureCapacity((emxArray__common *)c_a, jcol, (int32_T)sizeof(real_T));
  iacol = c_a->size[0];
  jcol = c_a->size[1];
  iacol = iacol * jcol - 1;
  for (jcol = 0; jcol <= iacol; jcol++) {
    c_a->data[jcol] -= D->data[jcol];
  }

  for (jcol = 0; jcol < 2; jcol++) {
    uv1[jcol] = (uint32_T)c_a->size[jcol];
  }

  emxInit_real_T(&d, 2);
  jcol = d->size[0] * d->size[1];
  d->size[0] = (int32_T)uv1[0];
  d->size[1] = (int32_T)uv1[1];
  emxEnsureCapacity((emxArray__common *)d, jcol, (int32_T)sizeof(real_T));
  jcol = d->size[0] * d->size[1];
  for (k = 0; k <= jcol - 1; k++) {
    d->data[k] = rt_powd_snf(c_a->data[k], 2.0);
  }

  emxFree_real_T(&c_a);
  for (jcol = 0; jcol < 2; jcol++) {
    uv1[jcol] = (uint32_T)d->size[jcol];
  }

  jcol = D->size[0] * D->size[1];
  D->size[0] = (int32_T)uv1[0];
  emxEnsureCapacity((emxArray__common *)D, jcol, (int32_T)sizeof(real_T));
  jcol = D->size[0] * D->size[1];
  D->size[1] = (int32_T)uv1[1];
  emxEnsureCapacity((emxArray__common *)D, jcol, (int32_T)sizeof(real_T));
  iacol = (int32_T)uv1[0] * (int32_T)uv1[1] - 1;
  for (jcol = 0; jcol <= iacol; jcol++) {
    D->data[jcol] = 0.0;
  }

  D->data[0] = d->data[0];
  for (iacol = 0; iacol <= r->size[1] - 2; iacol++) {
    D->data[iacol + 1] = d->data[iacol + 1] + D->data[iacol];
  }

  for (jcol = 0; jcol <= t->size[1] - 2; jcol++) {
    D->data[D->size[0] * (jcol + 1)] = d->data[d->size[0] * (jcol + 1)] +
      D->data[D->size[0] * jcol];
  }

  for (iacol = 1; iacol - 1 <= r->size[1] - 2; iacol++) {
    for (jcol = 1; jcol - 1 <= t->size[1] - 2; jcol++) {
      u0 = D->data[(iacol + D->size[0] * jcol) - 1];
      b_u0 = D->data[(iacol + D->size[0] * (jcol - 1)) - 1];
      u1 = D->data[iacol + D->size[0] * (jcol - 1)];
      if ((b_u0 <= u1) || rtIsNaN(u1)) {
        u1 = b_u0;
      }

      if ((u0 <= u1) || rtIsNaN(u1)) {
        u1 = u0;
      }

      D->data[iacol + D->size[0] * jcol] = d->data[iacol + d->size[0] * jcol] +
        u1;

      /*  this double Min construction improves in 10-fold the Speed-up. Thanks Sven Mensing */
    }
  }

  emxFree_real_T(&d);
  Dist = D->data[(r->size[1] + D->size[0] * (t->size[1] - 1)) - 1];
  emxFree_real_T(&D);
  return Dist;
}

real_T dtw(const real_T r[50], const real_T t[50])
{
  real_T d[2500];
  real_T D[2500];
  real_T b_d[2500];
  int32_T m;
  int32_T n;
  real_T u0;
  real_T b_u0;
  real_T u1;

  /*  Dynamic Time Warping Algorithm */
  /*  Dist is unnormalized distance between t and r */
  /*  t is the vector you are testing (test letter) */
  /*  r is the vector you are testing against (model letter) */
  /*  [row,M]=size(r); */
  /*  if (row > M) */
  /*      M=row; */
  /*      r=r'; */
  /*  end; */
  /*   */
  /*  [row,N]=size(t); */
  /*  if (row > N) */
  /*      N=row; */
  /*      t=t'; */
  /*  end; */
  repmat(r, d);
  b_repmat(t, D);
  for (m = 0; m < 2500; m++) {
    b_d[m] = d[m] - D[m];
    D[m] = 0.0;
  }

  power(b_d, d);
  D[0] = d[0];
  for (m = 0; m < 49; m++) {
    D[1 + m] = d[1 + m] + D[m];
  }

  for (n = 0; n < 49; n++) {
    D[50 * (1 + n)] = d[50 * (1 + n)] + D[50 * n];
  }

  for (m = 0; m < 49; m++) {
    for (n = 0; n < 49; n++) {
      u0 = D[m + 50 * (1 + n)];
      b_u0 = D[m + 50 * n];
      u1 = D[(m + 50 * n) + 1];
      if ((b_u0 <= u1) || rtIsNaN(u1)) {
        u1 = b_u0;
      }

      if ((u0 <= u1) || rtIsNaN(u1)) {
        u1 = u0;
      }

      D[(m + 50 * (1 + n)) + 1] = d[(m + 50 * (1 + n)) + 1] + u1;

      /*  this double Min construction improves in 10-fold the Speed-up. Thanks Sven Mensing */
    }
  }

  return D[2499];
}

/* End of code generation (dtw.c) */
