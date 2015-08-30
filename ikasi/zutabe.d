#!/usr/bin/env rdmd
import std.stdio;

struct zutabe(T) {
    T[] datuak;
    this(uint neurria) { datuak = new T[neurria]; }
    this(this) { datuak = datuak.dup; }
    void opIndexAssign(T val, uint i) { datuak[i] = val; } 
    T opIndex(uint i) { return datuak[i]; }
}

void main() {
     zutabe!double nire_zutabe;
     foreach(i; 0 .. 3) {
             nire_zutabe[i] = cast(double)(i);
     }
}
