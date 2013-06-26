struct Command(alias fun, Args...) {
   Args args_;
   auto invoke() { return fun(args_); }
}

auto command (alias fun, Args...)(Args args) {
   return Command!(fun, Args)(args);
}

void main() {
  auto cmd = command!((a,b) => a * b)(3,2);
  assert(cmd.invoke() == 6);
}
