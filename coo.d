import std.algorithm;
import std.range;
import std.typecons;

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
      J = J ~ rows;
      V = V ~ vals;
   }

   Index nnz() {  
      return (V == null) ? 0 : count(uniq(sort(zip(I,J))));
   }     
  
   void sumIndex() {
      alias Tuple!(Index,Index) pair;
      double[pair] assoc;
      foreach(z; zip(I,J,V)) {
            assoc[pair(z[0],z[1])] += z[2];
      }
      I = array(map!"a[0]"(assoc.keys));
      J = array(map!"a[1]"(assoc.keys));
      V = array(assoc.values);
   }


};

unittest {

   auto zero = coo_matrix!ulong(10,10);
   assert( zero.nnz() == 0);
   zero.add_entries([1, 1], [1,1], [2, 3]);
   assert( zero.nnz() == 1);
//   zero.add_entries(array(iota(10UL)),
//                    array(iota(10UL)),
//		    array(repeat(1.0)));
   zero.sumIndex();
   assert(zero.I == [1]);
   assert(zero.J == [1]);
   assert(zero.V == [5]);
}
