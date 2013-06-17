import std.stdio;
import std.random;
import std.range;
import std.algorithm;
import std.typecons;

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
smc(alias init, alias  logl, alias evol,
    alias resa)(int T, double[] y, int N) {

  
    auto sum = (double[] x) => reduce!"a + b"(0.,x);
    
    auto x = new double[][](N, T);
    auto log_w = new double[][](N, T);
    auto w = new double[][](N, T);
    auto ess = new double[][](N, T);
    
    x[][0] = init(N); 
    log_w[][0] = logl(y[0], x[][0]);
    w[][0] = map!(exp)(log_w[][0]);

    auto w_sum = sum(w[][0]);
    w[][0]  /= w_sum;
    log_w[][0] -= log(w_sum);

    log_z = log_(w_sum);
    ess[0] = 1. / sum(map!(x=>x*x)(w[][0]));

    foreach(t ; 0 .. T) { 

        x[][t - 1]     = resample(w[][t - 1], x[][t - 1]);
        log_w[][t - 1] = -log(N);
        w[][t - 1]     = 1. / N;

        x[][t] = evol(x[][t - 1]);
        w[][t] = map!(exp)(log_w[][t]);

        w_sum = sum(w[][t]);
        w[][t] /= w_sum;
        log_w -= log(w_sum);

        log_z += log(w_sum);
        ess[t] = 1./ sum(map!(x=>x*x)(w[][t]));
    }

    return Tuple!(double[][], double[], double[], double)(x, w, ess, logz);
}                               
double sigma_u = 1.0;
auto measure = (double x) => x + sigma_u * uniform(0.0, 0.1);

double normal(uint N) {
    double x,y, w;
    do { 
        x = 2 * random(0.0, 1.0) - 1;
        y = 2 * random(0.0, 1.0) - 1;
        w = x * x + y * y;
    } while (w >= 1);
    w = sqrt((-2.0 * log(w))/w);
    return w;
}


auto mu_1 =1.0;
auto sigma_1 = 1.0;
auto init = (uint N) => mu_1 + sigma_1 * normal(N)[];

alias Tuple!(double[], double[]) pair_vector;

pair_vector gen_data(uint T) {
    auto x = new double[T];
    auto y = new double[T];
    x[0] = init(1);
    y[1] = measure(x[1]);
    foreach( t; 1 .. T) {
        x[t] = evol(x[t - 1]);
    }   y[t] = measure(x[t -1]);
    return pair_vector(x,y);
}

 
