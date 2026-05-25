type outcome =
  ( unit,
    [ `Call_stack_exhausted
    | `Conversion_to_integer
    | `Exn
    | `Integer_divide_by_zero
    | `Integer_overflow
    | `Msg of string
    | `Out_of_bounds_memory_access
    | `Parse
    | `Term
    | `Unreachable ] )
  result

val err_conversion_to_integer : int
val err_unreachable : int
val err_integer_divide_by_zero : int
val err_integer_overflow : int
val err_call_stack_exhausted : int
val err_out_of_bounds_memory_access : int
val err_msg : int

val error_to_exit_code :
  [< `Call_stack_exhausted
  | `Conversion_to_integer
  | `Integer_divide_by_zero
  | `Integer_overflow
  | `Msg of 'a
  | `Out_of_bounds_memory_access
  | `Unreachable ] ->
  int

val exits : Cmdliner.Cmd.Exit.info list
val sdocs : string
val version : string
val log_level : Logs.level option Cmdliner.Term.t
val existing_file_conv : Fpath.t Cmdliner.Arg.Conv.t
val setup_log : unit Cmdliner.Term.t
val source_file : Fpath.t Cmdliner.Term.t
val config_file : Fpath.t option Cmdliner.Term.t
val symbolic_grid_width : int Cmdliner.Term.t
val symbolic_grid_height : int Cmdliner.Term.t
val symbolic_num_constraint : int Cmdliner.Term.t
val symbolic_x : int Cmdliner.Term.t
val symbolic_y : int Cmdliner.Term.t
val symbolic_x_prime : int Cmdliner.Term.t
val symbolic_y_prime : int Cmdliner.Term.t
val symbolic_n : int Cmdliner.Term.t
val symbolic_export_config : bool Cmdliner.Term.t
val seed : int option Cmdliner.Term.t
val steps : int option Cmdliner.Term.t
val last : int option Cmdliner.Term.t
val use_graphical_window : bool Cmdliner.Term.t
val no_stop_at_failure : bool Cmdliner.Term.t
