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

  if not !window_opened then (
    close_if_opened ();
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
  Concrete_ono_common.module_of_backend { print_cell; newline; clear_screen }
