# Ce qui a été fait/réussi

### Préliminaire (concret)

- Implémentation de ```factorielle```, ```square_i64```, ```print_i64```, ```random_i32```.

### Interface Texturelle

- Implémentation des fonctions externes OCaml ```sleep```, ```print_cell```, ```print_newline``` et ```clear_screen```.

- Implémentation du jeu de la vie (boucle de jeu, affichage, fonction comptage de voisins et step).

- Implémentation du read_int pour les dimensions de jeu.

- Implémentation des options ```-–steps``` et ```-–last```.

- Ajout d’un format de fichier ```.life``` pour les configurations initiales et parsing avec commande ```–-config``` ou ```-c```.

### Interface Graphique

- Implémentation de l'interface graphique avec raylib.

- Ajout d'un module ```ono_concrete_common.ml``` qui contient les fonctions en commun entre l'interface textuelle et graphique.

- Redéfinition des fonctions adaptées pour la partie graphique (```print_cell```, ```newline```, ```clear_screen```, ```read_int```).
 
### Préliminaire (symbolique)

- ```polynom.wat``` : Renvoie une solution.
- ```polynom2.wat``` : Renvoie toutes les solutions.

### Interpréteur Symbolique

- Implémentation des 17 contraintes du sujet.

### Tests

- Cramtests pour chaque partie traitée.

# Les points subtils

### Interface textuelle

- Il faut que ```steps n >= last m```, sinon renvoie une erreur.

- L'option ```--last n``` tout seul est interdit.

### Interface graphique

- Mettre le jeu en pause avec la touche ```espace```.

- Avancer d'une seule génération avec la ```flèche droite```.

- Calcul dynamique de la mémoire à allouer en fonction de la taille de la grille.

### Préliminaire (symbolique)

- Les racines sont bornées à ```[-100 ; 100]``` dans ```polynom2.wat``` pour éviter de renvoyer des racines énormes (dues aux multiplications de ```x``` qui peuvent dépasser les bornes entières).

- Calcul du discriminant pour les polynômes de degré 3 pour déterminer le nombre de racines potentielles pour le polynôme en question. Voir [Wikipedia](https://fr.wikipedia.org/wiki/Équation_cubique#Discriminant) pour l'explication.

- P-S : On a omis la division par a**4 dans la formule du discriminant, on sait que 'a' sera jamais nul et qu'il est toujours positif donc on en a pas besoin pour juste déterminer le signe de delta. 

- Disjonctions de cas pour renvoyer exactement les bonnes racines, sans doublons.

# Difficultés rencontrées

- Les tailles de grille > 3*3 prennent énormément de temps de calcul pour la partie symbolique.

# Ce qui n'a pas fonctionné

- Séparation du code en plusieurs fichiers wasm -> linking compliqué.

- Dans la partie symbolique, tous les entiers sont demandés systèmatiquement même s'ils ne sont pas utilisés par la contrainte en question.

- Trouver une optimisation de la partie symbolique qui donne **rapidement toutes** les solutions -> tentative d'optimisation de la fonction ```should_live``` mais qui renvoie qu'une seule solution :

```
(func $should_live (param $i i32) (param $j i32) (result i32)
    (local $alive i32)
    (local $neighbours i32)

    (local.set $alive (call $is_alive (local.get $i)))
    (local.set $neighbours (call $count_alive_neighbours (local.get $i) (local.get $j)))

    ;; (3 voisins) ou (vivant et 2 voisins)
    (i32.or
        (i32.and (local.get $alive) (i32.eq (local.?get $neighbours) (i32.const 2)))
        (i32.eq (local.get $neighbours) (i32.const 3))
    )
)
```
Cette solution n'utilise plus le système de branchement d'Ono if/then/else

# Comment exécuter le programme : 
 
**Pour exécuter :**
```
dune exec -- ono {concrete || symbolic} {file.wat} [--OPTION]
```

**Pour tester :**
```
dune runtest -- ono {concrete || symbolic} {folder.t} [--OPTION]
```

**Partie concrète :**

2 entiers sont demandés, taille de la grille n*m

```--use-graphical-window``` : mode graphique avec raylib.

```--steps n``` : afficher n étapes.

```--last n``` : afficher les n dernières étapes.

```--c {file.life}```  ```--config {file.life}``` : permet de charger une configuration.

**Partie symbolique :**

Voici les options : 
- ```--grid-width n``` : longueur grille = n (par défaut 3)
- ```--grid-height n``` : largeur grille = n (par défaut 3)
- ```--constraint``` : numéro de contrainte = n (par défaut 0)
- ```-x n``` : position x = n (par défaut 0)
- ```-y n``` : position y = n (par défaut 0)
- ```--x-prime n``` : position x' = n (par défaut 0)
- ```--y-prime n``` : position y' = n (par défaut 0)
- ```-n x``` : borne n = x (par défaut 0)

```--no-stop-at-failure``` : ne s’arrête pas après une branche unreachable



