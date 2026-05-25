Test polynom.wat qui renvoie 1 seule solution:
  $ printf "1\n-7\n14\n-8" | ono symbolic polynom.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  {
    "labels": [],
    "model": [ { "symbol": "symbol_0", "type": "i32", "value": "4" } ],
    "breadcrumbs": [ 1 ]
  }
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
  {
    "labels": [],
    "model": [
      { "symbol": "symbol_0", "type": "i32", "value": "1" },
      { "symbol": "symbol_1", "type": "i32", "value": "4" },
      { "symbol": "symbol_2", "type": "i32", "value": "2" }
    ],
    "breadcrumbs": [ 1, 1, 0, 0, 0 ]
  }
  ono: [ERROR] owi error: Reached problem!
  [123]

Cas 2 : delta nul, mais b^2 == 3ac donc 1 racine triple
  $ printf "1\n-6\n12\n-8" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  {
    "labels": [],
    "model": [ { "symbol": "symbol_0", "type": "i32", "value": "2" } ],
    "breadcrumbs": [ 1, 0 ]
  }
  ono: [ERROR] owi error: Reached problem!
  [123]


Cas 3 : delta nul, mais b^2 != 3ac donc 1 racine simple et 1 racine double
  $ printf "1\n0\n-3\n2" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  {
    "labels": [],
    "model": [
      { "symbol": "symbol_0", "type": "i32", "value": "1" },
      { "symbol": "symbol_1", "type": "i32", "value": "-2" }
    ],
    "breadcrumbs": [ 1, 0, 0 ]
  }
  ono: [ERROR] owi error: Reached problem!
  [123]

Cas 4 : delta négatif, une seule racine réelle
  $ printf "1\n-1\n1\n-1" | ono symbolic polynom2.wat
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  Entrer un entier:
  ono: [ERROR] Trap: unreachable
  {
    "labels": [],
    "model": [ { "symbol": "symbol_0", "type": "i32", "value": "1" } ],
    "breadcrumbs": [ 1, 0 ]
  }
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
