class Primo {
  int n;
  Primo(this.n);

  bool esPrimo() {
    int c = 0;
    for (int d = 1; d <= n; d++) {
      if (n % d == 0) c = c + 1;
    }
    return c == 2;
  }
}
