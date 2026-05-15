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

- Il faut que ```steps n > last m```, sinon que l’option ```--steps``` est utilisé.

- L'option ```--last n``` n'affiche rien.

### Interface graphique

- Mettre le jeu en pause avec la touche ```espace```.

- Avancer d'une seule génération avec la ```flèche droite```.

### Préliminaire (symbolique)

- Les racines sont bornées à ```[-100 ; 100]``` dans ```polynom2.wat``` pour éviter de renvoyer des racines énormes (dues aux multiplications de ```x``` qui peuvent dépasser les bornes entières).

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

7 entiers sont demandés :
- ```a``` : longueur grille
- ```b``` : largeur grille
- ```c``` : numéro de contrainte
- ```x``` : position x
- ```y``` : position y
- ```x'``` : position x'
- ```y'``` : position y'
- ```n``` : borne n

```--no-stop-at-failure``` : ne s’arrête pas après une branche unreachable



