(* The `ono symbolic` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "symbolic" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log
  and+ source_file = source_file
  and+ grid_width = symbolic_grid_width
  and+ grid_height = symbolic_grid_height
  and+ num_constraint = symbolic_num_constraint
  and+ x = symbolic_x
  and+ y = symbolic_y
  and+ x_prime = symbolic_x_prime
  and+ y_prime = symbolic_y_prime
  and+ n = symbolic_n
  and+ export_config = symbolic_export_config
  and+ no_stop_at_failure = no_stop_at_failure in
  Ono.Symbolic_ono_module.set_grid_width grid_width;
  Ono.Symbolic_ono_module.set_grid_height grid_height;
  Ono.Symbolic_ono_module.set_num_constraint num_constraint;
  Ono.Symbolic_ono_module.set_x x;
  Ono.Symbolic_ono_module.set_y y;
  Ono.Symbolic_ono_module.set_x_prime x_prime;
  Ono.Symbolic_ono_module.set_y_prime y_prime;
  Ono.Symbolic_ono_module.set_n n;
  let output_json = Fpath.v "test/config/out.json" in
  let output_life = Fpath.v "test/config/out.life" in
  let model_out_file = if export_config then Some output_json else None in
  let result =
    Ono.Symbolic_driver.run ~source_file ~no_stop_at_failure
      ~model_format:Kdo.Symbolic.Model.Json ~model_out_file
  in
  let export_result =
    if export_config then
      let model_file =
        if no_stop_at_failure then
          let fallback_json = Fpath.v "test/config/out_0.json" in
          if Sys.file_exists (Fpath.to_string fallback_json) then fallback_json
          else output_json
        else output_json
      in
      if not (Sys.file_exists (Fpath.to_string model_file)) then
        Ok ()
      else
      match
        Ono.Symbolic_model.configuration_of_json_file ~width:grid_width
          ~height:grid_height model_file
      with
      | Error (`Msg msg) -> Error (`Msg msg)
      | Error _ -> Error (`Msg "Failed to parse the symbolic model output")
      | Ok configuration -> (
          let () = Ono.Concrete_ono_common.set_configuration configuration in
          let json_copy_result =
            if Fpath.equal model_file output_json then Ok ()
            else
              try
                let json =
                  Yojson.Basic.from_file (Fpath.to_string model_file)
                in
                Yojson.Basic.to_file (Fpath.to_string output_json) json;
                Ok ()
              with
              | Yojson.Json_error msg -> Error (`Msg msg)
              | Sys_error msg -> Error (`Msg msg)
          in
          match json_copy_result with
          | Error e -> Error e
          | Ok () ->
              Ono.Symbolic_model.write_life_file configuration output_life)
    else Ok ()
  in
  match (result, export_result) with
  | Ok (), Ok () -> Ok ()
  | Error e, Ok () -> Error (`Msg (Kdo.R.err_to_string e))
  | Ok (), Error e -> Error e
  | Error e, Error export_error ->
      Error
        (`Msg
           (Fmt.str "%s; export failed: %s" (Kdo.R.err_to_string e)
              (match export_error with `Msg msg -> msg | _ -> "unknown error")))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
