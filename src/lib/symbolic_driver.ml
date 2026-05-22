open Syntax
module Interpret = Kdo.Interpret.Symbolic (Kdo.Interpret.Default_parameters)

let run ~source_file ~no_stop_at_failure =
  (* Parsing. *)
  Logs.info (fun m -> m "Parsing file %a..." Fpath.pp source_file);
  let* wat_module = Kdo.Parse.Wat.Module.from_file source_file in
  Logs.debug (fun m ->
      m "Parsed module is:  @\n@[<v>%a@]" Kdo.Wat.Module.pp wat_module);

  (* Compiling to Wasm. *)
  Logs.info (fun m -> m "Compiling to Wasm...");
  let* wasm_module = Kdo.Compile.Wat.until_wasm ~unsafe:false wat_module in
  Logs.debug (fun m ->
      m "Compiled module is:  @\n@[<v>%a@]" Kdo.Wasm.Module.pp wasm_module);

  (* Validation step. *)
  Logs.info (fun m -> m "Validating...");
  let* () = Kdo.Validate.Wasm.modul wasm_module in

  (* Linking. *)
  Logs.info (fun m -> m "Linking...");
  let link_state : Kdo.Symbolic.Extern_func.extern_func Kdo.Link.State.t =
    Kdo.Link.State.empty ()
  in
  let link_state =
    Kdo.Link.Extern.modul Symbolic_ono_module.m link_state ~name:"ono"
  in
  let name = Some (Fpath.to_string source_file) in
  let* linked_module, link_state =
    Kdo.Link.Wasm.modul link_state ~name wasm_module
  in

  (* Interpreting. *)
  Logs.info (fun m -> m "Interpreting...");
  Interpret.modul link_state linked_module
  |> Kdo.Symbolic.Driver.handle_result
       ~exploration_strategy:Kdo.Symbolic.Parameters.Exploration_strategy.FIFO
       ~workers:4 ~no_stop_at_failure ~no_value:false
       ~no_assert_failure_expression_printing:false
       ~deterministic_result_order:false ~fail_mode:Kdo.Symbolic.Parameters.Both
       ~workspace:(Fpath.v ".") ~solver:Smtml.Solver_type.Z3_solver
       ~model_format:Kdo.Symbolic.Model.Scfg ~model_out_file:None
       ~with_breadcrumbs:true ~run_time:None
  |> function
  | Ok () -> Ok ()
  | Error e -> Fmt.error_msg "owi error: %s" (Owi.Result.err_to_string e)
