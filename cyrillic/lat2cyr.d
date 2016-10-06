#!/usr/bin/env rdmd
import std.range;
import std.stdio;
import std.array;
import std.string;
unittest {
  assert(lat2cyr("ne znam") == "нe знам" );
  assert(lat2cyr("Anđela gorovi srpskohrvatski") == "Anђeлa гoрoви cpпckoxpватcки" );
}

string lat2cyr(in string mess) {
     auto double_sub = mess.replace("dž","џ").replace("DŽ", "Џ")
                           .replace("lj", "љ").replace("LJ", "Љ")
                           .replace("nj", "њ").replace("NJ", "Њ");
    auto cyr_uni = "абвгдђежзијклмнопрстћуфхцчшАБВГДЂЕЖЗИЈКЛМНОПРСTЋУФХЦЧШ";
    auto lat_uni = "abvgdđežzijklmnoprstćufhcčšABVGDĐEŽZIJKLMNOPRSTĆUFHCČŠ";
    auto cyr_mess = tr(double_sub, lat_uni, cyr_uni);
    return cyr_mess;
}

void main() {
  foreach(line; stdin.byLineCopy)
  {
   writeln(lat2cyr(line));
  }
}
