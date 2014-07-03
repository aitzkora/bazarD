#!/usr/bin/env rdmd
import std.stdio;

struct gauza {
    int[] val;
    this(int z) {
        val  = new int[1];
        val[0] = z;
        
    }
    this (this) {
         val = val.dup; 
     }
 }    

void main() {
    auto z = gauza(3);
    auto w = z;
    w.val[0] = 2;
    writeln(z.val[0]);  // writes 3
}
