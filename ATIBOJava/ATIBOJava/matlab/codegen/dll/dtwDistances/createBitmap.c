/*
 * createBitmap.c
 *
 * Code generation for function 'createBitmap'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dtwDistances.h"
#include "createBitmap.h"
#include "round.h"
#include "round80.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void createBitmap(const real_T letter_data[6000], const int32_T letter_size[2],
                  real_T bitmapLetter[2500])
{
  real_T border[4];
  int32_T ix;
  int32_T ixstart;
  real_T mtmp;
  boolean_T exitg4;
  boolean_T exitg3;
  boolean_T exitg2;
  boolean_T exitg1;
  int32_T xcoord_size[2];
  real_T xcoord_data[3000];
  int32_T ycoord_size[2];
  real_T ycoord_data[3000];
  real_T b_bitmapLetter[2500];

  /*  function receives raw coordinates of a letter and creates a bitmap of the */
  /*  letter */
  /*  letter: (x,y) coordinates of the letter - 2*N matrix */
  /*        letter(1,:) - all x coordinates */
  /*        letter(2,:) - all y coordinates */
  /*  bitmapLetter: xp*yp matrix with 1s and 0s */
  /*  Copyright 2013-2015 Atibo */
  /*  width & height of the grid */
  /*  witdh - distance (in pixels) between two oblique lines */
  /*  height - distance (in pixels) between two horizontal lines */
  /*  25 & 35 are the values for the model letters written by Ana */
  /*  and for the letters acquired from 1st grade kids by Magda */
  /*  these are probably the final values so they are hardcoded here */
  /*  maybe a better idea would be to pass them as parameters to this function */
  /*  but for now, I leave them hardcoded here */
  /*  viewport coordinates */
  /*  bitmap letter */
  memset(&bitmapLetter[0], 0, 2500U * sizeof(real_T));

  /* border = |minx maxx| */
  /*          |miny maxy| */
  /* letter = letter'; */
  /*  minmax not available for codegen :( */
  /*  border = minmax(letter); */
  for (ix = 0; ix < 4; ix++) {
    border[ix] = 0.0;
  }

  ixstart = 1;
  mtmp = letter_data[0];
  if (letter_size[1] > 1) {
    if (rtIsNaN(letter_data[0])) {
      ix = 2;
      exitg4 = FALSE;
      while ((exitg4 == 0U) && (ix <= letter_size[1])) {
        ixstart = ix;
        if (!rtIsNaN(letter_data[letter_size[0] * (ix - 1)])) {
          mtmp = letter_data[letter_size[0] * (ix - 1)];
          exitg4 = TRUE;
        } else {
          ix++;
        }
      }
    }

    if (ixstart < letter_size[1]) {
      while (ixstart + 1 <= letter_size[1]) {
        if (letter_data[letter_size[0] * ixstart] < mtmp) {
          mtmp = letter_data[letter_size[0] * ixstart];
        }

        ixstart++;
      }
    }
  }

  border[0] = mtmp;

  /*  minx */
  ixstart = 1;
  mtmp = letter_data[0];
  if (letter_size[1] > 1) {
    if (rtIsNaN(letter_data[0])) {
      ix = 2;
      exitg3 = FALSE;
      while ((exitg3 == 0U) && (ix <= letter_size[1])) {
        ixstart = ix;
        if (!rtIsNaN(letter_data[letter_size[0] * (ix - 1)])) {
          mtmp = letter_data[letter_size[0] * (ix - 1)];
          exitg3 = TRUE;
        } else {
          ix++;
        }
      }
    }

    if (ixstart < letter_size[1]) {
      while (ixstart + 1 <= letter_size[1]) {
        if (letter_data[letter_size[0] * ixstart] > mtmp) {
          mtmp = letter_data[letter_size[0] * ixstart];
        }

        ixstart++;
      }
    }
  }

  border[2] = mtmp;

  /*  maxx */
  ixstart = 1;
  mtmp = letter_data[1];
  if (letter_size[1] > 1) {
    if (rtIsNaN(letter_data[1])) {
      ix = 2;
      exitg2 = FALSE;
      while ((exitg2 == 0U) && (ix <= letter_size[1])) {
        ixstart = ix;
        if (!rtIsNaN(letter_data[1 + letter_size[0] * (ix - 1)])) {
          mtmp = letter_data[1 + letter_size[0] * (ix - 1)];
          exitg2 = TRUE;
        } else {
          ix++;
        }
      }
    }

    if (ixstart < letter_size[1]) {
      while (ixstart + 1 <= letter_size[1]) {
        if (letter_data[1 + letter_size[0] * ixstart] < mtmp) {
          mtmp = letter_data[1 + letter_size[0] * ixstart];
        }

        ixstart++;
      }
    }
  }

  border[1] = mtmp;

  /*  miny */
  ixstart = 1;
  mtmp = letter_data[1];
  if (letter_size[1] > 1) {
    if (rtIsNaN(letter_data[1])) {
      ix = 2;
      exitg1 = FALSE;
      while ((exitg1 == 0U) && (ix <= letter_size[1])) {
        ixstart = ix;
        if (!rtIsNaN(letter_data[1 + letter_size[0] * (ix - 1)])) {
          mtmp = letter_data[1 + letter_size[0] * (ix - 1)];
          exitg1 = TRUE;
        } else {
          ix++;
        }
      }
    }

    if (ixstart < letter_size[1]) {
      while (ixstart + 1 <= letter_size[1]) {
        if (letter_data[1 + letter_size[0] * ixstart] > mtmp) {
          mtmp = letter_data[1 + letter_size[0] * ixstart];
        }

        ixstart++;
      }
    }
  }

  border[3] = mtmp;

  /*  maxy */
  border[1] = round80((border[1] - 10.0) / 35.0) * 35.0;

  /*  miny - first horizontal line above the letter */
  border[3] = border[1] + 175.0;

  /*  maxy-miny = 5*height */
  border[0] = round80((border[0] - 10.0) / 25.0) * 25.0;

  /*  minx - first oblique line at the left of the letter */
  border[2] = border[0] + 225.0;

  /*  maxx-minx = 9*width */
  mtmp = border[2] - border[0];
  xcoord_size[0] = 1;
  xcoord_size[1] = letter_size[1];
  ixstart = letter_size[1] - 1;
  for (ix = 0; ix <= ixstart; ix++) {
    xcoord_data[ix] = (letter_data[letter_size[0] * ix] - border[0]) * 50.0 /
      mtmp;
  }

  b_round(xcoord_data, xcoord_size);
  mtmp = border[3] - border[1];
  ycoord_size[0] = 1;
  ycoord_size[1] = letter_size[1];
  ixstart = letter_size[1] - 1;
  for (ix = 0; ix <= ixstart; ix++) {
    ycoord_data[ix] = (letter_data[1 + letter_size[0] * ix] - border[1]) * 50.0 /
      mtmp;
  }

  b_round(ycoord_data, ycoord_size);
  for (ixstart = 0; ixstart <= xcoord_size[1] - 1; ixstart++) {
    if ((xcoord_data[xcoord_size[0] * ixstart] > 0.0) &&
        (ycoord_data[ycoord_size[0] * ixstart] > 0.0)) {
      bitmapLetter[((int32_T)xcoord_data[xcoord_size[0] * ixstart] + 50 *
                    ((int32_T)ycoord_data[ycoord_size[0] * ixstart] - 1)) - 1] =
        1.0;
    }
  }

  for (ix = 0; ix < 50; ix++) {
    for (ixstart = 0; ixstart < 50; ixstart++) {
      b_bitmapLetter[ixstart + 50 * ix] = bitmapLetter[ix + 50 * ixstart];
    }
  }

  for (ix = 0; ix < 50; ix++) {
    memcpy(&bitmapLetter[50 * ix], &b_bitmapLetter[50 * ix], 50U * sizeof(real_T));
  }
}

/* End of code generation (createBitmap.c) */
