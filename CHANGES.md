# unreleased

- fix CI/CD

# [v1.1.0] - [2025-05-25]

### Added
- taille de grille et numéro de contrainte en option de commande
- paramètres x,y,x_prime,y_prime et n en options de commande au lieu des read_int dans le wasm
- option ```--export-config``` pour transformer la sortie de l'exécution symbolique en fichier ```.life``` testable

### Changed
- changement du type d'output de l'exécution symbolique : SCFG -> json

### Fixed
- update des anciens cramtests de l'exécution symbolique

# [v1.0.2] - [2025-05-24]

### Changed
- ajout de cramtests pour les polynomes
### Fixed
- plus de problème d'out of bound (la mémoire est allouée au début en fonction de la taille de la grille)
- fix polynom2.wat, renvoie bien toutes les solutions

# [v1.0.1] - [2025-05-23]

### Added
- Ajout des .mli
- Ajout des commentaires de documentation (odoc)
### Changed
- Formattage du code
- Suppression des fichiers inutiles
### Fixed
- Correction des options --steps / --last
- Correction du bouton pause
- Correction de l'affichage de la fenetre au demarage (taille)

# [v1.0.0] - [2025-05-23]

### Added
Préliminaire :
- implémentation du factorielle
- implémentation de square_i64 et print_i64 
- implémentation de random_i32

Interface Textuelle :
- implémentation des fonctions externes OCaml sleep, print_cell, newline et clear_screen et ajout de cramtests
- structuration des fonctions du jeu en plusieurs modules
- implémentation de la boucle du jeu et de l'affichage de la grille
- implementation de la fonction de comptage des voisins
- implémentation de la fonction step
- implémentation read_int, input utilisateur pour gérer les dimensions du jeu
- implémentation de l'option --steps
- implémentation de l'option --last

Interface graphique :
- implémentation version graphique du jeu avec raylib
- option de lancement --use-graphical-window pour lancer
- read_int de la taille de fenêtre directement sur l'interface
- inputs user pour naviguer dans le jeu (espace->pause/reprendre, flèche droite->frame suivante)

Exécution Symbolique :
- préliminaire (polynome.wat, polynom2.wat)
- implémentation du générateur de configurations (game_of_life.wat)
- implémentation des 17 contraintes proposées par le sujet

# 0.1 - 2025-12-16

- first version