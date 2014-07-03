#!/usr/bin/env rdmd
import std.stdio;
import std.array;
import std.range;
import std.conv;


struct nire_struct {
   int i;
   string s;
}


void main() {
 foreach(m; __traits(allMembers, nire_struct)) {
   writeln("m is ", m);
 }
}
