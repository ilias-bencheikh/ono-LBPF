(module
    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))

    ;; Calcul du polynôme
    (func $poly (param $x i32) (param $a i32) (param $b i32) (param $c i32) (param $d i32) (result i32)
        (local $x2 i32)
        (local $x3 i32)
        (local.set $x2 (i32.mul (local.get $x) (local.get $x)))
        (local.set $x3 (i32.mul (local.get $x2) (local.get $x)))

        local.get $a
        local.get $x3
        i32.mul

        local.get $b
        local.get $x2
        i32.mul

        local.get $c
        local.get $x
        i32.mul

        local.get $d
        i32.add
        i32.add
        i32.add
        return
    )

    ;; Fonction principale: recherche par niveaux
    (func $main
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $r1 i32)
        (local $r2 i32)
        (local $r3 i32)
        (local $res1 i32)
        (local $res2 i32)
        (local $res3 i32)

        (local.set $a (call $read_int))
        (local.set $b (call $read_int))
        (local.set $c (call $read_int))
        (local.set $d (call $read_int))

        ;; Génération symbolique de trois candidats
        (local.set $r1 (call $i32_symbol))
        (local.set $r2 (call $i32_symbol))
        (local.set $r3 (call $i32_symbol))

        ;; Borne les recherches dans [-100,100]
        (if (i32.or (i32.lt_s (local.get $r1) (i32.const -100)) (i32.gt_s (local.get $r1) (i32.const 100))) (then (return)))
        (if (i32.or (i32.lt_s (local.get $r2) (i32.const -100)) (i32.gt_s (local.get $r2) (i32.const 100))) (then (return)))
        (if (i32.or (i32.lt_s (local.get $r3) (i32.const -100)) (i32.gt_s (local.get $r3) (i32.const 100))) (then (return)))

        ;; Canonical order: r1 <= r2 <= r3 to avoid permutations of same solution
        (if (i32.gt_s (local.get $r1) (local.get $r2)) (then (return)))
        (if (i32.gt_s (local.get $r2) (local.get $r3)) (then (return)))

        ;; Évaluer le polynôme en chaque candidat
        (local.set $res1 (call $poly (local.get $r1) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
        (local.set $res2 (call $poly (local.get $r2) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
        (local.set $res3 (call $poly (local.get $r3) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))

                ;; Niveau 3: trois racines distinctes
                (if (i32.and
                            (i32.and (i32.eq (local.get $res1) (i32.const 0)) (i32.eq (local.get $res2) (i32.const 0)))
                            (i32.and (i32.eq (local.get $res3) (i32.const 0)) (i32.and (i32.ne (local.get $r1) (local.get $r2)) (i32.ne (local.get $r2) (local.get $r3)))))
                        (then (unreachable)))

                ;; Niveau 2: exactement deux racines (avec canonical order r1<=r2<=r3,
                ;; the two-equal cases are r1==r2<r3 or r1<r2==r3)
                ;; case r1==r2 != r3
                (if (i32.and
                            (i32.and (i32.eq (local.get $res1) (i32.const 0)) (i32.eq (local.get $res2) (i32.const 0)))
                            (i32.and (i32.ne (local.get $res3) (i32.const 0)) (i32.eq (local.get $r1) (local.get $r2))))
                        (then (unreachable)))
                ;; case r2==r3 != r1
                (if (i32.and
                            (i32.and (i32.eq (local.get $res2) (i32.const 0)) (i32.eq (local.get $res3) (i32.const 0)))
                            (i32.and (i32.ne (local.get $res1) (i32.const 0)) (i32.eq (local.get $r2) (local.get $r3))))
                        (then (unreachable)))

                ;; Niveau 1: exactement une racine (les deux autres ne sont pas racines)
                (if (i32.and (i32.eq (local.get $res1) (i32.const 0)) (i32.and (i32.ne (local.get $res2) (i32.const 0)) (i32.ne (local.get $res3) (i32.const 0)))) (then (unreachable)))
                (if (i32.and (i32.eq (local.get $res2) (i32.const 0)) (i32.and (i32.ne (local.get $res1) (i32.const 0)) (i32.ne (local.get $res3) (i32.const 0)))) (then (unreachable)))
                (if (i32.and (i32.eq (local.get $res3) (i32.const 0)) (i32.and (i32.ne (local.get $res1) (i32.const 0)) (i32.ne (local.get $res2) (i32.const 0)))) (then (unreachable)))

        return
    )
    (start $main)
)
