#!/usr/bin/env rdmd
import std.socket;
import core.stdc.stdio;
import std.numeric;
import std.math;
import std.stdio;
struct Problem {
  int W;
  int H;
  int N;
  int[2] x0;
  int[2] xB;
}


pure string calc_dir_dist(int[2] x0, int[2] xB)
{
  immutable(string[int[2]]) dirs = [ [0,-1] : "U", [1, -1] : "UR", [1 , 0] : "R", [1,1] : "DR",
                                     [0, 1] : "D", [-1, 1] : "DL", [-1, 0] : "L", [-1, -1] : "UL"];
  int[2] dx = xB[] - x0[];
  int hyp2 = dotProduct(dx, dx);
  int dxOne = sgn(dx[0]) * (4*dx[0]*dx[0]  > hyp2);
  int dyOne = sgn(dx[1]) * (4*dx[0]*dx[0] <= 3 * hyp2);
  return dirs[[dxOne, dyOne]];
}

pure string calc_dir_lexico(int[2] x0, int[2] xB)
{
  immutable(string[int[2]]) dirs = [ [0,-1] : "U", [1, -1] : "UR", [1 , 0] : "R", [1,1] : "DR",
                                     [0, 1] : "D", [-1, 1] : "DL", [-1, 0] : "L", [-1, -1] : "UL",
                                     [0,0]  : "F"];

  int[2] dx = xB[] - x0[];
  int dxOne = (dx[0] >= 0 ? 1 : -1);
  int dyOne = (dx[1] >= 0 ? 1 : -1);
  return dirs[[dxOne, dyOne]];
}
unittest {
   assert(calc_dir_lexico([5,5], [7,4]) == "UR");
}

void main() {
    writeln(calc_dir_lexico([5,5], [7,4]));
    auto listener = new Socket(AddressFamily.UNIX, SocketType.STREAM);
    listener.bind(new UnixAddress("/tmp/oracle"));
    listener.listen(2);

    auto building = Problem(10, 10, 6, [5,5] , [7,4]);


    auto soc = listener.accept();
    char[64] line;
    sprintf(line.ptr, "%d %d\n", building.W, building.H);
    soc.send(line);
    sprintf(line.ptr, "%d\n", building.N);
    soc.send(line);
    sprintf(line.ptr, "%d %d\n", building.x0[0], building.x0[1]);
    soc.send(line);

    int i = 0;
    while(i<building.N) {
        soc.send("");
        i++;
    }
    soc.close();

    listener.close();

    import core.sys.posix.unistd;
    unlink("/tmp/public");
}
