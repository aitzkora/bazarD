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
    auto dž_sub = mess.replace("dž","џ");
    auto lj_sub = dž_sub.replace("lj", "љ");
    auto nj_sub = lj_sub.replace("nj", "њ");
    auto DŽ_sub = nj_sub.replace("DŽ", "Џ");
    auto LJ_sub = DŽ_sub.replace("LJ", "Љ");
    auto NJ_sub = LJ_sub.replace("NJ", "Њ");
    auto cyr_uni = "абвгдђежзијклмнопрстћуфхцчш";
    auto lat_uni = "abvgdđežzijklmnoprstćufhcčš";
    auto cyr_mess = tr(NJ_sub, lat_uni, cyr_uni);
    auto CYR_uni = "АБВГДЂЕЖЗИЈКЛМНОПРСTЋУФХЦЧШ";
    auto LAT_uni = "ABVGDĐEŽZIJKLMNOPRSTĆUFHCČŠ";
    auto CYR_mess = tr(cyr_mess, LAT_uni, CYR_uni);
    return CYR_mess;
}

void main() {
  foreach(line; stdin.byLineCopy)
  {
   writeln(lat2cyr(line));
  }
}
