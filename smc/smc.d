import std.stdio;
import std.random;
import std.range;
import std.algorithm;

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
}

double[] resample(in double []  w, double [] x) {
   assert(x.length == w.length);
   auto W = cumsum(w);
   auto u = map!(a=>uniform(0.0, 1.0))(w).array();
   auto idx = new int[w.length];
   foreach(i, uu ; u ) {
      foreach(j, ww ; W) {
         idx[i] += (uu > ww) ? 1 : 0;
      }
   }
   return map!(a=>x[a])(idx).array();
}


Tuple!(double[][], double[]) smc(alias init, alias  logl, alias evol,
                                 alias resa)(int T, double[] y, int N) {

  
    auto x = new double[][](N, T);
    auto log_w = new double[][](N, T);
    auto w = new double[][](N, T);
    auto ess = new double[][](N, T);
    
    x[][0] = init(N); 
    log_w[][0] = logl(y[0], x[][0]);




}                               
 
