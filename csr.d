import std.stdio;


/** struct representing Compressed Sparse Row Format Matrix
   
*/

struct csr_matrix(IndexType) {
   IndexType nrows;
   IndexType ncols;
   IndexType[] rowptr;
   IndexType[] colind;
   double[] data;
  
   /** computes the matrix-vect product 
   */
   void matvec(in double[] X, out double[] Y) {
    // loop on row 
    Y.length = nrows;
    foreach(i, ref elem ; Y){
        double sum = 0.0;
	foreach(j ; rowptr[i] .. rowptr[i+1])
	    sum += data[j] * X[colind[j]];
        elem = sum;
    }
}

};

unittest {
   /* example taken from scipy.sparse
   >>> rowptr = array([0,2,3,6])
   >>> colind = array([0,2,2,0,1,2])
   >>> val = array([1,2,3,4,5,6])
   >>> 
   matrix([[1, 0, 2],
          [0, 0, 3],
          [4, 5, 6]])
   **/

   ulong[]  a_row = [0, 2, 3, 6];
   ulong[]  a_col = [0, 2, 2, 0, 1, 2];
   double[] a_val = [1., 2., 3., 4., 5., 6.];
   auto a = csr_matrix!ulong(3, 3, a_row, a_col, a_val);
   auto x = [1., 1., 1.];
   auto y = x;
   a.matvec(x, y);
   assert( y == [3., 3., 15.]);
}

int main()
{
 return 0;
}

