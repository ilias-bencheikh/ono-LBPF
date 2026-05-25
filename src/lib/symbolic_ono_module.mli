type extern_func = Owi.Symbolic_extern_func.extern_func
(** Type désignant une fonction externe dans un contexte d'exécution symbolique.
*)

val print_i32 : Owi.Symbolic_i32.t -> unit Owi.Symbolic_choice.t
(** Version symbolique de l'affichage d'un entier 32 bits. *)

val i32_symbol : unit -> Owi.Symbolic_i32.t Owi.Symbolic_choice.t
(** Génère ou retourne un entier 32 bits symbolique. *)

val read_int : unit -> Owi.Symbolic_i32.t Owi.Symbolic_choice.t
(** Version symbolique de la lecture d'un entier depuis l'utilisateur. *)

val set_grid_width : int -> unit
(** Fixe la largeur de la grille utilisée par les imports symboliques. *)

val set_grid_height : int -> unit
(** Fixe la hauteur de la grille utilisée par les imports symboliques. *)

val set_num_constraint : int -> unit
(** Fixe le numéro de contrainte utilisé par les imports symboliques. *)

val set_x : int -> unit
(** Fixe la position x. *)

val set_y : int -> unit
(** Fixe la position y. *)

val set_x_prime : int -> unit
(** Fixe la position x'. *)

val set_y_prime : int -> unit
(** Fixe la position y'. *)

val set_n : int -> unit
(** Fixe la valeur n. *)

val m : extern_func Owi.Extern.Module.t
(** Module contenant les appels de fonctions externes pour l'exécution
    symbolique. *)
