(** Opérateur de liaison monadique (bind) pour composer les résultats de type (Result.t). *)
val ( let* ) : ('a, 'b) result -> ('a -> ('c, 'b) result) -> ('c, 'b) result

(** Opérateur de mappage (map) fonctionnant sur le type result. *)
val ( let+ ) : ('a, 'b) result -> ('a -> 'c) -> ('c, 'b) result
