#!/usr/bin/env rdmd
import std.stdio;

mixin template  accessX() {
  int x;
  @property int getX() { return x; }
  void setX(int y) { x=y;} 
}

struct A {
    mixin accessX;
}

void main() {
    auto z = A(2);
    writeln(z.getX); 
}
