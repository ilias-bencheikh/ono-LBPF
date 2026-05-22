type extern_func = Owi.Symbolic_extern_func.extern_func

val print_i32 : Owi.Symbolic_i32.t -> unit Owi.Symbolic_choice.t
val i32_symbol : unit -> Owi.Symbolic_i32.t Owi.Symbolic_choice.t
val read_int : unit -> Owi.Symbolic_i32.t Owi.Symbolic_choice.t
val m : extern_func Owi.Extern.Module.t
