module Interpret : sig
  val modul :
    Symbolic_ono_module.extern_func Owi.Link.State.t ->
    Symbolic_ono_module.extern_func Owi.Linked.Module.t ->
    unit Owi.Symbolic_choice.t
end

val run :
  source_file:Fpath.t ->
  no_stop_at_failure:bool ->
  model_format:Kdo.Symbolic.Model.output_format ->
  model_out_file:Fpath.t option ->
  (unit, Owi.Result.err) result
