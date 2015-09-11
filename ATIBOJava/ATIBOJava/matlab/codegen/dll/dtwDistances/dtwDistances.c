/*
 * dtwDistances.c
 *
 * Code generation for function 'dtwDistances'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "power.h"
#include "repmat.h"
#include "sum.h"
#include "anotherRotateImageWithoutImrotate.h"
#include "dtwDistances_emxutil.h"
#include "correctCentroids.h"
#include "dtw.h"
#include "Compute_AbslAng_Chain.h"
#include "pixels.h"
#include "createBitmap.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static int32_T compute_nones(const boolean_T x_data[6000], const int32_T x_size
  [2], int32_T n);
static void eml_li_find(const boolean_T x_data[6000], const int32_T x_size[2],
  int32_T y_data[6000], int32_T y_size[1]);

/* Function Definitions */
static int32_T compute_nones(const boolean_T x_data[6000], const int32_T x_size
  [2], int32_T n)
{
  int32_T k;
  int32_T i;
  k = 0;
  for (i = 1; i <= n; i++) {
    if (x_data[i - 1]) {
      k++;
    }
  }

  return k;
}

static void eml_li_find(const boolean_T x_data[6000], const int32_T x_size[2],
  int32_T y_data[6000], int32_T y_size[1])
{
  int32_T n;
  int32_T k;
  int32_T i;
  n = x_size[0] * x_size[1];
  k = compute_nones(x_data, x_size, n);
  y_size[0] = k;
  k = 0;
  for (i = 1; i <= n; i++) {
    if (x_data[i - 1]) {
      y_data[k] = i;
      k++;
    }
  }
}

