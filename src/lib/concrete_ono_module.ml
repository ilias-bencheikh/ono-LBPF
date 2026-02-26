type extern_func = Kdo.Concrete.Extern_func.extern_func

(* Buffer global pour l'affichage *)
let display_buffer = Buffer.create 4096

(* Variable pour stocker le nombre maximum de steps *)
let max_steps : int option ref = ref None

(* Variable pour stocker le nombre de configurations a afficher *)
let display_last : int option ref = ref None

let set_max_steps (steps : int option) : unit =
  max_steps := steps

let set_display_last (last : int option) : unit =
  display_last := last

let get_max_steps (_ : unit) : (Kdo.Concrete.I32.t, _) Result.t =
  let value = match !max_steps with
    | Some n -> Int32.of_int n
    | None -> Int32.minus_one  (* -1 pour indiquer "pas de limite" *)
  in
  Ok (Kdo.Concrete.I32.of_int32 value)

let get_display_last (_ : unit) : (Kdo.Concrete.I32.t, _) Result.t =
  let value = match !display_last with
    | Some n -> Int32.of_int n
    | None -> Int32.minus_one  (* -1 pour indiquer "pas de limite" *)
  in
  Ok (Kdo.Concrete.I32.of_int32 value)

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
  if is_alive <> 0 then Buffer.add_string display_buffer "\027[30m\226\150\136\027[0m\027[30m\226\150\136\027[0m"
  else Buffer.add_string display_buffer "\027[37m\226\150\136\027[0m\027[37m\226\150\136\027[0m";
  Ok ()

let newline (_ : unit) : (unit, _) Result.t =
  Buffer.add_char display_buffer '\n';
  Ok ()

let clear_screen (_ : unit) : (unit, _) Result.t =
  (* Affiche le contenu du buffer *)
  output_string stdout (Buffer.contents display_buffer);
  Out_channel.flush stdout;
  (* Nettoyage du buffer *)
  Buffer.clear display_buffer;
  Ok ()

let read_int (_ : unit) : (Kdo.Concrete.I32.t, _) Result.t =
  try
    print_endline "Entrer un entier:";
    let line = read_line () in
    let value = Int32.of_string line in
    Ok (Kdo.Concrete.I32.of_int32 value)
  with _ ->
    Error (`Msg "Invalid input: expected an integer")

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
    ; ("read_int", Extern_func (unit ^->. i32, read_int))
    ; ("get_max_steps", Extern_func (unit ^->. i32, get_max_steps))
    ; ("get_display_last", Extern_func (unit ^->. i32, get_display_last))
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
