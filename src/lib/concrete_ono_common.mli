type configuration = { width : int; height : int; cells : (int * int) list }

type 'err display_backend = {
  print_cell : Owi.Concrete_i32.t -> (unit, 'err) result;
  newline : unit -> (unit, 'err) result;
  clear_screen : unit -> (unit, 'err) result;
  read_int : unit -> (Owi.Concrete_i32.t, 'err) result;
}

val with_config : bool ref
val max_steps : int option ref
val display_last : int option ref
val game_config : configuration option ref
val set_max_steps : int option -> unit
val set_display_last : int option -> unit
val read_config : Fpath.t -> (unit, [> `Msg of string ]) result
val get_width : unit -> (Owi.Concrete_i32.t, 'a) result
val get_height : unit -> (Owi.Concrete_i32.t, 'a) result
val get_cells_len : unit -> (Owi.Concrete_i32.t, Owi.Result.err) result
val get_ix : Owi.Concrete_i32.t -> (Owi.Concrete_i32.t, 'a) result
val get_iy : Owi.Concrete_i32.t -> (Owi.Concrete_i32.t, 'a) result
val has_config : unit -> (Owi.Concrete_i32.t, 'a) result
val get_max_steps : unit -> (Owi.Concrete_i32.t, 'a) result
val get_display_last : unit -> (Owi.Concrete_i32.t, 'a) result
val print_i32 : Owi.Concrete_i32.t -> (unit, 'a) result
val print_i64 : Owi.Concrete_i64.t -> (unit, 'a) result
val random_i32 : unit -> (Owi.Concrete_i32.t, 'a) result
val sleep : Owi.Concrete_f32.t -> (unit, 'a) result

val module_of_backend :
  Owi.Result.err display_backend ->
  Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
