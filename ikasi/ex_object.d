#!/usr/bin/env rdmd
import std.stdio;

class gauza {
    int[] val;
    this(int z) {
        val  = new int[1];
        val[0] = z;
    }
 }    

void main() {
    auto z = new gauza(3);
    auto w = z;
    w.val[0] = 2;
    writeln(z.val[0]);  // writes 2 
}

