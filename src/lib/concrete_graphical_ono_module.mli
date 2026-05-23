(** Buffer utilisé pour les traitements liés à l'affichage. *)
val frame_buffer : Buffer.t
(** Buffer utilisé pour les traitements liés à l'affichage. *)

val window_opened : bool ref
val reset_frame_buffer : unit -> unit
val rows_of_frame_buffer : unit -> bool list list
val close_if_opened : unit -> unit
val shutdown : unit -> unit
val calculate_cell_size : cols:int -> rows:int -> int
val initialize_window : cols:int -> rows:int -> (int, 'a) result
val print_cell : Owi.Concrete_i32.t -> (unit, 'a) result
val newline : unit -> (unit, 'a) result
val draw_rows : cell_size:int -> bool list list -> unit
val draw_input_box : string -> string -> int -> unit
val ensure_window_open : unit -> unit
val read_int : unit -> (Owi.Concrete_i32.t, [> `Msg of string ]) result
val is_paused : bool ref
val clear_screen : unit -> (unit, [> `Msg of string ]) result
val m : Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
