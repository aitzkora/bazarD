import core.simd;
import std.stdio;
import std.datetime;

void version1() {
  int data[100];
  foreach(i; 0 .. data.length) {
   data[i] += 10;
  }
} 


void version2() {
   int4 data[100 / int4.length];
   int4 tens = [10, 10, 10, 10];
   foreach(i ; 0 .. data.length) {
      data[i] += tens;
   }

}

int main() {

   auto t0 = Clock.currTime(); 
   foreach(i ; 0 .. 10000) {
      version1();
   }
   auto t1 =  Clock.currTime() - t0;
   writeln(t1);  
   t0 = Clock.currTime(); 
   foreach(i ; 0 .. 10000) {
      version2();
   }
   auto t2 =  Clock.currTime() - t0;
   writeln(t2);  
   return 0;
}
