#!/usr/bin/env rdmd
import std.range;
import std.stdio;
import std.algorithm;
import std.parallelism;
import std.conv;
import std.datetime;

unittest {
   double b[] = [1., 2., 4.];
   assert(sumk2(3)==(1/b[0]/b[0]+1./b[1]/b[1]+1./b[2]/b[2]));
}

auto sumk2(int n) {
  auto numbers = iota(1.,to!double(n+1));
  auto carres = map!"1/(a*a)"(numbers);
  return taskPool.reduce!"a+b"(carres);
  //return reduce!"a+b"(carres);
}

int main() {
 auto z = sumk2(1000000000);
 return 0;
}
