#!/usr/bin/env rdmd
import std.stdio;
import std.algorithm;
import std.conv;
import std.range;

auto irakurri_fitxa_bat(string fitxa) { 
   auto f = File(fitxa, "r");
   auto m = 0;
   double [] stock;
   foreach (lignes; f.byLine()) {
       foreach (z ; splitter(lignes, " ")) {
           stock ~= to!double(z);
       }
      m++;
   } 
   auto nb_ilarak = stock.length / m;
   return chunks(stock, nb_ilarak);
}
int main() {
  auto w = irakurri_fitxa_bat("fitxategia");
  writeln(w);
  return 0;
}
