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

(** Point d'entrée principal pour exécuter l'analyse concrète :

    \source_file : Fpath.t - Le fichier source à analyser.

    \config_file : Fpath.t option - Le fichier de configuration optionnel.

    \max_steps : int option - Le nombre maximum d'étapes à exécuter.

    \display_last : int option - Le nombre d'étapes à afficher en dernier.

    \use_graphical_window : bool - Indique si une fenêtre graphique doit être
    utilisée pour l'affichage. *)
