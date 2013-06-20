import std.stdio;
import std.random;
import std.range;
import std.algorithm;
import std.typecons;
import std.math;

alias double[][] matrix;
alias double[] vector;
alias Tuple!(vector, vector) pair_vector;

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

vector resample(in vector w, vector x) {
   assert(x.length == w.length);
   auto W = cumsum(w);
   auto u = map!(a=>uniform(0.0, 1.0))(w).array();
   auto idx = new int[w.length];
   foreach(i, uu ; u ) {
      foreach(ww ; W) {
         idx[i] += (uu > ww) ? 1 : 0;
      }
   }
   return map!(a=>x[a])(idx).array();
}


Tuple!(matrix, matrix, vector, double)
smc(alias init, alias logl, alias evol, alias resa)
    (uint T, vector y, uint N) {

  
    auto sum = (vector x) => reduce!"a + b"(0.,x);
    auto expv = (vector v) => map!(exp)(v).array();
    auto sqr = (vector v) => map!"a*a"(v).array();

    auto x = new matrix(T, N);
    auto log_w = new matrix(T, N);
    auto w = new matrix(T, N);
    auto ess = new double[T];
    
    x[0][] = init(N); 
    log_w[0][] = logl(y[0],x[0][])[];
    w[0][] = expv(log_w[0][]);

    auto w_sum = sum(w[0][]);
    w[0][]  /= w_sum;
    log_w[0][] -= log(w_sum);

    auto log_z = log(w_sum);
    ess[0] = 1. / sum(sqr(w[0][]));

    foreach(t ; 1 .. T) { 

        x[t - 1][]     = resample(w[t - 1][], x[t - 1][]);
        log_w[t - 1][] = -log(N);
        w[t - 1][]     = 1. / N;

        // mutation
        x[t][] = evol(x[t - 1][]);
        
        // weights computation
        log_w[t][] = log_w[t - 1][] + logl(y[t],x[t][])[];
        w[t][] = expv(log_w[t][]);

        w_sum = sum(w[t][]);
        w[t][] /= w_sum;
        log_w[t][] -= log(w_sum);

        log_z += log(w_sum);
        ess[t] = 1./ sum(sqr(w[t][]));
    }

    return Tuple!(matrix, matrix, vector, double)(x, w, ess, log_z);
}                               

struct normal {
    immutable double pi = 3.14159265358979323846;
    bool valid = false;
    double rho = 0;
    double x,y;
    double front() @property {
       if(!valid) { 
          x = uniform(0.0, 1.0);
          y = uniform(0.0, 1.0);
          rho = sqrt( - 2.0 * log(1.-y));
          valid = true;
       }
       else
          valid = false;
       return rho * (valid ? cos(2.*pi*x) : sin(2.*pi*x));  
    }
    void popFront() {};
    
    enum bool empty = false;
 
    typeof(this) save() @property { return this; }
};


pair_vector gen_data(alias init, alias measure, alias evol)(uint T) {
    auto x = new double[T];
    auto y = new double[T];
    x[0] = init(1)[0];
    y[1] = measure(x[1]);
    foreach( t; 1 .. T) {
        x[t] = evol([x[t - 1]])[0];
        y[t] = measure(x[t -1]);
    }   
    return pair_vector(x,y);
}


int main() {
   uint t_final = 20;
   uint N = 10000;
   auto mu_1 =1.0;
   auto sigma_1 = 1.0;
   auto sigma_u = 1.0;
   auto sigma_v = 1.0;
   auto pi = 3.1415926535897; 
   normal gauss;
   
   auto init = (uint N) => map!(x=> mu_1 + sigma_1 * gauss.front())(iota(0,N)).array();
   
   auto evol = (vector x) =>  map!(a=> a + sigma_u * gauss.front())(x).array(); 
   
   auto measure = (double x) => x + sigma_v * gauss.front(); 
  
   auto offset =  cast(double)( -0.5 * log(2 * pi) - log(sigma_v)); 
   auto logl = (double x, vector y) => map!(a=> offset - 0.5 * ((a - x)/sigma_v)^^2)(y).array(); 
   
   auto z = gen_data!(init, measure, evol)(t_final);
   auto res = smc!(init, logl, evol, resample)(t_final, z[1], N);
   return 0; 
}
