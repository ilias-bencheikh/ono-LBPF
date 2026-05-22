(** Tampon (buffer) utilisé pour les traitements internes liés à l'affichage. *)
val frame_buffer : Buffer.t

(** Référence indiquant si la fenêtre graphique est ouverte. *)
val window_opened : bool ref

(** Réinitialise l'état du tampon de la trame. *)
val reset_frame_buffer : unit -> unit

(** Convertit le tampon en une liste de lignes, chaque ligne étant une liste de booléens (représentant des pixels ou cellules). *)
val rows_of_frame_buffer : unit -> bool list list

(** Ferme la fenêtre graphique si elle est actuellement ouverte. *)
val close_if_opened : unit -> unit

(** Éteint complètement le module graphique et libère les ressources. *)
val shutdown : unit -> unit

(** Calcule la taille optimale d'une cellule en pixels en fonction du nombre de colonnes et de lignes. *)
val calculate_cell_size : cols:int -> rows:int -> int

(** Initialise la fenêtre graphique avec les dimensions spécifiées (colonnes et lignes). *)
val initialize_window : cols:int -> rows:int -> (int, 'a) result

(** Affiche une cellule individuelle dont l'état ou la position est défini par un entier 32 bits. *)
val print_cell : Owi.Concrete_i32.t -> (unit, 'a) result

(** Effectue un saut de ligne dans l'affichage courant. *)
val newline : unit -> (unit, 'a) result

(** Dessine l'ensemble des lignes de la grille avec une taille de cellule donnée. *)
val draw_rows : cell_size:int -> bool list list -> unit

(** Dessine une zone de saisie pour interagir avec l'utilisateur (titre, message, valeur par défaut). *)
val draw_input_box : string -> string -> int -> unit

(** S'assure que la fenêtre est ouverte, sinon provoque son ouverture. *)
val ensure_window_open : unit -> unit

(** Lit un entier saisi par l'utilisateur via la fenêtre graphique. *)
val read_int : unit -> (Owi.Concrete_i32.t, [> `Msg of string ]) result

(** Indique si l'exécution graphique est actuellement en pause. *)
val is_paused : bool ref

(** Efface complètement l'écran de la fenêtre graphique. *)
val clear_screen : unit -> (unit, [> `Msg of string ]) result

val m : Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
