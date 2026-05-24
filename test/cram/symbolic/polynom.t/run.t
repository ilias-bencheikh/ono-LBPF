Test polynom.wat qui renvoie 1 seule solution:
  $ printf "1\n-7\n14\n-8" | ono symbolic polynom.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 4
  }
  breadcrumbs 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Test polynom2.wat qui renvoie toutes les soltuions
1) Cas 1 : delta positif donc 3 racines distinctes
  $ printf "1\n-7\n14\n-8" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1
    symbol symbol_1 i32 4
    symbol symbol_2 i32 2
  }
  breadcrumbs 0 0 0 1 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Cas 2 : delta nul, mais b^2 == 3ac donc 1 racine triple
  $ printf "1\n-6\n12\n-8" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 2
  }
  breadcrumbs 0 1
  ono: [ERROR] owi error: Reached problem!
  [123]


Cas 3 : delta nul, mais b^2 != 3ac donc 1 racine simple et 1 racine double
  $ printf "1\n0\n-3\n2" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1
    symbol symbol_1 i32 -2
  }
  breadcrumbs 0 0 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Cas 4 : delta négatif, une seule racine réelle
  $ printf "1\n-1\n1\n-1" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1
  }
  breadcrumbs 0 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Cas 5 : pas de solutions
  $ printf "1\n-7\n14\n-10" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  All OK!
  OK!

