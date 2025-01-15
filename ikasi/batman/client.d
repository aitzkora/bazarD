#!/usr/bin/env rdmd
import std;
import std.socket;
import std.stdio;

struct Config {
   int W;
   int H;
   int n;
   int[2] x;
}
 


string recv(ref Socket soc) {
   char[64] buff;
   auto z = soc.receive(buff);
   return to!string(buff.toStringz).chomp;
}

int[2] saute(in string dir, ref Config c)
{
  
 return [0,0];
}


void main() {
    auto soc = new Socket(AddressFamily.UNIX, SocketType.STREAM);
    soc.connect(new UnixAddress("/tmp/oracle"));

    auto param1 = recv(soc).split(" ").map!(to!int);
    int W = param1[0];
    int H = param1[1];
    writeln("taille de l'immeuble :", W, " x ", H);
    int N = recv(soc).to!int;
    writeln("nombre de tours : ", N);
    auto batPos = recv(soc).split(" ").map!(to!int);
    writeln("batman est en : ", batPos);
    auto conf = Config(W,H, N, [batPos[0], batPos[1]]);
    while (true) {
      string dir = recv(soc);
      if (dir == "F" || conf.n == 0) break;
      saute(dir, conf);
      char[64] buff;
      sprintf(buff.ptr, "%d %d", conf.x[0], conf.x[1]);
      soc.send(buff);
    }
    soc.close();
    if (conf.n > 0)  
      writeln("les otages sont vivants 👍!");
    else 
      writeln("les otages sont morts 👎!");
}

