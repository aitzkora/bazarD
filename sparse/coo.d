import std.algorithm;
import std.range;
import std.typecons;
import std.stdio;

struct coo_matrix(Index) {
   Index nrows;
   Index ncols;
   Index[] I;
   Index[] J;
   double[] V;
   
   this(Index m, Index n) {
     nrows = m;
     ncols = n;
   }

   void add_entries(in Index[] rows, in Index[] cols, in double[] vals) {
      I = I ~ rows;
      J = J ~ cols;
      V = V ~ vals;
   }

   Index nnz() {  
      return (V == null) ? Index.init : cast(Index)count(uniq(sort(zip(I,J))));
   }     
  
   void sumIndex() {
      alias Tuple!(Index,Index) pair;
      double[pair] assoc;
      // insertion dans assoc
      foreach(z; zip(I,J,V)) {
            assoc[pair(z[0],z[1])] += z[2];
      }
      int i = 0;
      I.length = assoc.keys.length;
      J.length = assoc.keys.length;
      V.length = assoc.keys.length;

      foreach(z; sort(assoc.keys)) {
          I[i] = z[0];
	  J[i] = z[1];
	  V[i] = assoc[z];
	  i++;
      }	 
   }


};

unittest {

   auto zero = coo_matrix!ulong(10,10);
   assert( zero.nnz() == 0);
   zero.add_entries([1, 1], [1,1], [2, 3]);
   assert( zero.nnz() == 1);
   zero.sumIndex();
   assert( zero.nnz() == 1);
   assert(zero.I == [1]);
   assert(zero.J == [1]);
   assert(zero.V == [5]);
}
