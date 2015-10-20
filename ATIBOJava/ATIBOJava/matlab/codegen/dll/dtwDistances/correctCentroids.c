/*
 * correctCentroids.c
 *
 * Code generation for function 'correctCentroids'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "correctCentroids.h"
#include "anotherRotateImageWithoutImrotate.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void b_correctCentroids(const emxArray_real_T *bitmapLetter, real_T *x, real_T
  *y)
{
  real_T sumx;
  real_T sumy;
  real_T nrpct;
  int32_T i;
  int32_T j;

  /*  #codegen */
  /*  computes the (x,y) coordinates of non-zero values in a matrix of 1s and 0s */
  /*  equivalent code for regionprops(bitmapLetter,'centroids') */
  /*  regionprops not supported by codegen */
  /*  */
  /*  bitmapLetter - bitmap representation of a letter */
  /*               - 50x50 row of 0s and 1s */
  /*  returns x - x coordinae of the centroid */
  /*          y - y coordinate of the centroid */
  /*  */
  /*  Copyright 2013-2015 Atibo */
  /* assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [50 50])); */
  /*  need to get back to 50*50 array */
  /* bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2))); */
  sumx = 0.0;
  sumy = 0.0;
  nrpct = 0.0;
  for (i = 0; i <= bitmapLetter->size[0] - 1; i++) {
    for (j = 0; j <= bitmapLetter->size[1] - 1; j++) {
      if (bitmapLetter->data[i + bitmapLetter->size[0] * j] > 0.0) {
        sumx += 1.0 + (real_T)i;
        sumy += 1.0 + (real_T)j;
        nrpct++;
      }
    }
  }

  *y = rt_roundd_snf(sumx / nrpct);
  *x = rt_roundd_snf(sumy / nrpct);
}

void correctCentroids(const real_T bitmapLetter[2500], real_T *x, real_T *y)
{
  real_T sumx;
  real_T sumy;
  real_T nrpct;
  int32_T i;
  int32_T j;

  /*  #codegen */
  /*  computes the (x,y) coordinates of non-zero values in a matrix of 1s and 0s */
  /*  equivalent code for regionprops(bitmapLetter,'centroids') */
  /*  regionprops not supported by codegen */
  /*  */
  /*  bitmapLetter - bitmap representation of a letter */
  /*               - 50x50 row of 0s and 1s */
  /*  returns x - x coordinae of the centroid */
  /*          y - y coordinate of the centroid */
  /*  */
  /*  Copyright 2013-2015 Atibo */
  /* assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [50 50])); */
  /*  need to get back to 50*50 array */
  /* bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2))); */
  sumx = 0.0;
  sumy = 0.0;
  nrpct = 0.0;
  for (i = 0; i < 50; i++) {
    for (j = 0; j < 50; j++) {
      if (bitmapLetter[i + 50 * j] > 0.0) {
        sumx += 1.0 + (real_T)i;
        sumy += 1.0 + (real_T)j;
        nrpct++;
      }
    }
  }

  *y = rt_roundd_snf(sumx / nrpct);
  *x = rt_roundd_snf(sumy / nrpct);
}

/* End of code generation (correctCentroids.c) */
