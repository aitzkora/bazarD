module tree;
import std.stdio;

class Tree(T) {
    T _v;
    Tree _g;
    Tree _d;
   @property ref Tree g() { return _g; }
   @property ref Tree d() { return _d; }
   @property ref T v() { return _v; }
  

   this(T v) {
      _v = v;
      _g = null;
      _d = null;
   }

   void affiche() {
     writeln(_v);
     if (_g !is null) g.affiche();
     if (_d !is null) d.affiche();
   }	   
    
};

