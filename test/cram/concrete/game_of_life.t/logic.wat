(module 
  (import "env" "grid_width" (global $grid_width i32))
  (import "env" "grid_height" (global $grid_height i32))

  (func $is_alive (param $i i32) (param $j i32) (result i32)
    ;; Vérifie si une cellule est vivante
  )

  (func $count_alive_neighbours (param $i i32) (param $j i32) (result i32)
    ;; Compte les voisins vivants
  )

  (func $should_live (param $i i32) (param $j i32) (result i32)
    ;; Applique les règles du jeu de la vie
  )

  (func $step (export "step")
    ;; Calcule la génération suivante
  )
  
)