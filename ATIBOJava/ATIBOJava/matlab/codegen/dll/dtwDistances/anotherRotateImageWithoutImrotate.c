/*
 * anotherRotateImageWithoutImrotate.c
 *
 * Code generation for function 'anotherRotateImageWithoutImrotate'
 *
 * C source code generated on: Fri Jul 31 13:55:49 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "anotherRotateImageWithoutImrotate.h"
#include "dtwDistances_rtwutil.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void c_anotherRotateImageWithoutImro(const real_T image[2401], real_T imagerot
  [3969])
{
  int32_T i;
  int32_T j;
  int32_T x;
  int32_T b_x;

  /*  Rotates image with angle */
  /*  image - 50x50 bitmap letter (b&w image) */
  /*  angle - the angle, a double between [0,360], that the image is rotated */
  /*  with, in clockwise direction */
  /*  imagerot - rotated image; square matrix with dimenstions computed as */
  /*  needed */
  /*  Copyright 2013-2015 Atibo */
  /*  define an array with calculated dimensions and fill the array  with zeros ie.,black */
  memset(&imagerot[0], 0, 3969U * sizeof(real_T));

  /* calculating center of original and final image */
  for (i = 0; i < 49; i++) {
    for (j = 0; j < 49; j++) {
      if (image[i + 49 * j] > 0.0) {
        x = (int32_T)rt_roundd_snf(((1.0 + (real_T)i) - 25.0) *
          0.93969262078590843 + ((1.0 + (real_T)j) - 25.0) * -0.3420201433256686)
          + 25;
        b_x = (int32_T)rt_roundd_snf(-((1.0 + (real_T)i) - 25.0) *
          -0.3420201433256686 + ((1.0 + (real_T)j) - 25.0) * 0.93969262078590843)
          + 25;
        if ((x >= 1) && (b_x >= 1) && (x <= 49) && (b_x <= 49)) {
          imagerot[(x + 63 * (b_x - 1)) - 1] = 1.0;
        }
      }
    }
  }

  /* imshow(C); */
}

/* End of code generation (anotherRotateImageWithoutImrotate.c) */
