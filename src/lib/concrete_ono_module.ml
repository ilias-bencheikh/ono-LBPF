type extern_func = Kdo.Concrete.Extern_func.extern_func

(* Buffer global pour l'affichage *)
let display_buffer = Buffer.create 4096

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let random_i32 (_ : unit) : (Kdo.Concrete.I32.t, _) Result.t =
  let randint = Random.int32 Int32.max_int in
  Ok (Kdo.Concrete.I32.of_int32 randint)

(* Fonctions externes *)

let sleep (milliseconds : Kdo.Concrete.F32.t) : (unit, _) Result.t =
  let ms = Kdo.Concrete.F32.to_float milliseconds in
  let seconds = ms /. 1000.0 in
  Unix.sleepf seconds;
  Ok ()

let print_cell (cell_alive : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let is_alive = Kdo.Concrete.I32.to_int cell_alive in
  if is_alive <> 0 then Buffer.add_string display_buffer "🦊"
  else Buffer.add_string display_buffer " ";
  Ok ()

let newline (_ : unit) : (unit, _) Result.t =
  Buffer.add_char display_buffer '\n';
  Ok ()

let clear_screen (_ : unit) : (unit, _) Result.t =
  (* Affiche le contenu du buffer *)
  Buffer.output_buffer stdout display_buffer;
  Out_channel.flush stdout;
  (* Nettoyage du buffer *)
  Buffer.clear display_buffer;
  Ok ()


let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [ ("print_i32", Extern_func (i32 ^->. unit, print_i32))
    ; ("print_i64", Extern_func (i64 ^->. unit, print_i64))
    ; ("random_i32", Extern_func (unit ^->. i32, random_i32))
    ; ("sleep", Extern_func (f32 ^->. unit, sleep))
    ; ("print_cell", Extern_func (i32 ^->. unit, print_cell))
    ; ("newline", Extern_func (unit ^->. unit, newline))
    ; ("clear_screen", Extern_func (unit ^->. unit, clear_screen))
    ]
  in
  { Kdo.Extern.Module.functions
  ; func_type = Kdo.Concrete.Extern_func.extern_type
  }
