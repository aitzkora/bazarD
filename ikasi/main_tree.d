import tree : Tree;

int main() {
   alias Tree!(int) abr;
   auto Z = new abr(12);
   Z.g = new abr(24);
   Z.g.d = new abr(34);
   Z.d = new abr(15);
   Z.affiche(); 
   return 0;
}
