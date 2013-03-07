import std.stdio;
import std.typecons;
import std.algorithm;
import std.functional;
import std.parallelism;

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

void walk_para(int n, double L, double R, out double res, int p = 0) {
  if (n == 0) {
     res = p;
     return;
  }
     double EL, E0, ER;
     auto tache1 = task!(walk_para)(n-1, L, R, EL ,p+1);
     auto tache2 = task!(walk_para)(n-1, L, R, E0, p);
     taskPool.put(tache1);
     taskPool.put(tache2);
     walk_para(n-1, L, R, ER, max(p-1, 0));
     tache1.yieldForce; 
     tache2.yieldForce; 
     res = L * (EL -1) + R * (ER+1) + (1-L-R) * E0;
}


int main() {
   //writeln(walk(1,0.5,0.5));
   //writeln(walk(4,0.5,0.5));
   //writeln(walk(10,0.5,0.4));
   //writeln(walk(1000,0.5,0.4));
   double res1,res2;
   walk_para(10,0.5,0.4,res1);
   //walk_para(1000,0.5,0.4,res2);
   writeln(res1);
   //writeln(res2);
   return 0;
}
