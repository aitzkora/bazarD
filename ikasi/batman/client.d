#!/usr/bin/env rdmd
import std;
import std.socket;

int[2] find_bomb(int W, int H, int N, int x0, int y0, ref Socket soc)
{
  int[2] xy = [x0, y0];
  int i = 0;
  while(i < N) 
  {
     
  i++;
  }
  if (i < N)  writeln("les otages sont vivants 👍!");
  else writeln("les otages sont morts 👎!");
  return xy;
}

void main() {
    auto soc = new Socket(AddressFamily.UNIX, SocketType.STREAM);
    soc.connect(new UnixAddress("/tmp/oracle"));

    import std.stdio;
    char[64] buff;
    //writeln(buf[0 .. soc.receive(buf)]);
    auto z = soc.receive(buff);
    auto param1 = to!string(buff.toStringz).chomp.split(" ");
    int W = param1[0].to!int;
    int H = param1[1].to!int;
    write("taille de l'immeuble", W, "x", H);
    soc.close();
}

