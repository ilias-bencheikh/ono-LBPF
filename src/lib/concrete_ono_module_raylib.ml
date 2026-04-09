include Concrete_ono_module

let cell_size = 20
let current_x = ref 0
let current_y = ref 0
let window_initialized = ref false

let setup () =
  if not !window_initialized then begin
    Raylib.init_window 800 600 "Jeu de la vie";
    Raylib.set_target_fps 60;
    window_initialized := true
  end

let clear_screen (_ : unit) : (unit, _) Result.t =
  setup ();
  if Raylib.window_should_close () then exit 0;
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  current_x := 0;
  current_y := 0;
  Ok ()

let print_cell (cell_alive : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let is_alive = Kdo.Concrete.I32.to_int cell_alive in
  if is_alive <> 0 then
    Raylib.draw_rectangle !current_x !current_y cell_size cell_size
      Raylib.Color.black
  else begin
    Raylib.draw_rectangle !current_x !current_y cell_size cell_size
      Raylib.Color.raywhite;
    Raylib.draw_rectangle_lines !current_x !current_y cell_size cell_size
      Raylib.Color.lightgray
  end;
  current_x := !current_x + cell_size;
  Ok ()

let newline (_ : unit) : (unit, _) Result.t =
  current_x := 0;
  current_y := !current_y + cell_size;
  Ok ()

let sleep (milliseconds : Kdo.Concrete.F32.t) : (unit, _) Result.t =
  let ms = Kdo.Concrete.F32.to_float milliseconds in
  Raylib.end_drawing ();
  Unix.sleepf (ms /. 1000.0);
  Ok ()

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("print_i64", Extern_func (i64 ^->. unit, print_i64));
      ("random_i32", Extern_func (unit ^->. i32, random_i32));
      ("sleep", Extern_func (f32 ^->. unit, sleep));
      ("print_cell", Extern_func (i32 ^->. unit, print_cell));
      ("newline", Extern_func (unit ^->. unit, newline));
      ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
      ("read_int", Extern_func (unit ^->. i32, read_int));
      ("get_max_steps", Extern_func (unit ^->. i32, get_max_steps));
      ("get_display_last", Extern_func (unit ^->. i32, get_display_last));
      ("has_config", Extern_func (unit ^->. i32, has_config));
      ("get_width", Extern_func (unit ^->. i32, get_width));
      ("get_height", Extern_func (unit ^->. i32, get_height));
      ("get_cells_len", Extern_func (unit ^->. i32, get_cells_len));
      ("get_ix", Extern_func (i32 ^->. i32, get_ix));
      ("get_iy", Extern_func (i32 ^->. i32, get_iy));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
