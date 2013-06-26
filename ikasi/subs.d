#!/usr/bin/env rdmd
import std.regex;
import std.stdio;

/* basic replacing with regular expressions
*/

int main() {

   auto z = "main.c compile.c";
   assert(replace(z, regex("\\.c", "g"), ".o") == "main.o compile.o");
   auto z2 = "/path/to/main.c debilos/hihi.c //";
   foreach( s ; splitter(z2, regex(" "))) {
          writeln(replace(s, regex(".*/", "g"), ""));
   }
   return 0;
}
