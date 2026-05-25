type configuration = Concrete_ono_common.configuration

let rec collect_values json acc =
  match json with
  | `Assoc fields -> (
      match (List.assoc_opt "symbol" fields, List.assoc_opt "value" fields) with
      | Some (`String _), Some value -> (
          let parsed =
            match value with
            | `Int n -> Ok n
            | `String s -> (
                try Ok (int_of_string s)
                with _ -> Error (`Msg "Invalid symbolic value in JSON model"))
            | `Bool true -> Ok 1
            | `Bool false -> Ok 0
            | _ -> Error (`Msg "Unsupported symbolic value in JSON model")
          in
          match parsed with Ok n -> Ok (n :: acc) | Error e -> Error e)
      | _ -> (
          match List.assoc_opt "content" fields with
          | Some (`List items) -> collect_list items acc
          | _ -> Ok acc))
  | `List items -> collect_list items acc
  | _ -> Ok acc

and collect_list items acc =
  match items with
  | [] -> Ok acc
  | item :: rest -> (
      match collect_values item acc with
      | Ok acc -> collect_list rest acc
      | Error _ as error -> error)

let configuration_of_json_file ~width ~height path =
  try
    let json = Yojson.Basic.from_file (Fpath.to_string path) in
    match json with
    | `Assoc fields -> (
        match List.assoc_opt "model" fields with
        | None -> Error (`Msg "JSON model does not contain a model field")
        | Some (`List items) -> (
            match collect_list items [] |> Result.map List.rev with
            | Error _ as error -> error
            | Ok values ->
                let expected = width * height in
                if List.length values < expected then
                  Error
                    (`Msg
                       "JSON model does not contain enough values for the grid")
                else
                  let rec build cells index = function
                    | [] ->
                        Ok
                          ({ width; height; cells = List.rev cells }
                            : Concrete_ono_common.configuration)
                    | value :: rest ->
                        if index >= expected then
                          Ok
                            ({ width; height; cells = List.rev cells }
                              : Concrete_ono_common.configuration)
                        else if value <> 0 && value <> 1 then
                          Error
                            (`Msg "Symbolic Game of Life values must be 0 or 1")
                        else
                          let row = index / width in
                          let column = index mod width in
                          let cells =
                            if value = 1 then (column, row) :: cells else cells
                          in
                          build cells (index + 1) rest
                  in
                  build [] 0 values)
        | Some _ -> Error (`Msg "JSON model field has an unexpected shape"))
    | _ -> Error (`Msg "Invalid JSON model format")
  with
  | Yojson.Json_error msg -> Error (`Msg msg)
  | Sys_error msg -> Error (`Msg msg)

let write_life_file ({ width; height; cells } : configuration) path =
  try
    Out_channel.with_open_text (Fpath.to_string path) (fun oc ->
        Printf.fprintf oc "HEIGHT: %d\n" height;
        Printf.fprintf oc "WIDTH: %d\n" width;
        List.iter (fun (x, y) -> Printf.fprintf oc "%d %d\n" x y) cells);
    Ok ()
  with Sys_error msg -> Error (`Msg msg)
