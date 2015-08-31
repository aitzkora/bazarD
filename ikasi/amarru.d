#!/usr/bin/env rdmd
import std.stdio;
import std.string;
import std.file;
import std.regex;


//unittest {
//   assert(cesar(1, "a") == "b");
//}

string amarru(in string text, in string kate) {
     auto lineak = splitLines(text);   
     auto r= regex("*" ~ kate ~ "*");  
     string stock;
     foreach(l ;  lineak) {  
          foreach ( expr; matchAll(l, r)) {
                 stock = cast(string) expr.hit;
                 writeln(expr.hit);
          }
     }     
  return stock; 
}

void main() {
   string s = "vi";
   string testua = readText("test_amarru.txt"); 
   auto z = amarru("test_amarru.txt", s);
   writeln(z); 
}

