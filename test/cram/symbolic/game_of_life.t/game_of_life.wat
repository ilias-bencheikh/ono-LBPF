(module

    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))


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


    (func $main 

        

        (local $i i32)
        (local $j i32)
        (local $x i32)
        (local $y i32) 
        (local $cell i32)


        (call $read_dimensions)

        (local.set $x (call $read_int))
        (local.set $y (call $read_int))


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

        ;;contrainte ()

        (if 
            (call $is_alive (local.get $x)(local.get $y))
            (then unreachable)
            (else return)

        )
        
    )

    (start $main)
)