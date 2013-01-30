import std.stdio;
import std.typecons;
import std.algorithm;
import std.functional;

alias Tuple!(int,double, double, int) cle;
double [cle] cache;

double walk(int n, double L, double R, int p = 0) {
  if (n == 0)
    return p;
  auto key = cle(n, L, R, p);
  if (key !in cache) {
     auto EL = walk(n-1, L, R, p+1) -1;
     auto E0 = walk(n-1, L, R, p);
     auto ER = walk(n-1, L, R, max(p-1, 0)) +1;
     cache[key] = L * EL + R * ER + (1-L-R) * E0;
  }
  return cache[key]; 
}

double walk2(int n, double L, double R, int  p =0) {
alias memoize!walk2 mwalk2;
  return n == 0 ? p : (L * (walk2(n-1, L, R, p+1) -1)
                     + (1-R-L) * walk2(n-1, L, R, p)
                     + R * (walk2(n-1, L, R, max(p-1,0))+1));
}

int main() {
   writeln(walk(1,0.5,0.5));
   writeln(walk(4,0.5,0.5));
   writeln(walk(10,0.5,0.4));
   writeln(walk(1000,0.5,0.4));
   return 0;
}
