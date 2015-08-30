#!/usr/bin/env rdmd
import std.stdio;

T2[] mymap(T1, T2)(T2 function (T1) fun, T1[] a) {
    T2[] b;
    b.length =  a.length;
    foreach( int i, z ; a) 
         b[i] = fun(z);
    return b;
}

T[] mymap2(alias fun, T)(T[] a) {
    T[] b;
    b.length =  a.length;
    foreach( int i, z ; a) 
         b[i] = fun(z);
    return b;
}

void main() {
    auto g = (int x)=>x*x;
    auto z = [1, 2, 3];
    auto b = mymap2!g(z);
    writeln(b);
    auto c = mymap((int x) =>x*x, z);
    writeln(c);
}
