#include "fmm.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]) 
{ 
	if( nrhs<4 ) 
		mexErrMsgTxt("4 input arguments are required."); 
	if( nlhs<1 ) 
		mexErrMsgTxt("1 output arguments are required."); 

	// weights
	num_rows = mxGetM(prhs[0]); //rows
	num_cols = mxGetN(prhs[0]); //cols
	F = mxGetPr(prhs[0]); //data
	// second argument = src
	src = mxGetPr(prhs[1]);//data
	int src_points_rows = mxGetM(prhs[1]);  //rows
	num_src_points = mxGetN(prhs[1]); //cols
	if (num_src_points == 0 || src_points_rows != 2)
		mexErrMsgTxt("src points must be of size [2 X num_src_points]."); 
	// third argument= src inital values.
	t0 = mxGetPr(prhs[2]);
	if (t0 != NULL && (mxGetM(prhs[2]) != num_src_points || mxGetN(prhs[2]) != 1))
		mexErrMsgTxt("t0 must be of size [num_src_points x 1].");
	//  argument 4= display mode
	char *disp = mxArrayToString(prhs[3]);
	if (disp[0] == 'i') //iter
		display_mode = 1;
	else if (disp[0] == 's') //silent
		display_mode = 0;
		
		
	// first ouput = distance
	plhs[0] = mxCreateDoubleMatrix(num_rows, num_cols, mxREAL);
	T = mxGetPr(plhs[0]);
	S = new Color[num_rows*num_cols];
	// launch fmm
	fmm();
	DELETE_ARRAY(S);
	return;
}
