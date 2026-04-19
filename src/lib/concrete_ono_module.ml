let display_buffer = Buffer.create 4096

let print_cell (cell_alive : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let is_alive = Kdo.Concrete.I32.to_int cell_alive in
  if is_alive <> 0 then
    Buffer.add_string display_buffer
      "\027[30m\226\150\136\027[0m\027[30m\226\150\136\027[0m"
  else
    Buffer.add_string display_buffer
      "\027[37m\226\150\136\027[0m\027[37m\226\150\136\027[0m";
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

let m =
  Concrete_ono_common.module_of_backend { print_cell; newline; clear_screen }
