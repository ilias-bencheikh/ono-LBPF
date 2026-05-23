val frame_buffer : Buffer.t
(** Buffer utilisé pour les traitements liés à l'affichage. *)

val window_opened : bool ref
(** Boolean indiquant si la fenêtre graphique est ouverte. *)

val reset_frame_buffer : unit -> unit
(** Réinitialise l'état du buffer *)

val rows_of_frame_buffer : unit -> bool list list
(** Convertit le buffer en une liste de lignes, chaque ligne étant une liste de
    booléens (représentant des pixels ou cellules). *)

val close_if_opened : unit -> unit
(** Ferme la fenêtre graphique si elle est actuellement ouverte. *)

val shutdown : unit -> unit
(** Éteint complètement le module graphique et libère les ressources. *)

val calculate_cell_size : cols:int -> rows:int -> int
(** Calcule la taille optimale d'une cellule en pixels en fonction du nombre de
    colonnes et de lignes. *)

val initialize_window : cols:int -> rows:int -> (int, 'a) result
(** Initialise la fenêtre graphique avec les dimensions spécifiées (colonnes et
    lignes). *)

val print_cell : Owi.Concrete_i32.t -> (unit, 'a) result
(** Affiche une cellule individuelle dont l'état ou la position est défini par
    un entier 32 bits. *)

val newline : unit -> (unit, 'a) result
(** Effectue un saut de ligne dans l'affichage. *)

val draw_rows : cell_size:int -> bool list list -> unit
(** Dessine l'ensemble des lignes de la grille avec une taille de cellule
    donnée. *)

val draw_input_box : string -> string -> int -> unit
(** Dessine une zone de saisie pour interaction avec l'utilisateur (titre,
    message, valeur par défaut). *)

val ensure_window_open : unit -> unit
(** S'assure que la fenêtre est ouverte, sinon provoque son ouverture. *)

val read_int : unit -> (Owi.Concrete_i32.t, [> `Msg of string ]) result
(** Lit un entier saisi par l'utilisateur via la fenêtre graphique. *)

val is_paused : bool ref
(** Boolean indiquant si l'exécution graphique est en pause. *)

val clear_screen : unit -> (unit, [> `Msg of string ]) result
(** Efface complètement l'écran de la fenêtre graphique. *)

val m : Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
