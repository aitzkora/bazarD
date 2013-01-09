import std.stdio;
import std.algorithm;
import std.array;
import coo;

/** struct representing Compressed Sparse Row Format Matrix
   
*/

struct csr_matrix(Index) {
   Index nrows;
   Index ncols;
   Index[] rowptr;
   Index[] colind;
   double[] data;
  
   
   this(Index m, Index n, Index[] r_ptr = null, 
                          Index[] c_ind = null,
			  double[] dat = null) {

        nrows = m;
	ncols = n;
	rowptr = r_ptr;
	colind = c_ind;
	data = dat;

   }
  
   this(coo_matrix!Index coo) {
       nrows = coo.nrows;
       ncols = coo.ncols;
       auto nnz = coo.nnz();
       rowptr = new Index[nrows];
       data = new double[nnz+1];
       colind = new Index[nnz+1]; 

       foreach (i ; coo.I) {
            rowptr[i]++;    
       }

       auto cumsum = function(Index x) {static Index y=0; y=y+x; return y;};
       rowptr = array(map!cumsum(rowptr));
       writeln(rowptr);

       //FIXME : finish to implement the conversion

   }

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
 auto haha = coo_matrix!ulong(2,2);
 haha.add_entries([1,1],[1,2],[2.,3.]);
 auto hoho = csr_matrix!ulong(haha); 
 return 0;
}

