#!/home/fux/sources/dmd2/linux/bin64/rdmd
import std.stdio;
import std.range;
import std.array;
import std.algorithm;
import std.string;

void eval_cipher(string code) {
auto id = "abcdefghijklmnopqrstuvwxyz";
assert(code.length == id.length);
dchar [dchar] cipher;
foreach(w; zip(id,code)) { cipher[w[0]] = w[1];}
foreach(word; File("6letter.txt","r").byLine()) {
     auto word_cipher = translate(word.chomp(), cipher);
}
}
int main() {
  eval_cipher(stdin.readln().chomp()); 
  return 0;
}
    
