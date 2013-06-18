import std.stdio;
import std.random;
import std.range;
import std.algorithm;
import std.typecons;
import std.math;

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


Tuple!(double[][], double[], double[], double)
smc(alias init, alias logl, alias evol, alias resa)
    (uint T, double[] y, uint N) {

  
    auto sum = (double[] x) => reduce!"a + b"(0.,x);
    
    auto x = new double[][](T, N);
    auto log_w = new double[][](T, N);
    auto w = new double[][](T, N);
    auto ess = new double[][](T, N);
    
    x[0][] = init(N); 
    log_w[0][] = logl(y[0],x[0][]);
    w[0][] = map!(exp)(log_w[0][]).array();

    auto w_sum = sum(w[0][]);
    w[0][]  /= w_sum;
    log_w[0][] -= log(w_sum);

    auto log_z = log(w_sum);
    ess[0] = 1. / sum(map!(x=>x*x)(w[0][]).array());

    foreach(t ; 0 .. T) { 

        x[t - 1][]     = resample(w[t - 1][], x[t - 1][]);
        log_w[t - 1][] = -log(N);
        w[t - 1][]     = 1. / N;

        // mutation
        x[t][] = map!(evol)(x[t - 1][]).array();
        
        // weights computation
        log_w[t][] = log_w[t - 1][] + map!"logl(y[t],a)"(x[t][]);
        w[t][] = map!(exp)(log_w[t][]);

        w_sum = sum(w[t][]);
        w[t][] /= w_sum;
        log_w -= log(w_sum);

        log_z += log(w_sum);
        ess[t] = 1./ sum(map!(x=>x*x)(w[t][]));
    }

    return Tuple!(double[][], double[], double[], double)(x, w, ess, logz);
}                               


double normal() {
    double x,y, w;
    do { 
        x = 2 * uniform(0.0, 1.0) - 1;
        y = 2 * uniform(0.0, 1.0) - 1;
        w = x * x + y * y;
    } while (w >= 1);
    w = sqrt((-2.0 * log(w))/w);
    return w;
}

alias Tuple!(double[], double[]) pair_vector;

pair_vector gen_data(alias init, alias measure, alias evol)(uint T) {
    auto x = new double[T];
    auto y = new double[T];
    x[0] = init(1)[0];
    y[1] = measure(x[1]);
    foreach( t; 1 .. T) {
        x[t] = evol(x[t - 1]);
        y[t] = measure(x[t -1]);
    }   
    return pair_vector(x,y);
}


int main() {
   uint t_final = 20;
   uint N = 1000;
   auto mu_1 =1.0;
   auto sigma_1 = 1.0;
   auto sigma_u = 1.0;
   auto sigma_v = 1.0;
   auto pi = 3.1415926535897; 
   auto init = (uint N) => map!(x=> mu_1 + sigma_1 * normal())(iota(0,N)).array();
   auto evol = (double x) => x + sigma_u * normal();
   auto measure = (double x) => x + sigma_v * normal();
   auto logl = (double x, double[] y) => map!(a=>-0.5 * log(2 * pi) - log(sigma_v) - 0.5 * ((a - x)/sigma_v)^^2)(y).array();
   
   auto z = gen_data!(init, measure, evol)(t_final);
   auto res = smc!(init, logl, evol, resample)(t_final, z[1], N);
   return 0; 
}
