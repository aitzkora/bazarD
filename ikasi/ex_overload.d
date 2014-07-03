#!/usr/bin/env rdmd
import std.stdio;

struct gauza {
    private int[] taula;
    this(uint size) {
        taula  = new int [size];
    }
    this (this) {
         taula = taula.dup; 
     }
     int opIndex(uint i) {
         return taula[i];
     }    
     
     void opIndexAssign(int c, uint i) {
         taula[i] = c;
     }    
 }    

int main() {
    auto z = gauza(12);
    z[3]=4;
    auto w = z;
    writeln(w);
    return 0;
}
