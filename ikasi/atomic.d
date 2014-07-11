#!/usr/bin/env rdmd
import std.stdio;
import std.concurrency;
import core.thread;
import core.atomic;

shared int accu = 0;

void th_add(int i) {
      atomicOp!"+="(accu, i); 
}

void main() {
   foreach (i ; 0 .. 1000) {
     spawn(&th_add, i);
   }
   thread_joinAll();
   writeln(accu);
}