void dtwDistances(const real_T letterModel_data[6000], const int32_T
                  letterModel_size[2], const real_T letterTest_data[6000], const
                  int32_T letterTest_size[2], real_T *DistX, real_T *DistY,
                  real_T *DistU, real_T *DistR)
{
  boolean_T b_letterModel_data[6000];
  int32_T b_letterModel_size[2];
  int32_T loop_ub;
  int32_T i0;
  int32_T tmp_size[1];
  static int32_T tmp_data[6000];
  int32_T b_letterTest_size[2];
  int32_T b_tmp_size[1];
  static int32_T b_tmp_data[6000];
  int16_T sz[2];
  static real_T y_data[6000];
  int32_T y_size_idx_0;
  int32_T ixstart;
  int32_T c_tmp_data[6000];
  static real_T b_y_data[6000];
  static real_T c_y_data[6000];
  int32_T y_size[2];
  int32_T i1;
  real_T bitmapLetterModel[2500];
  int32_T b_y_size[2];
  real_T bitmapLetterTest[2500];
  real_T hor1[50];
  real_T hor2[50];
  real_T mtmp;
  boolean_T exitg4;
  real_T b_mtmp;
  boolean_T exitg3;
  real_T b_hor1[50];
  real_T b_hor2[50];
  real_T dv0[50];
  boolean_T exitg2;
  boolean_T exitg1;
  emxArray_real_T *pixModel;
  emxArray_real_T *pixTest;
  emxArray_real_T *b_pixModel;
  int32_T i2;
  int32_T i3;
  emxArray_real_T *model1;
  emxArray_real_T *b_pixTest;
  emxArray_real_T *test1;
  emxArray_real_T *b_model1;
  emxArray_real_T *b_test1;
  real_T centroids_model_y;
  real_T centroids_model_x;
  real_T x;
  real_T b_x;
  emxArray_real_T *centeredLetterTest;
  emxArray_real_T *b_centeredLetterTest;
  emxArray_real_T *centeredLetterModel;
  real_T c_centeredLetterTest[2401];
  real_T b_centeredLetterModel[2401];
  static real_T dv1[3969];
  real_T summodel[63];
  static real_T rotated_test[3969];
  static real_T dv2[3969];
  real_T dv3[63];
  static real_T rotated_model[3969];
  static real_T b_rotated_model[3969];

  /*  computes the DTW distances on X, on Y, on absolute angles and on rotated */
  /*  letters */
  /*  letterModel - raw (x,y) coordinates of the model letter */
  /*                2*N matrix */
  /*  letterTest - raw (x,y) coordinates of the test letter */
  /*                2*N matrix */
  /*  */
  /*  Copyright 2013-2015 Atibo */
  /*  letterModel and letterTest arrays have 0 cordinates */
  /*  because of how they are constucted in Java */
  /*  although the received parameters are (1x6000) arrays */
  /*  after deleting the 0 coordinates they become (6000x1) arrays */
  /*  therefore the arrays need to be transposed */
  /*  this is only when calling the dll version of this function from Java */
  /*  when called as standalone from Matlab, no need for transposition */
  b_letterModel_size[0] = letterModel_size[0];
  b_letterModel_size[1] = letterModel_size[1];
  loop_ub = letterModel_size[0] * letterModel_size[1] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    b_letterModel_data[i0] = (letterModel_data[i0] != 0.0);
  }

  eml_li_find(b_letterModel_data, b_letterModel_size, tmp_data, tmp_size);
  b_letterTest_size[0] = letterTest_size[0];
  b_letterTest_size[1] = letterTest_size[1];
  loop_ub = letterTest_size[0] * letterTest_size[1] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    b_letterModel_data[i0] = (letterTest_data[i0] != 0.0);
  }

  eml_li_find(b_letterModel_data, b_letterTest_size, b_tmp_data, b_tmp_size);

  /*  because arrays are (1x6000) */
  /*  we split them in two-row arrays */
  /*  x-coordinate on the first row */
  /*  y-coordinate on the second row */
  for (i0 = 0; i0 < 2; i0++) {
    sz[i0] = 0;
  }

  sz[0] = (int16_T)rt_roundd_snf((real_T)tmp_size[0] / 2.0);
  sz[1] = 2;
  y_size_idx_0 = sz[0];
  for (ixstart = 0; ixstart + 1 <= tmp_size[0]; ixstart++) {
    loop_ub = tmp_size[0] - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      c_tmp_data[i0] = tmp_data[i0];
    }

    y_data[ixstart] = letterModel_data[c_tmp_data[ixstart] - 1];
  }

  for (i0 = 0; i0 < 2; i0++) {
    sz[i0] = 0;
  }

  sz[0] = (int16_T)rt_roundd_snf((real_T)b_tmp_size[0] / 2.0);
  sz[1] = 2;
  for (ixstart = 0; ixstart + 1 <= b_tmp_size[0]; ixstart++) {
    loop_ub = b_tmp_size[0] - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      c_tmp_data[i0] = b_tmp_data[i0];
    }

    b_y_data[ixstart] = letterTest_data[c_tmp_data[ixstart] - 1];
  }

  y_size[0] = 2;
  y_size[1] = y_size_idx_0;
  loop_ub = y_size_idx_0 - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    for (i1 = 0; i1 < 2; i1++) {
      c_y_data[i1 + 2 * i0] = y_data[i0 + y_size_idx_0 * i1];
    }
  }

  createBitmap(c_y_data, y_size, bitmapLetterModel);
  b_y_size[0] = 2;
  b_y_size[1] = sz[0];
  loop_ub = sz[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    for (i1 = 0; i1 < 2; i1++) {
      y_data[i1 + 2 * i0] = b_y_data[i0 + sz[0] * i1];
    }
  }

  createBitmap(y_data, b_y_size, bitmapLetterTest);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%               DTW distance on X                 %%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  sum(bitmapLetterModel, hor1);
  sum(bitmapLetterTest, hor2);
  ixstart = 1;
  mtmp = hor1[0];
  if (rtIsNaN(hor1[0])) {
    y_size_idx_0 = 2;
    exitg4 = FALSE;
    while ((exitg4 == 0U) && (y_size_idx_0 < 51)) {
      ixstart = y_size_idx_0;
      if (!rtIsNaN(hor1[y_size_idx_0 - 1])) {
        mtmp = hor1[y_size_idx_0 - 1];
        exitg4 = TRUE;
      } else {
        y_size_idx_0++;
      }
    }
  }

  if (ixstart < 50) {
    while (ixstart + 1 < 51) {
      if (hor1[ixstart] > mtmp) {
        mtmp = hor1[ixstart];
      }

      ixstart++;
    }
  }

  ixstart = 1;
  b_mtmp = hor2[0];
  if (rtIsNaN(hor2[0])) {
    y_size_idx_0 = 2;
    exitg3 = FALSE;
    while ((exitg3 == 0U) && (y_size_idx_0 < 51)) {
      ixstart = y_size_idx_0;
      if (!rtIsNaN(hor2[y_size_idx_0 - 1])) {
        b_mtmp = hor2[y_size_idx_0 - 1];
        exitg3 = TRUE;
      } else {
        y_size_idx_0++;
      }
    }
  }

  if (ixstart < 50) {
    while (ixstart + 1 < 51) {
      if (hor2[ixstart] > b_mtmp) {
        b_mtmp = hor2[ixstart];
      }

      ixstart++;
    }
  }

  for (i0 = 0; i0 < 50; i0++) {
    b_hor1[i0] = hor1[i0] / mtmp;
    b_hor2[i0] = hor2[i0] / b_mtmp;
  }

  *DistX = dtw(b_hor1, b_hor2);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%               DTW distance on Y                 %%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  b_sum(bitmapLetterModel, dv0);
  memcpy(&hor1[0], &dv0[0], 50U * sizeof(real_T));
  b_sum(bitmapLetterTest, dv0);
  memcpy(&hor2[0], &dv0[0], 50U * sizeof(real_T));
  ixstart = 1;
  mtmp = hor1[0];
  if (rtIsNaN(hor1[0])) {
    y_size_idx_0 = 2;
    exitg2 = FALSE;
    while ((exitg2 == 0U) && (y_size_idx_0 < 51)) {
      ixstart = y_size_idx_0;
      if (!rtIsNaN(hor1[y_size_idx_0 - 1])) {
        mtmp = hor1[y_size_idx_0 - 1];
        exitg2 = TRUE;
      } else {
        y_size_idx_0++;
      }
    }
  }

  if (ixstart < 50) {
    while (ixstart + 1 < 51) {
      if (hor1[ixstart] > mtmp) {
        mtmp = hor1[ixstart];
      }

      ixstart++;
    }
  }

  ixstart = 1;
  b_mtmp = hor2[0];
  if (rtIsNaN(hor2[0])) {
    y_size_idx_0 = 2;
    exitg1 = FALSE;
    while ((exitg1 == 0U) && (y_size_idx_0 < 51)) {
      ixstart = y_size_idx_0;
      if (!rtIsNaN(hor2[y_size_idx_0 - 1])) {
        b_mtmp = hor2[y_size_idx_0 - 1];
        exitg1 = TRUE;
      } else {
        y_size_idx_0++;
      }
    }
  }

  if (ixstart < 50) {
    while (ixstart + 1 < 51) {
      if (hor2[ixstart] > b_mtmp) {
        b_mtmp = hor2[ixstart];
      }

      ixstart++;
    }
  }

  for (i0 = 0; i0 < 50; i0++) {
    b_hor1[i0] = hor1[i0] / mtmp;
    b_hor2[i0] = hor2[i0] / b_mtmp;
  }

  emxInit_real_T(&pixModel, 2);
  emxInit_real_T(&pixTest, 2);
  *DistY = dtw(b_hor1, b_hor2);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%         DTW distance on absolute angles         %%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  pixels(bitmapLetterModel, pixModel);
  pixels(bitmapLetterTest, pixTest);
  if (1 > pixModel->size[0]) {
    i0 = 1;
    i1 = -1;
  } else {
    i0 = 7;
    i1 = pixModel->size[0] - 1;
  }

  if (1 > pixTest->size[0]) {
    ixstart = 1;
    y_size_idx_0 = -1;
  } else {
    ixstart = 7;
    y_size_idx_0 = pixTest->size[0] - 1;
  }

  emxInit_real_T(&b_pixModel, 2);
  i2 = b_pixModel->size[0] * b_pixModel->size[1];
  b_pixModel->size[0] = i1 / i0 + 1;
  b_pixModel->size[1] = 2;
  emxEnsureCapacity((emxArray__common *)b_pixModel, i2, (int32_T)sizeof(real_T));
  for (i2 = 0; i2 < 2; i2++) {
    loop_ub = i1 / i0;
    for (i3 = 0; i3 <= loop_ub; i3++) {
      b_pixModel->data[i3 + b_pixModel->size[0] * i2] = pixModel->data[i0 * i3 +
        pixModel->size[0] * i2];
    }
  }

  emxFree_real_T(&pixModel);
  emxInit_real_T(&model1, 2);
  emxInit_real_T(&b_pixTest, 2);
  Compute_AbslAng_Chain(b_pixModel, model1);
  i0 = b_pixTest->size[0] * b_pixTest->size[1];
  b_pixTest->size[0] = y_size_idx_0 / ixstart + 1;
  b_pixTest->size[1] = 2;
  emxEnsureCapacity((emxArray__common *)b_pixTest, i0, (int32_T)sizeof(real_T));
  emxFree_real_T(&b_pixModel);
  for (i0 = 0; i0 < 2; i0++) {
    loop_ub = y_size_idx_0 / ixstart;
    for (i1 = 0; i1 <= loop_ub; i1++) {
      b_pixTest->data[i1 + b_pixTest->size[0] * i0] = pixTest->data[ixstart * i1
        + pixTest->size[0] * i0];
    }
  }

  emxFree_real_T(&pixTest);
  emxInit_real_T(&test1, 2);
  emxInit_real_T(&b_model1, 2);
  Compute_AbslAng_Chain(b_pixTest, test1);
  i0 = b_model1->size[0] * b_model1->size[1];
  b_model1->size[0] = 1;
  b_model1->size[1] = model1->size[1];
  emxEnsureCapacity((emxArray__common *)b_model1, i0, (int32_T)sizeof(real_T));
  emxFree_real_T(&b_pixTest);
  loop_ub = model1->size[0] * model1->size[1] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    b_model1->data[i0] = model1->data[i0] / 360.0;
  }

  emxFree_real_T(&model1);
  emxInit_real_T(&b_test1, 2);
  i0 = b_test1->size[0] * b_test1->size[1];
  b_test1->size[0] = 1;
  b_test1->size[1] = test1->size[1];
  emxEnsureCapacity((emxArray__common *)b_test1, i0, (int32_T)sizeof(real_T));
  loop_ub = test1->size[0] * test1->size[1] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    b_test1->data[i0] = test1->data[i0] / 360.0;
  }

  emxFree_real_T(&test1);
  *DistU = b_dtw(b_model1, b_test1);

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%         DTW distance on rotated letters         %%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  correctCentroids(bitmapLetterModel, &centroids_model_x, &centroids_model_y);
  correctCentroids(bitmapLetterTest, &mtmp, &b_mtmp);
  x = rt_roundd_snf(mtmp);
  b_x = rt_roundd_snf(b_mtmp);
  b_mtmp = rt_roundd_snf(centroids_model_x);
  mtmp = rt_roundd_snf(centroids_model_y);
  emxFree_real_T(&b_test1);
  emxFree_real_T(&b_model1);
  emxInit_real_T(&centeredLetterTest, 2);
  if (-b_x + 25.0 > 0.0) {
    i0 = centeredLetterTest->size[0] * centeredLetterTest->size[1];
    centeredLetterTest->size[0] = (int32_T)(-b_x + 25.0) + 50;
    centeredLetterTest->size[1] = 50;
    emxEnsureCapacity((emxArray__common *)centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = (int32_T)(-b_x + 25.0) - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0] = 0.0;
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      for (i1 = 0; i1 < 50; i1++) {
        centeredLetterTest->data[(i1 + (int32_T)(-b_x + 25.0)) +
          centeredLetterTest->size[0] * i0] = bitmapLetterTest[i1 + 50 * i0];
      }
    }
  } else {
    ixstart = (int32_T)fabs(-b_x + 25.0);
    i0 = centeredLetterTest->size[0] * centeredLetterTest->size[1];
    centeredLetterTest->size[0] = 50 + ixstart;
    centeredLetterTest->size[1] = 50;
    emxEnsureCapacity((emxArray__common *)centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      for (i1 = 0; i1 < 50; i1++) {
        centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0] =
          bitmapLetterTest[i1 + 50 * i0];
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = ixstart - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterTest->data[(i1 + centeredLetterTest->size[0] * i0) + 50] =
          0.0;
      }
    }
  }

  emxInit_real_T(&b_centeredLetterTest, 2);
  if (-x + 25.0 > 0.0) {
    y_size_idx_0 = centeredLetterTest->size[0];
    i0 = b_centeredLetterTest->size[0] * b_centeredLetterTest->size[1];
    b_centeredLetterTest->size[0] = y_size_idx_0;
    b_centeredLetterTest->size[1] = (int32_T)(-x + 25.0) + 50;
    emxEnsureCapacity((emxArray__common *)b_centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    loop_ub = (int32_T)(-x + 25.0) - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      ixstart = y_size_idx_0 - 1;
      for (i1 = 0; i1 <= ixstart; i1++) {
        b_centeredLetterTest->data[i1 + b_centeredLetterTest->size[0] * i0] =
          0.0;
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = centeredLetterTest->size[0] - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        b_centeredLetterTest->data[i1 + b_centeredLetterTest->size[0] * (i0 +
          (int32_T)(-x + 25.0))] = centeredLetterTest->data[i1 +
          centeredLetterTest->size[0] * i0];
      }
    }
  } else {
    y_size_idx_0 = centeredLetterTest->size[0];
    ixstart = (int32_T)fabs(-x + 25.0);
    i0 = b_centeredLetterTest->size[0] * b_centeredLetterTest->size[1];
    b_centeredLetterTest->size[0] = centeredLetterTest->size[0];
    b_centeredLetterTest->size[1] = 50 + ixstart;
    emxEnsureCapacity((emxArray__common *)b_centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = centeredLetterTest->size[0] - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        b_centeredLetterTest->data[i1 + b_centeredLetterTest->size[0] * i0] =
          centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0];
      }
    }

    loop_ub = ixstart - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      ixstart = y_size_idx_0 - 1;
      for (i1 = 0; i1 <= ixstart; i1++) {
        b_centeredLetterTest->data[i1 + b_centeredLetterTest->size[0] * (i0 + 50)]
          = 0.0;
      }
    }
  }

  if (-mtmp + 25.0 > 0.0) {
    i0 = centeredLetterTest->size[0] * centeredLetterTest->size[1];
    centeredLetterTest->size[0] = (int32_T)(-mtmp + 25.0) + 50;
    centeredLetterTest->size[1] = 50;
    emxEnsureCapacity((emxArray__common *)centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = (int32_T)(-mtmp + 25.0) - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0] = 0.0;
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      for (i1 = 0; i1 < 50; i1++) {
        centeredLetterTest->data[(i1 + (int32_T)(-mtmp + 25.0)) +
          centeredLetterTest->size[0] * i0] = bitmapLetterModel[i1 + 50 * i0];
      }
    }
  } else {
    ixstart = (int32_T)fabs(-mtmp + 25.0);
    i0 = centeredLetterTest->size[0] * centeredLetterTest->size[1];
    centeredLetterTest->size[0] = 50 + ixstart;
    centeredLetterTest->size[1] = 50;
    emxEnsureCapacity((emxArray__common *)centeredLetterTest, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      for (i1 = 0; i1 < 50; i1++) {
        centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0] =
          bitmapLetterModel[i1 + 50 * i0];
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = ixstart - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterTest->data[(i1 + centeredLetterTest->size[0] * i0) + 50] =
          0.0;
      }
    }
  }

  emxInit_real_T(&centeredLetterModel, 2);
  if (-b_mtmp + 25.0 > 0.0) {
    y_size_idx_0 = centeredLetterTest->size[0];
    i0 = centeredLetterModel->size[0] * centeredLetterModel->size[1];
    centeredLetterModel->size[0] = y_size_idx_0;
    centeredLetterModel->size[1] = (int32_T)(-b_mtmp + 25.0) + 50;
    emxEnsureCapacity((emxArray__common *)centeredLetterModel, i0, (int32_T)
                      sizeof(real_T));
    loop_ub = (int32_T)(-b_mtmp + 25.0) - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      ixstart = y_size_idx_0 - 1;
      for (i1 = 0; i1 <= ixstart; i1++) {
        centeredLetterModel->data[i1 + centeredLetterModel->size[0] * i0] = 0.0;
      }
    }

    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = centeredLetterTest->size[0] - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterModel->data[i1 + centeredLetterModel->size[0] * (i0 +
          (int32_T)(-b_mtmp + 25.0))] = centeredLetterTest->data[i1 +
          centeredLetterTest->size[0] * i0];
      }
    }
  } else {
    y_size_idx_0 = centeredLetterTest->size[0];
    ixstart = (int32_T)fabs(-b_mtmp + 25.0);
    i0 = centeredLetterModel->size[0] * centeredLetterModel->size[1];
    centeredLetterModel->size[0] = centeredLetterTest->size[0];
    centeredLetterModel->size[1] = 50 + ixstart;
    emxEnsureCapacity((emxArray__common *)centeredLetterModel, i0, (int32_T)
                      sizeof(real_T));
    for (i0 = 0; i0 < 50; i0++) {
      loop_ub = centeredLetterTest->size[0] - 1;
      for (i1 = 0; i1 <= loop_ub; i1++) {
        centeredLetterModel->data[i1 + centeredLetterModel->size[0] * i0] =
          centeredLetterTest->data[i1 + centeredLetterTest->size[0] * i0];
      }
    }

    loop_ub = ixstart - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      ixstart = y_size_idx_0 - 1;
      for (i1 = 0; i1 <= ixstart; i1++) {
        centeredLetterModel->data[i1 + centeredLetterModel->size[0] * (i0 + 50)]
          = 0.0;
      }
    }
  }

  emxFree_real_T(&centeredLetterTest);
  b_correctCentroids(centeredLetterModel, &centroids_model_x, &centroids_model_y);
  b_correctCentroids(b_centeredLetterTest, &mtmp, &b_mtmp);
  for (i0 = 0; i0 < 49; i0++) {
    for (i1 = 0; i1 < 49; i1++) {
      c_centeredLetterTest[i1 + 49 * i0] = b_centeredLetterTest->data[((int32_T)
        (mtmp + (-24.0 + (real_T)i1)) + b_centeredLetterTest->size[0] *
        ((int32_T)(b_mtmp + (-24.0 + (real_T)i0)) - 1)) - 1];
    }
  }

  emxFree_real_T(&b_centeredLetterTest);
  for (i0 = 0; i0 < 49; i0++) {
    for (i1 = 0; i1 < 49; i1++) {
      b_centeredLetterModel[i1 + 49 * i0] = centeredLetterModel->data[((int32_T)
        (centroids_model_x + (-24.0 + (real_T)i1)) + centeredLetterModel->size[0]
        * ((int32_T)(centroids_model_y + (-24.0 + (real_T)i0)) - 1)) - 1];
    }
  }

  emxFree_real_T(&centeredLetterModel);

  /* subplot(2,2,1), imshow(bitmapLetterModel) */
  /* subplot(2,2,2), imshow(bitmapLetterTest) */
  /* subplot(2,2,3), imshow(rotated_model) */
  /* subplot(2,2,4), imshow(rotated_test) */
  c_anotherRotateImageWithoutImro(b_centeredLetterModel, dv1);
  c_sum(dv1, summodel);

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
  d_repmat(summodel, rotated_test);
  c_anotherRotateImageWithoutImro(c_centeredLetterTest, dv2);
  c_sum(dv2, dv3);
  c_repmat(dv3, rotated_model);
  for (i0 = 0; i0 < 3969; i0++) {
    b_rotated_model[i0] = rotated_model[i0] - rotated_test[i0];
    rotated_model[i0] = 0.0;
  }

  b_power(b_rotated_model, rotated_test);
  rotated_model[0] = rotated_test[0];
  for (ixstart = 0; ixstart < 62; ixstart++) {
    rotated_model[1 + ixstart] = rotated_test[1 + ixstart] +
      rotated_model[ixstart];
  }

  for (y_size_idx_0 = 0; y_size_idx_0 < 62; y_size_idx_0++) {
    rotated_model[63 * (1 + y_size_idx_0)] = rotated_test[63 * (1 + y_size_idx_0)]
      + rotated_model[63 * y_size_idx_0];
  }

  for (ixstart = 0; ixstart < 62; ixstart++) {
    for (y_size_idx_0 = 0; y_size_idx_0 < 62; y_size_idx_0++) {
      mtmp = rotated_model[ixstart + 63 * (1 + y_size_idx_0)];
      b_mtmp = rotated_model[ixstart + 63 * y_size_idx_0];
      centroids_model_x = rotated_model[(ixstart + 63 * y_size_idx_0) + 1];
      if ((b_mtmp <= centroids_model_x) || rtIsNaN(centroids_model_x)) {
        centroids_model_x = b_mtmp;
      }

      if ((mtmp <= centroids_model_x) || rtIsNaN(centroids_model_x)) {
        centroids_model_x = mtmp;
      }

      rotated_model[(ixstart + 63 * (1 + y_size_idx_0)) + 1] = rotated_test
        [(ixstart + 63 * (1 + y_size_idx_0)) + 1] + centroids_model_x;

      /*  this double Min construction improves in 10-fold the Speed-up. Thanks Sven Mensing */
    }
  }

  mtmp = summodel[0];
  for (ixstart = 0; ixstart < 62; ixstart++) {
    mtmp += summodel[ixstart + 1];
  }

  *DistR = rotated_model[3968] / mtmp;
}

/* End of code generation (dtwDistances.c) */
