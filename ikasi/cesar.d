#!/usr/bin/env rdmd
import std.ascii;
import std.range;
import std.stdio;
import std.algorithm;
import std.conv;

unittest {
  assert(cesar(10, "sed") == "con");
}

string cesar(in int clef, in string mess) {
    auto αβ = lowercase;
    auto décalé = cycle(αβ).drop(clef).take(26);
    auto dico = assocArray(zip(lowercase, décalé));
    auto codé = map!(x=>dico[x])(mess);
    return to!string(codé.array());
}

void main() {
    writeln(cesar(10, "sed"));
}
