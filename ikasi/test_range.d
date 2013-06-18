import std.range;
import std.stdio;
import std.algorithm;

void main() {
  auto f = () { static x = 0; return cast(double)(x++); };
  auto w = map!(x=>f())(iota(0.,10.)).array();
  w[] /= 2.;
  writeln(typeid(w));
  auto mat = new double[][](10,2);
  mat[3][] *=  2.;
  writeln(mat[0].length);
  writeln(w);
} 
