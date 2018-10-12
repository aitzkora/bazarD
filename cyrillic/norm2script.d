#!/usr/bin/env rdmd
import std.range;
import std.stdio;
import std.array;
import std.string;
unittest {
  assert(norm2script("SUPER") == "𝓢𝓤𝓟𝓔𝓡м" );
}

string norm2script(in string mess) {
    auto normal_uni = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    auto script_uni = "𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓧𝓨𝓩𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃";
    auto script_mess = tr(mess, normal_uni, script_uni);
    return script_mess;

}

void main() {
  foreach(line; stdin.byLineCopy)
  {
   writeln(norm2script(line));
  }
}
