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
  and+ no_stop_at_failure = no_stop_at_failure in
  Ono.Symbolic_ono_module.set_grid_width grid_width;
  Ono.Symbolic_ono_module.set_grid_height grid_height;
  Ono.Symbolic_ono_module.set_num_constraint num_constraint;
  Ono.Symbolic_driver.run ~source_file ~no_stop_at_failure |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
