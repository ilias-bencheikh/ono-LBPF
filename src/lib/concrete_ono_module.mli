val display_buffer : Buffer.t
val print_cell : Owi.Concrete_i32.t -> (unit, 'a) result
val newline : unit -> (unit, 'a) result
val clear_screen : unit -> (unit, 'a) result
val read_int : unit -> (Owi.Concrete_i32.t, [> `Msg of string ]) result
val m : Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
