(* Error infrastructure. *)

(** Infrastructure de gestion d'erreurs d'exécution de la machine virtuelle. *)
type t =
  [ `Msg of string                 (** Message d'erreur personnalisé. *)
  | `Call_stack_exhausted          (** La pile d'appels est pleine (Stack Overflow). *)
  | `Conversion_to_integer         (** Échec lors de la conversion d'une valeur vers un entier. *)
  | `Integer_divide_by_zero        (** Tentative de division par zéro. *)
  | `Integer_overflow              (** Dépassement de capacité lors d'une opération entière (Overflow). *)
  | `Out_of_bounds_memory_access   (** Accès à une adresse mémoire non allouée (Segmentation fault). *)
  | `Unreachable ]                 (** L'exécution a atteint une instruction "unreachable". *)
