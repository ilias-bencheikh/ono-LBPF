(module

  (import "ono" "sleep" (func $sleep (param f32)))
  (import "ono" "print_cell" (func $print_cell (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))
  (import "ono" "random_i32" (func $random_i32 (result i32)))

  ;; initialisation de la grille

  (global $grid_width (mut i32) (i32.const 90))
  (global $grid_height (mut i32) (i32.const 50))

  (memory $mem 1) 

  (func $coords_to_index (param $i i32) (param $j i32) (result i32)
    ;; Convertit (i,j) en index 1D
    ;; return i * grid_width + j
    (i32.add
      (i32.mul (local.get $i) (global.get $grid_width))
      (local.get $j)
    )
  )

  (func $index_to_coords (param $index i32) (result i32 i32)
    ;; Convertit index 1D en (i,j)
    ;; return (index / grid_width, index % grid_width)
    (i32.div_u (local.get $index) (global.get $grid_width))
    (i32.rem_u (local.get $index) (global.get $grid_width))
  )

  (func $init_grid
    ;; Initialise la grille (aléatoire ou depuis config)
    (local $i i32)
    (local $j i32)
    (local.set $i (i32.const 0))
    (loop $loop_i
      (local.set $j (i32.const 0))
      (loop $loop_j
        (i32.store 
          (call $coords_to_index (local.get $i) (local.get $j))
          (i32.and (call $random_i32) (i32.const 1)) ;; 0 ou 1 aléatoire
        )
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $loop_j (i32.lt_u (local.get $j) (global.get $grid_width)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_i (i32.lt_u (local.get $i) (global.get $grid_height)))
    )
  )

  (func $load_config (param $config_ptr i32)
    ;; Charge une configuration initiale
  )

  ;; fonctions de logique du jeu

   (func $is_alive (param $i i32) (param $j i32) (result i32)
    ;; Vérifie si une cellule est vivante
    ;; return 1 si vivant, 0 sinon
    (i32.load (call $coords_to_index (local.get $i) (local.get $j)))
  )

  (func $count_alive_neighbours (param $i i32) (param $j i32) (result i32)
    ;; Compte les voisins vivants
    (local $count i32)
    (local $ni i32)
    (local $nj i32)
    (local.set $count (i32.const 0))

    ;; (i-1, j-1)
    (local.set $ni (i32.sub (local.get $i) (i32.const 1)))
    (local.set $nj (i32.sub (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i-1, j)
    (local.set $ni (i32.sub (local.get $i) (i32.const 1)))
    (local.set $nj (local.get $j))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i-1, j+1)
    (local.set $ni (i32.sub (local.get $i) (i32.const 1)))
    (local.set $nj (i32.add (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i, j-1)
    (local.set $ni (local.get $i))
    (local.set $nj (i32.sub (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i, j+1)
    (local.set $ni (local.get $i))
    (local.set $nj (i32.add (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i+1, j-1)
    (local.set $ni (i32.add (local.get $i) (i32.const 1)))
    (local.set $nj (i32.sub (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i+1, j)
    (local.set $ni (i32.add (local.get $i) (i32.const 1)))
    (local.set $nj (local.get $j))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    ;; (i+1, j+1)
    (local.set $ni (i32.add (local.get $i) (i32.const 1)))
    (local.set $nj (i32.add (local.get $j) (i32.const 1)))
    (if (i32.and
          (i32.and (i32.ge_s (local.get $ni) (i32.const 0)) (i32.lt_s (local.get $ni) (global.get $grid_height)))
          (i32.and (i32.ge_s (local.get $nj) (i32.const 0)) (i32.lt_s (local.get $nj) (global.get $grid_width))))
      (then (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $ni) (local.get $nj))))))

    (local.get $count)
  )

  (func $should_live (param $i i32) (param $j i32) (result i32)
    ;; Applique les règles du jeu de la vie
    ;; return 1 si la cellule doit être vivante dans la prochaine génération, 0 sinon
    (local $alive i32)
    (local $neighbours i32)
    (local $res i32)

    (local.set $alive (call $is_alive (local.get $i) (local.get $j)))
    (local.set $neighbours (call $count_alive_neighbours (local.get $i) (local.get $j)))
    (local.set $res (i32.const 0)) ;; contient le resultat 

    (if
      (i32.ne (local.get $alive) (i32.const 0)) ;; si la cellule est vivante
      (then
        (if ;; si la cellule a 2 ou 3 voisins vivants elle reste vivante 
          (i32.or 
            (i32.eq (local.get $neighbours) (i32.const 2))
            (i32.eq (local.get $neighbours) (i32.const 3))
          )
          (then (local.set $res (i32.const 1)))
        )
      )
      (else
        (if ;; si la cellule est morte et a 3 voisins vivants elle devient vivante
          (i32.eq (local.get $neighbours) (i32.const 3))
          (then (local.set $res (i32.const 1)))
        )
      )
    )

    (local.get $res)
  )

  (func $step
    ;; Calcule la génération suivante
  )

  ;; Fonction affichage 

  (func $print_grid 
    (local $ligne i32)
    (call $clear_screen)
    (local.set $ligne (i32.const 0))
    (loop $loop
      (call $print_row (local.get $ligne))
      (call $newline)
      (local.set $ligne (i32.add (local.get $ligne) (i32.const 1)))
      (br_if $loop (i32.lt_u (local.get $ligne) (global.get $grid_height)))
    )
  )

  (func $print_row (param $ligne i32)
    (local $col i32)
    (local $i i32)
    (local $cellule i32)
    (local.set $col (i32.const 0))
    (loop $loop
      (local.set $i (call $coords_to_index (local.get $ligne) (local.get $col)))
      (local.set $cellule (i32.load8_u (local.get $i)))
      (call $print_cell (local.get $cellule))
      (local.set $col (i32.add (local.get $col) (i32.const 1)))
      (br_if $loop (i32.lt_u (local.get $col) (global.get $grid_width)))
    )
  )

  ;; Fonction de boucle principale
  (func $loop
    (call $print_grid)
    (call $sleep (f32.const 0.1))
    (call $step)
    (call $loop)
  )

  (func $main 
    (call $init_grid)
    (call $loop)
  )

)