open Syntax
module Interpret = Kdo.Interpret.Concrete (Kdo.Interpret.Default_parameters)

let run ~source_file ~max_steps =
  (* Storage pour max_steps *)
  Concrete_ono_module.set_max_steps max_steps;
  
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
  let link_state : Kdo.Concrete.Extern_func.extern_func Kdo.Link.State.t =
    Kdo.Link.State.empty ()
  in
  let link_state =
    Kdo.Link.Extern.modul Concrete_ono_module.m link_state ~name:"ono"
  in
  let name = Some (Fpath.to_string source_file) in
  let* linked_module, link_state =
    Kdo.Link.Wasm.modul link_state ~name wasm_module
  in

  (* Interpreting. *)
  Logs.info (fun m -> m "Interpreting...");
  Interpret.modul link_state linked_module
