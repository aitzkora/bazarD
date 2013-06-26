import std.stdio;
import scid.matrix;
import std.algorithm;

auto hilbert(uint n) {
   auto H = matrix!real(n, n);
   foreach(i ; 0 .. H.rows) {
      foreach(j ; 0 .. H.rows) {
             H[i,j] = 1. / (i + j +1.); 
      }
   }
   return H;
}


int main() {
  uint n = 4;
  auto H = hilbert(n);
  writeln(H);
  return 0;
}
