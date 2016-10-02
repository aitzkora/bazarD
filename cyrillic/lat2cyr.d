#!/usr/bin/env rdmd
import std.ascii;
import std.range;
import std.stdio;
import std.algorithm;
import std.conv;

unittest {
  assert(lat2cyr("ne znam") == "нe знам" );
}

string lat2cyr(in string mess) {
    auto cyr_uni = "абвгдђежзијклмнопрсtћуфхцчш ";
    auto lat_uni = "abvgdđežzijklmnoprstćufhcčš ";
    auto dico = assocArray(zip(lat_uni, cyr_uni));
    auto codé = map!(x=>dico[x])(mess);
    return to!string(codé.array());
}

void main() {
    writeln(lat2cyr("anđela"));
}
