#!/usr/bin/env rdmd
import std.conv;
int fact(int n) {
    if (n == 0)
       return 1;
    return n * fact(n - 1);
}

string FactTaulaEgin(string izena, uint max = 100) {
  string emaitza = "immutable int["~to!string(max)~"] "
         ~izena~" = [";
  foreach(i ; 0 .. max) {
     emaitza ~= to!string(fact(i)) ~ ", ";
  }
  return emaitza ~ "];";  
}
void main() {
  mixin(FactTaulaEgin("la_mia_tavola", 10));
  assert(la_mia_tavola[8] == 40320);
}
