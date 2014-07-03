#!/usr/bin/env rdmd
import std.stdio;

void main() {
   
   auto a = new double[10];
   foreach(int i, ref z; a) {
           z = cast(double)(i);
   }
  writeln(a);
}
