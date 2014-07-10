#!/usr/bin/env rdmd
import std.stdio;
import std.variant;
import std.concurrency;

void un_thread()
{
    receive(
        (int i) { writeln("Received an int."); },
        (float f) { writeln("Received a float."); },
        (Variant v) { writeln("Received some other type."); }
    );
}

void main()
{
     auto tid = spawn(&un_thread);
     send(tid, 42);
}
