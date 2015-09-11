/*
 * Compute_AbslAng_Chain.c
 *
 * Code generation for function 'Compute_AbslAng_Chain'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "Compute_AbslAng_Chain.h"
#include "dtwDistances_emxutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static real_T rt_atan2d_snf(real_T u0, real_T u1);

/* Function Definitions */
static real_T rt_atan2d_snf(real_T u0, real_T u1)
{
  real_T y;
  int32_T i4;
  int32_T i5;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else if (rtIsInf(u0) && rtIsInf(u1)) {
    if (u1 > 0.0) {
      i4 = 1;
    } else {
      i4 = -1;
    }

    if (u0 > 0.0) {
      i5 = 1;
    } else {
      i5 = -1;
    }

    y = atan2((real_T)i5, (real_T)i4);
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = atan2(u0, u1);
  }

  return y;
}

void Compute_AbslAng_Chain(const emxArray_real_T *PixC, emxArray_real_T
  *Abs_Angles)
{
  emxArray_real_T *DiffY;
  int32_T Angles;
  int32_T unnamed_idx_1;
  emxArray_real_T *DiffX;
  uint32_T uv0[2];
  emxArray_real_T *b_Angles;
  emxInit_real_T(&DiffY, 2);

  /*  added for codegen */
  Angles = DiffY->size[0] * DiffY->size[1];
  DiffY->size[0] = 1;
  emxEnsureCapacity((emxArray__common *)DiffY, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = PixC->size[0];
  Angles = DiffY->size[0] * DiffY->size[1];
  DiffY->size[1] = unnamed_idx_1;
  emxEnsureCapacity((emxArray__common *)DiffY, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = PixC->size[0] - 1;
  for (Angles = 0; Angles <= unnamed_idx_1; Angles++) {
    DiffY->data[Angles] = 0.0;
  }

  emxInit_real_T(&DiffX, 2);
  Angles = DiffX->size[0] * DiffX->size[1];
  DiffX->size[0] = 1;
  emxEnsureCapacity((emxArray__common *)DiffX, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = PixC->size[0];
  Angles = DiffX->size[0] * DiffX->size[1];
  DiffX->size[1] = unnamed_idx_1;
  emxEnsureCapacity((emxArray__common *)DiffX, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = PixC->size[0] - 1;
  for (Angles = 0; Angles <= unnamed_idx_1; Angles++) {
    DiffX->data[Angles] = 0.0;
  }

  /* for i=1:(size(PixC)-1) */
  for (unnamed_idx_1 = 0; unnamed_idx_1 <= PixC->size[0] - 2; unnamed_idx_1++) {
    DiffY->data[unnamed_idx_1] = PixC->data[unnamed_idx_1] - PixC->
      data[unnamed_idx_1 + 1];
    DiffX->data[unnamed_idx_1] = PixC->data[(unnamed_idx_1 + PixC->size[0]) + 1]
      - PixC->data[unnamed_idx_1 + PixC->size[0]];
  }

  for (Angles = 0; Angles < 2; Angles++) {
    uv0[Angles] = (uint32_T)DiffY->size[Angles];
  }

  emxInit_real_T(&b_Angles, 2);
  Angles = b_Angles->size[0] * b_Angles->size[1];
  b_Angles->size[0] = 1;
  b_Angles->size[1] = (int32_T)uv0[1];
  emxEnsureCapacity((emxArray__common *)b_Angles, Angles, (int32_T)sizeof(real_T));
  Angles = b_Angles->size[1];
  for (unnamed_idx_1 = 0; unnamed_idx_1 <= Angles - 1; unnamed_idx_1++) {
    b_Angles->data[unnamed_idx_1] = rt_atan2d_snf(DiffY->data[unnamed_idx_1],
      DiffX->data[unnamed_idx_1]);
  }

  emxFree_real_T(&DiffX);
  emxFree_real_T(&DiffY);

  /* Making All angles between 0 and 2*pi: */
  Angles = b_Angles->size[0] * b_Angles->size[1];
  b_Angles->size[0] = 1;
  b_Angles->size[1] = b_Angles->size[1];
  emxEnsureCapacity((emxArray__common *)b_Angles, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = b_Angles->size[1] - 1;
  for (Angles = 0; Angles <= unnamed_idx_1; Angles++) {
    b_Angles->data[b_Angles->size[0] * Angles] += (real_T)(b_Angles->
      data[b_Angles->size[0] * Angles] < 0.0) * 6.2831853071795862;
  }

  Angles = b_Angles->size[0] * b_Angles->size[1];
  b_Angles->size[0] = 1;
  b_Angles->size[1] = b_Angles->size[1];
  emxEnsureCapacity((emxArray__common *)b_Angles, Angles, (int32_T)sizeof(real_T));
  unnamed_idx_1 = b_Angles->size[0];
  Angles = b_Angles->size[1];
  unnamed_idx_1 = unnamed_idx_1 * Angles - 1;
  for (Angles = 0; Angles <= unnamed_idx_1; Angles++) {
    b_Angles->data[Angles] *= 57.295779513082323;
  }

  Angles = Abs_Angles->size[0] * Abs_Angles->size[1];
  Abs_Angles->size[0] = 1;
  Abs_Angles->size[1] = b_Angles->size[1];
  emxEnsureCapacity((emxArray__common *)Abs_Angles, Angles, (int32_T)sizeof
                    (real_T));
  unnamed_idx_1 = b_Angles->size[0] * b_Angles->size[1] - 1;
  for (Angles = 0; Angles <= unnamed_idx_1; Angles++) {
    Abs_Angles->data[Angles] = b_Angles->data[Angles];
  }

  for (unnamed_idx_1 = 0; unnamed_idx_1 <= b_Angles->size[1] - 1; unnamed_idx_1
       ++) {
    Abs_Angles->data[unnamed_idx_1] = floor(Abs_Angles->data[unnamed_idx_1]);
  }

  emxFree_real_T(&b_Angles);
}

/* End of code generation (Compute_AbslAng_Chain.c) */
