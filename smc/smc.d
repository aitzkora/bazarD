import std.stdio;
import std.random;

T[] cumsum(T)(T[] x) {
    auto y = x.dup;
    foreach(i; 1 .. x.length) {
         y[i] += y[i-1];
    }
    return y;
}    

unittest {
  int[] z = [1, 4, 3];
  assert(cumsum!(int)(z) == [1, 5, 8]);
};

double[] resample(double [] w, double [] x) {
   assert(x.length == w.length);
   auto W = cumsum(w);
   auto u = w.dup 
   foreach(ref r ; u) {
       r = random(0.0, 1.0);
   }
   int idx = new int[w.length];
   foreach(i, uu ; u ) {
      foreach(j, ww ; W) {
         idx[i] += (uu > ww) ? 1 ; 0;
      }
   }
    
}
