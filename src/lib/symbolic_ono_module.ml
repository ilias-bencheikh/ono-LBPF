type extern_func = Kdo.Symbolic.Extern_func.extern_func

let print_i32 (n : Kdo.Symbolic.I32.t) : unit Kdo.Symbolic.Choice.t =
  Logs.app (fun m -> m "%a" Kdo.Symbolic.I32.pp n);
  Kdo.Symbolic.Choice.return ()

let i32_symbol () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.with_new_symbol (Smtml.Ty.Ty_bitv 32)
    Kdo.Symbolic.I32.symbol

let read_int () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  try
    print_endline "Entrer un entier:";
    let line = read_line () in
    let value = Int32.of_string line in
    Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int (Int32.to_int value))
  with _ ->
    Kdo.Symbolic.Choice.trap (`Msg "Invalid input: expected an integer")

let grid_width = ref 3
let grid_height = ref 3
let num_constraint = ref 0
let x = ref 0
let y = ref 0
let x_prime = ref 0
let y_prime = ref 0
let n = ref 0
let set_grid_width value = grid_width := value
let set_grid_height value = grid_height := value
let set_num_constraint value = num_constraint := value
let set_x value = x := value
let set_y value = y := value
let set_x_prime value = x_prime := value
let set_y_prime value = y_prime := value
let set_n value = n := value

let get_grid_width () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !grid_width)

let get_grid_height () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !grid_height)

let get_num_constraint () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !num_constraint)

let get_x () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !x)

let get_y () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !y)

let get_x_prime () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !x_prime)

let get_y_prime () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !y_prime)

let get_n () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !n)

let m =
  let open Kdo.Symbolic.Extern_func in
  let open Kdo.Symbolic.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("i32_symbol", Extern_func (unit ^->. i32, i32_symbol));
      ("read_int", Extern_func (unit ^->. i32, read_int));
      ("get_grid_width", Extern_func (unit ^->. i32, get_grid_width));
      ("get_grid_height", Extern_func (unit ^->. i32, get_grid_height));
      ("get_num_constraint", Extern_func (unit ^->. i32, get_num_constraint));
      ("get_x", Extern_func (unit ^->. i32, get_x));
      ("get_y", Extern_func (unit ^->. i32, get_y));
      ("get_x_prime", Extern_func (unit ^->. i32, get_x_prime));
      ("get_y_prime", Extern_func (unit ^->. i32, get_y_prime));
      ("get_n", Extern_func (unit ^->. i32, get_n));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
