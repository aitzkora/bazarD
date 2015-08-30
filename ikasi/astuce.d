#!/usr/bin/env rdmd
import std.stdio;
import std.string;

//unittest {
//   assert(cesar(1, "a") == "b");
//}

string amarru(in File fitxa,in string karakterak) {
        while (!fitxa.eof()) {
                string line = chomp(fitxa.readln('\n'));
                writeln("read line -> |", line);
        }
  return karakterak;
}

void main() {
   string s = "vi";
   File fitxategi_bat = File("","r"); 
   amarru(s, fitxategi_bat);
}
