module Interpret : sig
  val modul :
    Owi.Concrete_extern_func.extern_func Owi.Link.State.t ->
    Owi.Concrete_extern_func.extern_func Owi.Linked.Module.t ->
    unit Owi.Result.t
end

val run :
  source_file:Fpath.t ->
  config_file:Fpath.t option ->
  max_steps:int option ->
  display_last:int option ->
  use_graphical_window:bool ->
  (unit, Owi.Result.err) result
