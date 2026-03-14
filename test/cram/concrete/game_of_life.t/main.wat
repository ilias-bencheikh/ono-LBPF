(module

  (import "ono" "sleep" (func $sleep (param f32)))
  (import "ono" "print_cell" (func $print_cell (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))
  (import "ono" "random_i32" (func $random_i32 (result i32)))
  (import "ono" "read_int" (func $read_int (result i32)))
  (import "ono" "get_max_steps" (func $get_max_steps (result i32)))
  (import "ono" "get_display_last" (func $get_display_last (result i32)))
  (import "ono" "has_config" (func $has_config (result i32)))
  (import "ono" "get_width" (func $get_width (result i32)))
  (import "ono" "get_height" (func $get_height (result i32)))
  (import "ono" "get_cells_len" (func $get_cells_len (result i32)))
  (import "ono" "get_ix" (func $get_ix (param i32) (result i32)))
  (import "ono" "get_iy" (func $get_iy (param i32) (result i32)))


  ;; initialisation de la grille
  
  (global $grid_width (mut i32) (i32.const 50))
  (global $grid_height (mut i32) (i32.const 30))

  ;; compteur de génération
  (global $current_step (mut i32) (i32.const 0))
  (global $max_steps (mut i32) (i32.const -1))
  (global $display_last (mut i32) (i32.const -1))

  (memory $mem 1) 

  (func $coords_to_index (param $i i32) (param $j i32) (result i32)
    ;; Convertit (i,j) en index 1D
    ;; return (i * grid_width + j) * 4 (offset mémoire en bytes pour un i32)
    (i32.shl
      (i32.add
        (i32.mul (local.get $i) (global.get $grid_width))
        (local.get $j)
      )
      (i32.const 2)
    )
  )

  (func $index_to_coords (param $index i32) (result i32 i32)
    ;; Convertit index 1D en (i,j)
    ;; return ((index / 4) / grid_width, (index / 4) % grid_width)
    (i32.div_u
      (i32.shr_u (local.get $index) (i32.const 2))
      (global.get $grid_width)
    )
    (i32.rem_u
      (i32.shr_u (local.get $index) (i32.const 2))
      (global.get $grid_width)
    )
  )

  (func $init_grid 
    ;; Initialise la grille (aléatoire ou depuis config)
    (local $i i32)
    (local $j i32)
    (local $cell i32)
    (global.set $max_steps (call $get_max_steps))
    (global.set $display_last (call $get_display_last))
    (local.set $i (i32.const 0))
    (loop $loop_i
      (local.set $j (i32.const 0))
      (loop $loop_j
        ;;On choisis la valeur de la cellule (0 ou 1)
        (if (call $has_config) 
            (then 
              (local.set $cell (i32.const 0));; On initialise tout a 0 
              )
            (else
              (local.set $cell(i32.and (call $random_i32) (i32.const 1))) ;; 0 ou 1 aléatoire 
            )
          )
        (i32.store 
          (call $coords_to_index (local.get $i) (local.get $j))
          (local.get $cell)
        )
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $loop_j (i32.lt_u (local.get $j) (global.get $grid_width)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_i (i32.lt_u (local.get $i) (global.get $grid_height)))
    )
    (if (call $has_config)
      (then (call $load_config))
    )
  )

  (func $load_config 
    ;; Charge une configuration initiale
    (local $i i32)
    (local $cells_len i32)

    (local.set $cells_len (call $get_cells_len))
    (local.set $i (i32.const 0))
    (loop $loop_cells
      (i32.store
        (call $coords_to_index (call $get_ix (local.get $i))(call $get_iy (local.get $i)))
        (i32.const 1)
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_cells (i32.lt_u (local.get $i) (local.get $cells_len )))
    )
  )


  (func $get_and_set_dimensions
    ;; Recupere et applique au var global les dimensions depuis les fonctions externe Ono
    (global.set $grid_width (call $get_width))
    (global.set $grid_height (call $get_height))
  )

  (func $read_dimensions
    ;; Lit les dimensions du jeu depuis l'entrée utilisateur
    (global.set $grid_width (call $read_int))
    (global.set $grid_height (call $read_int))
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
    (local $i i32)
    (local $j i32)
    (local $k i32)

    ;;offset pour la deuxième grille
    (local $offset i32)
    (local.set $offset 
      (i32.shl
        (i32.mul (global.get $grid_height) (global.get $grid_width))
        (i32.const 2)
      )
    )
    (local.set $i (i32.const 0))
    (loop $loop_heigth
      (local.set $j (i32.const 0))
      (loop $loop_width 
        ;;on store dans la 2eme grille en vie ou non
        (i32.store 
          (i32.add 
            (call $coords_to_index (local.get $i) (local.get $j))
            (local.get $offset)
          )
          (i32.or
            (call $should_live (local.get $i)(local.get $j))
            ( i32.eq (i32.rem_u (call $random_i32) (i32.const 10000) ) (i32.const 0) )  
          )
        )
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $loop_width (i32.lt_u (local.get $j) (global.get $grid_width)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_heigth (i32.lt_u (local.get $i) (global.get $grid_height)))
    )
    ;;on store les resultat de la 2eme grille dans la première 
    (local.set $k (i32.const 0))
    (loop $loop_copy
      (i32.store
        (local.get $k)
        (i32.load
          (i32.add
            (local.get $offset)
            (local.get $k )
          )
        )
      )
      (local.set $k (i32.add (local.get $k)(i32.const 1)))
      (br_if $loop_copy (i32.lt_u (local.get $k) (local.get $offset)))
    )
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
      (local.set $cellule (i32.load (local.get $i)))
      (call $print_cell (local.get $cellule))
      (local.set $col (i32.add (local.get $col) (i32.const 1)))
      (br_if $loop (i32.lt_u (local.get $col) (global.get $grid_width)))
    )
  )

  ;; Fonction de boucle principale
  (func $loop
    ;; vérification du step : max_steps == -1 (pas de limite) OU current_step <= max_steps
    (if (i32.or
      (i32.eq (global.get $max_steps) (i32.const -1)) ;; pas de limite
      (i32.le_u (global.get $current_step) (global.get $max_steps)))
    (then
      ;; vérification du diplay_last : display_last == -1 (pas de limite) OU current_step >= max_steps - display_last
      (if (i32.or
        (i32.eq (global.get $display_last) (i32.const -1))  ;; pas de limite
        (i32.ge_u 
          (global.get $current_step)
          (i32.sub 
            (global.get $max_steps)
            (global.get $display_last)
          )
        )
      )
      (then
        ;; Affichager la grille
        (if (i32.gt_u (global.get $current_step) (i32.const 0))
          (then
            ;; Sépérateur entre les générations
            (call $newline)
          )
        )
        (call $print_grid)
      ))
      
      (call $sleep (f32.const 100))
      (call $step)
      
      ;; incrémentation du compteur
      (global.set $current_step (i32.add (global.get $current_step) (i32.const 1)))
      
      (call $loop)
    )
    )
  )

  (func $main 
    (if (call $has_config)
      (then 
        (call $get_and_set_dimensions)
      )
      (else
        (call $read_dimensions)
      )
    )
    (call $init_grid)
    (call $loop)
    
  )
  (start $main)
)