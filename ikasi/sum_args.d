#!/usr/bin/env rdmd
import std.stdio;
import std.conv;
import std.algorithm;

void main(string [] args) {
    if (args.length < 2) {
        writefln("%s n", args[0]);
    }
    else {
       int n = to!int(args[1]);
       auto carres = new int[n];
       foreach(int i, ref x ; carres) x = i;
       writeln(reduce!"a+b"(carres));
    }
}
