#ifndef _fmm_h_
#define _fmm_h_

#include <stdio.h>
#include <vector>
#include <algorithm>
#include <string.h>
#include <math.h>
#include "mex.h"

#define INF 1e7
// deletes a single pointer.
#define DELETE_POINTER(n) {if (n!=NULL) delete n; n=NULL;}
// deletes an array pointer.
#define DELETE_ARRAY(n) {if (n!=NULL) delete [] n; n=NULL;}
// returns min number between two points.
#define	MIN(a, b) ((a) < (b) ? (a) : (b))

inline
int cmp(double a, double b)
{
	if (a < b)
		return -1;
	if (a == b)
		return 0;
	return 1;
}

enum Color {Black = -1, Red = 0, Green = 1};

//global variables
extern int num_rows;
extern int num_cols;
extern double* F;
extern double* T;
extern mxArray* T_iter;
extern double* src;
extern int num_src_points;
extern double* t0;
extern int display_mode; //1= iter mode  0= silent mode (default)
extern Color* S;
extern int max_iterations;

// main function
void fmm();

#endif 