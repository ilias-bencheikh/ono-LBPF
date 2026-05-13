open Raylib
open Syntax

let frame_buffer = Buffer.create 4096
let window_opened = ref false
let reset_frame_buffer () = Buffer.clear frame_buffer

let rows_of_frame_buffer () =
  let row_of_string line =
    String.to_seq line |> List.of_seq
    |> List.filter_map (function
      | '1' -> Some true
      | '0' -> Some false
      | _ -> None)
  in
  Buffer.contents frame_buffer
  |> String.split_on_char '\n'
  |> List.filter_map (fun line ->
      let row = row_of_string line in
      if row = [] then None else Some row)

let close_if_opened () =
  if !window_opened then (
    close_window ();
    window_opened := false)

let shutdown () = close_if_opened ()

let calculate_cell_size ~cols ~rows =
  let safe_cols = max 1 cols in
  let safe_rows = max 1 rows in
  let by_width = 1000 / safe_cols in
  let by_height = 700 / safe_rows in
  min 30 (max 4 (min by_width by_height))

let initialize_window ~cols ~rows =
  let cell_size = calculate_cell_size ~cols ~rows in
  let new_w = cols * cell_size in
  let new_h = rows * cell_size in

  if !window_opened then (
    set_window_title "Game of Life";
    set_window_size new_w new_h)
  else (
    init_window new_w new_h "Game of Life";
    set_target_fps 60;
    window_opened := true);
  Ok cell_size

let print_cell (cell_alive : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let alive = Kdo.Concrete.I32.to_int cell_alive <> 0 in
  Buffer.add_char frame_buffer (if alive then '1' else '0');
  Ok ()

let newline (_ : unit) : (unit, _) Result.t =
  Buffer.add_char frame_buffer '\n';
  Ok ()

let draw_rows ~cell_size rows =
  let cell_px = max 1 (cell_size - 1) in
  List.iteri
    (fun y row ->
      List.iteri
        (fun x alive ->
          let color = if alive then Color.black else Color.lightgray in
          draw_rectangle (x * cell_size) (y * cell_size) cell_px cell_px color)
        row)
    rows

let draw_input_box prompt input_text frames =
  begin_drawing ();
  clear_background Color.raywhite;

  draw_text prompt 50 80 28 Color.black;
  draw_rectangle 50 140 500 50 Color.lightgray;
  draw_rectangle_lines 50 140 500 50 Color.darkgray;
  draw_text input_text 60 150 32 Color.black;

  (* dessin du curseur clignotant *)
  (if frames / 15 mod 2 = 0 then
     let cursor_x = 60 + (String.length input_text * 18) in
     draw_line cursor_x 155 cursor_x 175 Color.black);

  draw_text "ENTRER pour valider" 50 220 18 Color.black;

  end_drawing ()

let ensure_window_open () =
  if not !window_opened then (
    close_if_opened ();
    init_window 600 300 "Entrer un entier";
    set_target_fps 60;
    window_opened := true)

let read_int (_ : unit) : (Kdo.Concrete.I32.t, _) Result.t =
  let prompt = "Entrer un entier:" in
  ensure_window_open ();

  let input_text = ref "" in
  let frames = ref 0 in

  let rec input_loop () =
    if window_should_close () then Error (`Msg "window closed by user")
    else (
      incr frames;

      (* read de l'entrée *)
      let rec process_chars () =
        let key = Uchar.to_int (get_char_pressed ()) in
        if key <> 0 then (
          if key >= 48 && key <= 57 && String.length !input_text < 20 then
            input_text := !input_text ^ String.make 1 (Char.chr key);
          process_chars ())
      in
      process_chars ();

      (* gère le backspace *)
      if is_key_pressed Key.Backspace && String.length !input_text > 0 then
        input_text := String.sub !input_text 0 (String.length !input_text - 1);

      (* gère les 2 touches Enter *)
      if
        (is_key_pressed Key.Enter || is_key_pressed Key.Kp_enter)
        && String.length !input_text > 0
      then
        try
          let value = Int32.of_string !input_text in
          draw_input_box prompt !input_text !frames;
          Ok (Kdo.Concrete.I32.of_int32 value)
        with _ -> Error (`Msg "Invalid input: expected an integer")
      else (
        draw_input_box prompt !input_text !frames;
        input_loop ()))
  in

  input_loop ()

let clear_screen () : (unit, _) Result.t =
  if !window_opened && window_should_close () then
    Error (`Msg "window closed by user")
  else
    let rows = rows_of_frame_buffer () in
    reset_frame_buffer ();
    if rows = [] then Ok ()
    else
      let cols =
        List.fold_left (fun acc row -> max acc (List.length row)) 0 rows
      in
      let* cell_size = initialize_window ~cols ~rows:(List.length rows) in
      begin_drawing ();
      clear_background Color.raywhite;
      draw_rows ~cell_size rows;
      end_drawing ();
      Ok ()

let m =
  Concrete_ono_common.module_of_backend
    { print_cell; newline; clear_screen; read_int }
