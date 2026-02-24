Cramtest option --steps:

Grille 10*5, 2 steps et seed 42:
  $ printf "10\n5\n" | ono concrete main.wat --steps 2 --seed 42
  Entrer un entier:
  Entrer un entier:
    🦊 🦊🦊🦊🦊🦊🦊
  🦊 🦊🦊🦊  🦊🦊 
   🦊🦊 🦊🦊🦊🦊🦊🦊
    🦊🦊  🦊  🦊
  🦊🦊🦊🦊 🦊  🦊🦊
   🦊🦊 🦊🦊🦊  🦊
            
           🦊
  🦊         
   🦊 🦊🦊   🦊🦊
  OK!

Grille 5*3, 1 step et seed 42:
  $ printf "5\n3\n" | ono concrete main.wat --steps 1 --seed 42
  Entrer un entier:
  Entrer un entier:
    🦊 🦊
  🦊🦊🦊🦊🦊
  🦊 🦊🦊🦊
  OK!

Pas de génération (steps = 0) et seed 42:
  $ printf "5\n3\n" | ono concrete main.wat --steps 0 --seed 42
  Entrer un entier:
  Entrer un entier:
  OK!

