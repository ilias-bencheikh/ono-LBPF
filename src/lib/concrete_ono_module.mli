(** Tampon d'affichage pour les sorties terminal standard. *)
val display_buffer : Buffer.t

(** Affiche l'état d'une cellule dans le terminal. *)
val print_cell : Owi.Concrete_i32.t -> (unit, 'a) result

(** Ajoute un saut de ligne à l'affichage du terminal. *)
val newline : unit -> (unit, 'a) result

(** Efface le contenu de l'écran du terminal. *)
val clear_screen : unit -> (unit, 'a) result

(** Lit un entier depuis l'entrée standard du terminal. *)
val read_int : unit -> (Owi.Concrete_i32.t, [> `Msg of string ]) result

(** Module externe terminal (fonctions concrètes). *)
val m : Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
