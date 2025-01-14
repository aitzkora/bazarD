#!/usr/bin/env rdmd
import std.socket;
import core.stdc.stdio;
struct Problem {
  int W;
  int H;
  int N;
  int[2] x0;
  int[2] xB;
}


void main() {
    auto listener = new Socket(AddressFamily.UNIX, SocketType.STREAM);
    listener.bind(new UnixAddress("/tmp/oracle"));
    listener.listen(2);

    auto building = Problem(10, 10, 6, [5,5] , [7,4]);


    auto soc = listener.accept();
    char[64] line;
    sprintf(line.ptr, "%d %d\n", building.W, building.H);
    soc.send(line);

    //while(1) {
    //    soc.send("trucmuche\n");
    //}
    soc.close();

    listener.close();

    import core.sys.posix.unistd;
    unlink("/tmp/public");
}
