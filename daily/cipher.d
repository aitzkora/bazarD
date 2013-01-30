#!/home/fux/sources/dmd2/linux/bin64/rdmd
import std.stdio;
import std.range;
import std.array;
import std.algorithm;
import std.string;

void eval_cipher(string code) {
   auto id = "abcdefghijklmnopqrstuvwxyz";
   assert(code.length == id.length);
   // build a dict
   dchar [dchar] cipher;
   foreach(w; zip(id,code)) cipher[w[0]] = w[1];
   
   foreach(word; File("6letter.txt","r").byLine()) {
      auto word_cipher = translate(word.chomp(), cipher);
      //if (sort(word_cipher) == word_cipher) 
      //   write(word_cipher);
   }
}
int main() {
  dchar [] a = ['a','c','b'];
  write(sort(a));
  eval_cipher(stdin.readln().chomp()); 
  return 0;
}
    
