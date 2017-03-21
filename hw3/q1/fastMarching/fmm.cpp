#include "fmm.h"
#include "fheap/fib.h"
#include "fheap/fibpriv.h"

// variables 
int num_rows;			//F rows
int num_cols;			//F cols
double* F = NULL; 		//Weights of all matrix cells

double* T = NULL; //distances
mxArray* T_iter = NULL; // distances for each iteration
Color* S = NULL;
double* src = NULL;		// input sources points (x,y)
int num_src_points = 0;	// #sources
double* t0 = NULL;		//src points initial values.
int max_iterations = 20000000; //limit the number of iterations
fibheap_el** fb_heap = NULL;	// use the included library for creating fibonacci heap.
int display_mode = 0; // 0 - silent and 1 - iter

#define GET_ELEMENT(a,i,j) a[(i)+num_rows*(j)] //i=column j=row column wise matlab.
#define src_points_(i,k) src[(i)+2*(k)]
#define F_(i,j) GET_ELEMENT(F,i,j)
#define T_(i,j) GET_ELEMENT(T,i,j)
#define fb_heap_(i,j) GET_ELEMENT(fb_heap,i,j)
#define S_(i,j) GET_ELEMENT(S,i,j)
#define T_iter_(i,j) GET_ELEMENT(mxGetPr(T_iter),i,j)

using namespace std;

struct Vertex_2D
{
	int i, j;
	Vertex_2D(int _i, int _j){
		i = _i;
		j = _j;
	}
};

typedef vector<Vertex_2D*> vertices;

inline
int compare_points(void *x, void *y)
{
	Vertex_2D& p1 = *((Vertex_2D*)x);
	Vertex_2D& p2 = *((Vertex_2D*)y);
	return cmp(T_(p1.i, p1.j), T_(p2.i, p2.j));
}

void iter_mode(int i,int j,Color state)
{
	switch (state) {
        case Black:
            mexPrintf("\n(%d,%d) is Black\n", i, j);
            break;
        case Red:
            mexPrintf("\n(%d,%d) is Red\n", i, j);
            break;
        case Green:
            mexPrintf("\n(%d,%d) is Green\n", i, j);
            break;
    }
	mexPutVariable("caller", "TT",T_iter );
	mexEvalString("imshow(colorDistanceMap(TT),'InitialMagnification','fit'); drawnow;");
}


void fmm()
{
	struct fibheap* fibonacciHeap = fh_makeheap();
	fh_setcmp(fibonacciHeap, compare_points);
	T_iter = mxCreateDoubleMatrix(num_rows, num_cols, mxREAL);
	double h = 1.0;

	for (int i = 0; i < num_rows; ++i)
	for (int j = 0; j < num_cols; ++j)
	{
		T_(i, j) = INF;
		T_iter_(i, j) = INF;
		S_(i, j) = Green;
	}

	fb_heap = new fibheap_el*[num_rows*num_cols];
	memset(fb_heap, NULL, num_rows*num_cols*sizeof(fibheap_el*));
	vertices checked_vertices;
	for (int k = 0; k < num_src_points; ++k)
	{
		int i = (int)src_points_(0, k);
		int j = (int)src_points_(1, k);
		Vertex_2D* v = new Vertex_2D(i, j);
		checked_vertices.push_back(v);
		fb_heap_(i, j) = fh_insert(fibonacciHeap, v);
		T_(i, j) = t0[k];
		T_iter_(i, j) = t0[k];
		S_(i, j) = Red;
		if (display_mode==1)
			iter_mode(i, j, Red);
	}
	int iter_number = 0;
	while (!fh_isempty(fibonacciHeap) && iter_number < max_iterations)
	{
		iter_number++;
		Vertex_2D& cur_point = *((Vertex_2D*)fh_extractmin(fibonacciHeap));
		int i = cur_point.i;
		int j = cur_point.j;
		fb_heap_(i, j) = NULL;
		S_(i, j) = Black;
		if (display_mode==1)
			iter_mode(i, j, Black);
		int neighbor_i[4] = { i + 1, i, i - 1, i };
		int neighbor_j[4] = { j, j + 1, j, j - 1 };
		for (int k = 0; k < 4; ++k)
		{
			int ii = neighbor_i[k];
			int jj = neighbor_j[k];
			if (ii < 0 || jj < 0 || ii >= num_rows || jj >= num_cols)
				continue;
			double FH = h / F_(ii, jj);
			double t1 = INF;
			if (ii<num_rows - 1)
			{
				t1 = T_(ii + 1, jj);
			}
			if (ii>0)
			{
				t1 = MIN(t1, T_(ii - 1, jj));
			}
			double t2 = INF;
			if (jj<num_cols - 1)
			{
				t2 = T_(ii, jj + 1);
			}
			if (jj>0)
			{
				t2 = MIN(t2, T_(ii, jj - 1));
			}
			double T3 = 0;
			if (FH*FH > (t2 - t1)*(t2 - t1))
			{
				double s = 2 * FH*FH - (t2 - t1)*(t2 - t1);
				T3 = (t1 + t2 + sqrt(s)) / 2.0;
			}
			else
				T3 = MIN(t1, t2) + FH;
			if (((int)S_(ii, jj)) == Black)
			{
				if (T3 < T_(ii, jj))
				{
					T_(ii, jj) = T3;
					T_iter_(ii, jj) = T3;
				}
			}
			else if (((int)S_(ii, jj)) == Red)
			{
				if (T3 < T_(ii, jj))
				{
					T_(ii, jj) = T3;
					T_iter_(ii, jj) = T3;
					fibheap_el* cur_el = fb_heap_(ii, jj);
					if (cur_el != NULL)
						fh_replacedata(fibonacciHeap, cur_el, cur_el->fhe_data);
				}
			}
			else if (((int)S_(ii, jj)) == Green)
			{
				S_(ii, jj) = Red;
				if (display_mode==1)
					iter_mode(ii, jj, Red);
				T_(ii, jj) = T3;
				T_iter_(ii, jj) = T3;
				Vertex_2D* pt = new Vertex_2D(ii, jj);
				checked_vertices.push_back(pt);
				fb_heap_(ii, jj) = fh_insert(fibonacciHeap, pt);
			}
		}
	}
	fh_deleteheap(fibonacciHeap);
	for (vertices::iterator it = checked_vertices.begin(); it != checked_vertices.end(); ++it)
		DELETE_POINTER(*it);
	DELETE_ARRAY(fb_heap);
}