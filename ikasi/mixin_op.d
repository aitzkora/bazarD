#!/usr/bin/env rdmd
import std.stdio;

static if ([2].ptr.sizeof == 8) 
    enum bool_64 = true;
else    
    enum  bool_64=false;
