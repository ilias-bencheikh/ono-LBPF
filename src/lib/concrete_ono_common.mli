type configuration = { width : int; height : int; cells : (int * int) list }
(** Structure définissant la configuration d'une grille . *)

type 'err display_backend = {
  print_cell : Owi.Concrete_i32.t -> (unit, 'err) result;
  newline : unit -> (unit, 'err) result;
  clear_screen : unit -> (unit, 'err) result;
  read_int : unit -> (Owi.Concrete_i32.t, 'err) result;
}
(** Définition d'un backend d'affichage générique permettant de substituer le
    terminal à la fenêtre graphique. *)

val with_config : bool ref
(** Boolean indiquant si le programme a été lancé avec une configuration. *)

val max_steps : int option ref
(** Nombre maximal d'étapes d'exécution autorisées. *)

val display_last : int option ref
(** Nombre des dernières étapes à afficher. *)

val game_config : configuration option ref
(** Configuration courante chargée en mémoire. *)

val set_max_steps : int option -> unit
(** Modifie la limite d'étapes d'exécution. *)

val set_display_last : int option -> unit
(** Modifie la limite d'affichage des dernières étapes. *)

val read_config : Fpath.t -> (unit, [> `Msg of string ]) result
(** Charge la configuration à partir d'un fichier spécifié. *)

val get_width : unit -> (Owi.Concrete_i32.t, 'a) result
(** Récupère la largeur configurée. *)

val get_height : unit -> (Owi.Concrete_i32.t, 'a) result
(** Récupère la hauteur configurée. *)

val get_cells_len : unit -> (Owi.Concrete_i32.t, Owi.Result.err) result
(** Récupère le nombre total de cellules configurées. *)

val get_ix : Owi.Concrete_i32.t -> (Owi.Concrete_i32.t, 'a) result
(** Récupère la position X (colonne) de la cellule à un index donné. *)

val get_iy : Owi.Concrete_i32.t -> (Owi.Concrete_i32.t, 'a) result
(** Récupère la position Y (ligne) de la cellule à un index donné. *)

val has_config : unit -> (Owi.Concrete_i32.t, 'a) result
(** Vérifie si une configuration est actuellement chargée (retourne 1 si oui, 0
    sinon). *)

val get_max_steps : unit -> (Owi.Concrete_i32.t, 'a) result
(** Récupère le nombre d'étapes maximum sous forme d'entier 32 bits. *)

val get_display_last : unit -> (Owi.Concrete_i32.t, 'a) result
(** Récupère la valeur de display_last sous forme d'entier 32 bits. *)

val print_i32 : Owi.Concrete_i32.t -> (unit, 'a) result
(** Affiche un entier sur 32 bits. *)

val print_i64 : Owi.Concrete_i64.t -> (unit, 'a) result
(** Affiche un entier sur 64 bits. *)

val random_i32 : unit -> (Owi.Concrete_i32.t, 'a) result
(** Génère et retourne un entier aléatoire de 32 bits. *)

val sleep : Owi.Concrete_f32.t -> (unit, 'a) result
(** Met l'exécution en pause pendant un certain nombre de secondes (flottant 32
    bits). *)

val module_of_backend :
  Owi.Result.err display_backend ->
  Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
