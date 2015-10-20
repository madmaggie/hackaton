/*
 * dtwDistances_types.h
 *
 * Code generation for function 'dtwDistances'
 *
 * C source code generated on: Fri Jul 31 13:55:48 2015
 *
 */

#ifndef __DTWDISTANCES_TYPES_H__
#define __DTWDISTANCES_TYPES_H__

/* Type Definitions */
#ifndef struct_emxArray__common
#define struct_emxArray__common
typedef struct emxArray__common
{
    void *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
} emxArray__common;
#endif
#ifndef struct_emxArray_boolean_T_1x6000
#define struct_emxArray_boolean_T_1x6000
typedef struct emxArray_boolean_T_1x6000
{
    boolean_T data[6000];
    int32_T size[2];
} emxArray_boolean_T_1x6000;
#endif
#ifndef struct_emxArray_int32_T_6000
#define struct_emxArray_int32_T_6000
typedef struct emxArray_int32_T_6000
{
    int32_T data[6000];
    int32_T size[1];
} emxArray_int32_T_6000;
#endif
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
typedef struct emxArray_real_T
{
    real_T *data;
    int32_T *size;
    int32_T allocatedSize;
    int32_T numDimensions;
    boolean_T canFreeData;
} emxArray_real_T;
#endif
#ifndef struct_emxArray_real_T_2x3000
#define struct_emxArray_real_T_2x3000
typedef struct emxArray_real_T_2x3000
{
    real_T data[6000];
    int32_T size[2];
} emxArray_real_T_2x3000;
#endif
#ifndef struct_emxArray_real_T_3000x2
#define struct_emxArray_real_T_3000x2
typedef struct emxArray_real_T_3000x2
{
    real_T data[6000];
    int32_T size[2];
} emxArray_real_T_3000x2;
#endif

#endif
/* End of code generation (dtwDistances_types.h) */
