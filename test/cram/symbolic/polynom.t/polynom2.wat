(module
    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))

    ;; Calcul du polynôme avec
    (func $poly (param $x i32) (param $a i32) (param $b i32) (param $c i32) (param $d i32) (result i32)
        ;; Init x**2 et x**3
        (local $x2 i32)
        (local $x3 i32)

        (local.set $x2 (i32.mul (local.get $x) (local.get $x)))
        (local.set $x3 (i32.mul (local.get $x2) (local.get $x)))
        
        ;; Calcul du polynôme
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

    ;; Fonction principale
    (func $main
        ;; Init des variables
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $x i32)
        (local $racine_1 i32)
        (local $racine_2 i32)
        (local $racine_3 i32)
        (local $result_1 i32)
        (local $result_2 i32)
        (local $result_3 i32)

        (local.set $a (call $read_int))
        (local.set $b (call $read_int))
        (local.set $c (call $read_int))
        (local.set $d (call $read_int))

        ;; Génération symbolique
        (local.set $racine_1 (call $i32_symbol))
		(local.set $racine_2 (call $i32_symbol))
		(local.set $racine_3 (call $i32_symbol))

        ;; Borne la recherche sur racine_1 dans [-100, 100]
        (if (i32.or
            (i32.lt_s (local.get $racine_1) (i32.const -100))
            (i32.gt_s (local.get $racine_1) (i32.const 100)))
            (then
                return
            )
        )

		;; Borne la recherche sur racine_2 dans [-100, 100]
        (if (i32.or
            (i32.lt_s (local.get $racine_2) (i32.const -100))
            (i32.gt_s (local.get $racine_2) (i32.const 100)))
            (then
                return
            )
        )

		;; Borne la recherche sur racine_3 dans [-100, 100]
        (if (i32.or
            (i32.lt_s (local.get $racine_3) (i32.const -100))
            (i32.gt_s (local.get $racine_3) (i32.const 100)))
            (then
                return
            )
        )


        ;; Calcul du polynôme
        (local.set $result_1 (call $poly (local.get $racine_1) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
		(local.set $result_2 (call $poly (local.get $racine_2) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
		(local.set $result_3 (call $poly (local.get $racine_3) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))

        ;; Si result_1 == 0 && result_2 == 0 && result_3 == 0
        (if
            (i32.and
                (i32.and
                    (i32.eq (local.get $result_1) (i32.const 0))
                    (i32.eq (local.get $result_2) (i32.const 0)))
                (i32.eq (local.get $result_3) (i32.const 0)))
            (then
                ;; Les racines doivent être différentes (comparer les racines elles-mêmes)
                (if
                    (i32.and
                        (i32.ne (local.get $racine_1) (local.get $racine_2))
                        (i32.ne (local.get $racine_2) (local.get $racine_3)))
                    (then
                        unreachable ;; BUG
                    )
                )
            )
            (else
                return
            )
        )

    )
    (start $main)
)