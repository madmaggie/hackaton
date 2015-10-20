/*
 * pixels.c
 *
 * Code generation for function 'pixels'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "pixels.h"
#include "dtwDistances_emxutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void pixels(const real_T bitmapLetter[2500], emxArray_real_T *pix)
{
  real_T y[50];
  int32_T ix;
  int32_T iy;
  int32_T i;
  int32_T ixstart;
  real_T s;
  int32_T k;
  uint32_T b_k;

  /*  #codegen */
  /*  computes the (x,y) coordinates of non-zero values in a matrix of 1s and 0s */
  /*  equivalent code for regionprops(bitmapLetter,'PixelList') */
  /*  regionprops not supported by codegen */
  /*  */
  /*  bitmapLetter - bitmap representation of a letter */
  /*               - 1x2500 row of 0s and 1s */
  /*  returns pix = n*2 array */
  /*    where n is the number of non-zero values in bitmapLetter */
  /*  */
  /*  Copyright 2013-2015 Atibo */
  /*  reshaped 50*50 array of 0s and 1s because multi-dimensional array */
  /*  doesn't work when code is included in shared library */
  /*  need to get back to 50*50 array */
  /* bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2))); */
  ix = -1;
  iy = -1;
  for (i = 0; i < 50; i++) {
    ixstart = ix + 1;
    ix++;
    s = bitmapLetter[ixstart];
    for (k = 0; k < 49; k++) {
      ix++;
      s += bitmapLetter[ix];
    }

    iy++;
    y[iy] = s;
  }

  s = y[0];
  for (k = 0; k < 49; k++) {
    s += y[k + 1];
  }

  ixstart = pix->size[0] * pix->size[1];
  pix->size[0] = (int32_T)s;
  pix->size[1] = 2;
  emxEnsureCapacity((emxArray__common *)pix, ixstart, (int32_T)sizeof(real_T));
  k = ((int32_T)s << 1) - 1;
  for (ixstart = 0; ixstart <= k; ixstart++) {
    pix->data[ixstart] = 0.0;
  }

  b_k = 1U;
  for (i = 0; i < 50; i++) {
    for (ixstart = 0; ixstart < 50; ixstart++) {
      if (bitmapLetter[ixstart + 50 * i] > 0.0) {
        pix->data[((int32_T)b_k + pix->size[0]) - 1] = 1.0 + (real_T)ixstart;
        pix->data[(int32_T)b_k - 1] = 1.0 + (real_T)i;
        b_k++;
      }
    }
  }
}

/* End of code generation (pixels.c) */
