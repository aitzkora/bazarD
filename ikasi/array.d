import std.stdio;
import std.math;
import std.range;
import std.algorithm;
int main() {
   int m,n;
   readf("%d %d",&m, &n); 
   auto matrix = new double[][] (m,n);
   foreach(ref i ; matrix) { 
          i[] = map!(x=>x)(iota(0.0, 1.0, 0.1/n));
   }
   return 0;
}

