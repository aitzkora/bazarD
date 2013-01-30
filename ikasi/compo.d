import std.stdio;

T3 delegate(T1) comp(T1,T2,T3)(T3 function(T2) f, T2 function(T1) g) {
return delegate (T1 x) { return f(g(x));}; 
}

int main() {
  auto f = ((int x)=>cast(double)(x)+1.);
  auto g = ((int x)=>x*x);
  writefln("fog(3) = %f", comp(f,g)(3));
  return 0;
}

