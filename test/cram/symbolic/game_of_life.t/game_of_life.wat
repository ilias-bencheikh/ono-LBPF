(module

    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))



    ;;Nombre des contraintes -1 
    (global $nb_constraints i32 (i32.const 16))


    ;; initialisation de la grille
    (global $grid_width (mut i32) (i32.const 5))
    (global $grid_height (mut i32) (i32.const 5))


    ;; Reserve une page de memoire
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
          (call $should_live (local.get $i)(local.get $j))
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


  ;;Les contraintes

  ;;Contrainte numero 1 (is_alive etant le num 0)
  (func $is_dead (param $i i32) (param $j i32) (result i32)
    ;; Vérifie si une cellule est morte
    ;; return 1 si mort, 0 sinon
    (i32.eqz (i32.load (call $coords_to_index (local.get $i) (local.get $j))))
  )
  ;; 2. Au moins une vivante sur la grille
  (func $at_least_one_alive (result i32) (i32.const 0))

  ;; 3. Toutes les cellules sont vivantes
  (func $all_alive (result i32) (i32.const 0))

  ;; 4. Toutes les cellules sont mortes
  (func $all_dead (result i32) (i32.const 0))

  ;; 5. Ligne complète entre (x, y) et (x', y)
  (func $full_line (param $x i32) (param $y i32) (param $x_prime i32) (result i32)
    (local $i i32)
    (local $min_x i32)
    (local $max_x i32)
    (local.set $min_x (local.get $x))
    (local.set $max_x (local.get $x_prime))
    (if (i32.gt_s (local.get $x) (local.get $x_prime))
      (then
        (local.set $min_x (local.get $x_prime))
        (local.set $max_x (local.get $x))
      )
    )
    (local.set $i (local.get $min_x))
    (loop $loop_line
      (if (i32.eqz (call $is_alive (local.get $y) (local.get $i)))
        (then (return (i32.const 0)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_line (i32.le_s (local.get $i) (local.get $max_x)))
    )
    (i32.const 1)
  )

  ;; 6. Colonne complète entre (x, y) et (x, y')
  (func $full_column (param $x i32) (param $y i32) (param $y_prime i32) (result i32)
    (local $j i32)
    (local $min_y i32)
    (local $max_y i32)
    (local.set $min_y (local.get $y))
    (local.set $max_y (local.get $y_prime))
    (if (i32.gt_s (local.get $y) (local.get $y_prime))
      (then
        (local.set $min_y (local.get $y_prime))
        (local.set $max_y (local.get $y))
      )
    )
    (local.set $j (local.get $min_y))
    (loop $loop_column
      (if (i32.eqz (call $is_alive (local.get $j) (local.get $x)))
        (then (return (i32.const 0)))
      )
      (local.set $j (i32.add (local.get $j) (i32.const 1)))
      (br_if $loop_column (i32.le_s (local.get $j) (local.get $max_y)))
    )
    (i32.const 1)
  )

  ;; 7. Exactement N cellules vivantes
  (func $exactly_n_alive (param $n i32) (result i32)
    (local $i i32)
    (local $j i32)
    (local $count i32)
    (local.set $count (i32.const 0))
    (local.set $i (i32.const 0))
    (loop $loop_count_i
      (local.set $j (i32.const 0))
      (loop $loop_count_j
        (local.set $count (i32.add (local.get $count) (call $is_alive (local.get $i) (local.get $j))))
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $loop_count_j (i32.lt_u (local.get $j) (global.get $grid_width)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_count_i (i32.lt_u (local.get $i) (global.get $grid_height)))
    )
    (i32.eq (local.get $count) (local.get $n))
  )

  ;; 8. Existe une cellule isolée
  (func $has_isolated_cell (result i32)
    (local $i i32)
    (local $j i32)
    (local.set $i (i32.const 0))
    (loop $loop_isolated_i
      (local.set $j (i32.const 0))
      (loop $loop_isolated_j
        (if (call $is_alive (local.get $i) (local.get $j))
          (then
            (if (i32.eqz (call $count_alive_neighbours (local.get $i) (local.get $j)))
              (then (return (i32.const 1)))
            )
          )
        )
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $loop_isolated_j (i32.lt_u (local.get $j) (global.get $grid_width)))
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_isolated_i (i32.lt_u (local.get $i) (global.get $grid_height)))
    )
    (i32.const 0)
  )

  ;; 9. Existe une cellule entourée de vivantes
  (func $has_surrounded_cell (result i32) (i32.const 0))

  ;; 10. Existe deux vivantes côte à côte
  (func $has_two_adjacent_alive (result i32) (i32.const 0))

  ;; 11. Existe un motif en "L" (3 cellules)
  (func $has_l_pattern (result i32) (i32.const 0))

  ;; 12. Existe un motif carré 2*2
  (func $has_square_pattern (result i32) (i32.const 0))

  ;; 13. Une cellule morte est devenue vivante
  (func $dead_to_alive_transition (result i32) (i32.const 0))

  ;; 14. Alternance vivante/morte sur ligne/colonne
  (func $has_alternating_pattern (result i32) (i32.const 0))

  ;; 15. Motif clignotant (oscillateur période 2)
  (func $has_blinker_pattern (result i32) (i32.const 0))

  ;; 16. Diagonale vivante de N cellules
  (func $has_diagonal_n (param $n i32) (result i32) (i32.const 0))


  ;; Gros match permetant de selectionner la bonne contrainte
  (func $select_constraint (param $num_constraint i32) (param $x i32) (param $y i32) (param $x_prime i32) (param $y_prime i32) (param $n i32) (result i32)

    (local $res i32)

    (if (i32.eq (local.get $num_constraint) (i32.const 0))
      (then (local.set $res (call $is_alive (local.get $x) (local.get $y))))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 1))
      (then (local.set $res (call $is_dead (local.get $x) (local.get $y))))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 2))
      (then (local.set $res (call $at_least_one_alive)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 3))
      (then (local.set $res (call $all_alive)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 4))
      (then (local.set $res (call $all_dead)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 5))
      (then (local.set $res (call $full_line (local.get $x) (local.get $y) (local.get $x_prime))))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 6))
      (then (local.set $res (call $full_column (local.get $x) (local.get $y) (local.get $y_prime))))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 7))
      (then (local.set $res (call $exactly_n_alive (local.get $n))))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 8))
      (then (local.set $res (call $has_isolated_cell)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 9))
      (then (local.set $res (call $has_surrounded_cell)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 10))
      (then (local.set $res (call $has_two_adjacent_alive)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 11))
      (then (local.set $res (call $has_l_pattern)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 12))
      (then (local.set $res (call $has_square_pattern)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 13))
      (then (local.set $res (call $dead_to_alive_transition)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 14))
      (then (local.set $res (call $has_alternating_pattern)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 15))
      (then (local.set $res (call $has_blinker_pattern)))
    (else (if (i32.eq (local.get $num_constraint) (i32.const 16))
      (then (local.set $res (call $has_diagonal_n (local.get $n))))
    )))))))))))))))))))))))))))))))))
    
    (local.get $res)
  )




    (func $main 

        
        (local $num_constraint i32)
        (local $i i32) 
        (local $j i32)
        (local $x i32)
        (local $y i32)
        (local $x_prime i32)
        (local $y_prime i32)
        (local $n i32)
        (local $cell i32)


        (call $read_dimensions)
        ;;Le num de la contrainte 
        (local.set $num_constraint (call $read_int))
        (if (i32.gt_s (local.get $num_constraint) (global.get $nb_constraints ))
          (then return)
        )

        (local.set $x (call $read_int))
        (local.set $y (call $read_int))
        (local.set $x_prime (call $read_int))
        (local.set $y_prime (call $read_int))
        (local.set $n (call $read_int))
        

        (local.set $i (i32.const 0))

        ;;Remplit la grille de valeurs symboliques 
        (loop $loop_i
            (local.set $j (i32.const 0))
            (loop $loop_j 
                (local.set $cell (call $i32_symbol))
                ;;On limite au valeurs (0,1)
                (if (i32.or
                    (i32.lt_s (local.get $cell) (i32.const 0))
                    (i32.gt_s (local.get $cell) (i32.const 1)))
                    (then
                        return
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

        ;;tour suivant
        (call $step)

        ;;contraintes ()
        (if (call $select_constraint (local.get $num_constraint) (local.get $x) (local.get $y) (local.get $x_prime) (local.get $y_prime) (local.get $n)) 
          (then unreachable)
          (else return )
        )
   
        
    )

    (start $main)
)