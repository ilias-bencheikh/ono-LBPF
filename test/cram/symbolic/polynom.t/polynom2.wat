(module
    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))

    ;; x^2
    (func $square (param $x i32) (result i32)
        (i32.mul (local.get $x) (local.get $x))
    )

    ;; x^3
    (func $cube (param $x i32) (result i32)
        (i32.mul (local.get $x) (call $square (local.get $x)))
    )

    ;; Calcul du discriminant d'un polynôme de degré 3
    ;; Delta = 18abcd - 4b^3d + b^2c^2 - 4ac^3 - 27a^2d^2
    (func $delta (param $a i32) (param $b i32) (param $c i32) (param $d i32) (result i32)
        (local $term1 i32)
        (local $term2 i32)
        (local $term3 i32)
        (local $term4 i32)
        (local $term5 i32)

        ;; 18abcd
        (local.set $term1
        (i32.mul
            (i32.mul
            (i32.mul (i32.const 18) (local.get $a))
            (local.get $b))
            (i32.mul (local.get $c) (local.get $d))))

        ;; -4b^3d
        (local.set $term2
        (i32.mul
            (i32.mul (i32.const -4) (call $cube (local.get $b)))
            (local.get $d)))

        ;; b^2c^2
        (local.set $term3
        (i32.mul
            (call $square (local.get $b))
            (call $square (local.get $c))))

        ;; -4ac^3
        (local.set $term4
        (i32.mul
            (i32.mul (i32.const -4) (local.get $a))
            (call $cube (local.get $c))))

        ;; -27a^2d^2
        (local.set $term5
        (i32.mul
            (i32.mul (i32.const -27) (call $square (local.get $a)))
            (call $square (local.get $d))))

        ;; Somme des termes
        local.get $term1
        local.get $term2
        i32.add
        local.get $term3
        i32.add
        local.get $term4
        i32.add
        local.get $term5
        i32.add
    )

    ;; Calcul du polynôme
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

    ;; delta < 0, alors il existe qu'une racine réelle
    (func $check_negative_delta (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        (local $racine i32)
        (local $result i32)

        ;; Génération symbolique
        (local.set $racine (call $i32_symbol))

        ;; Borne la recherche sur x dans [-100, 100]
        (if (i32.or
            (i32.lt_s (local.get $racine) (i32.const -100))
            (i32.gt_s (local.get $racine) (i32.const 100)))
            (then
                return
            )
        )

        (local.set $result
            (call $poly
                (local.get $racine)
                (local.get $a)
                (local.get $b)
                (local.get $c)
                (local.get $d)
            )
        )

        (if (i32.eq (local.get $result) (i32.const 0))
            (then
                unreachable ;; BUG
            )
        )
    )

    ;; delta == 0, une racine triple si b^2 == 3ac, sinon une racine double et une simple  
    (func $check_zero_delta (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        ;; Init des variables
        (local $racine_1 i32)
        (local $racine_2 i32)
        (local $result_1 i32)
        (local $result_2 i32)

        ;; b^2 == 3ac
        (if (i32.eq
                (call $square (local.get $b))
                (i32.mul (i32.const 3) (i32.mul (local.get $a) (local.get $c)))
            )
            (then
                ;; Racine triple, on vérifie que poly(racine) == 0
                (call $check_negative_delta (local.get $a) (local.get $b) (local.get $c) (local.get $d))
            )
            
            ;; Sinon trouver une racine double et une simple (en tout deux racines différentes à return)
            (else

                ;; Génération symbolique
                (local.set $racine_1 (call $i32_symbol))
                (local.set $racine_2 (call $i32_symbol))

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

            ;; Calcul des polynômes
            (local.set $result_1 (call $poly (local.get $racine_1) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
	    	(local.set $result_2 (call $poly (local.get $racine_2) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))

            ;; result_1 == 0 && result_2 == 0 && result_1 != result_2        
            (if
                (i32.and
                    (i32.and
                        (i32.eq (local.get $result_1) (i32.const 0))
                        (i32.eq (local.get $result_2) (i32.const 0))
                    )
                    (i32.ne (local.get $racine_1) (local.get $racine_2))
                )
                (then
                    unreachable ;; BUG
                )        
            )
        )
    ))

    (func $check_positive_delta (param $a i32) (param $b i32) (param $c i32) (param $d i32)
        ;; Init des variables
        (local $racine_1 i32)
        (local $racine_2 i32)
        (local $racine_3 i32)
        (local $result_1 i32)
        (local $result_2 i32)
        (local $result_3 i32)

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
                        (i32.and
                        (i32.ne (local.get $racine_1) (local.get $racine_2))
                        (i32.ne (local.get $racine_2) (local.get $racine_3))
                        )
                        (i32.ne (local.get $racine_1) (local.get $racine_3))
                    )

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



    (func $main
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $x i32)
        (local $disc i32)
        (local $result i32)

        (local.set $a (call $read_int))
        (local.set $b (call $read_int))
        (local.set $c (call $read_int))
        (local.set $d (call $read_int))

        (local.set $disc (call $delta (local.get $a) (local.get $b) (local.get $c) (local.get $d)))

        ;; Si delta < 0
        (if (i32.lt_s (local.get $disc) (i32.const 0))
            (then
                (call $check_negative_delta (local.get $a) (local.get $b) (local.get $c) (local.get $d))
            )
        )
        ;; Si delta == 0, 
        (if (i32.eq (local.get $disc) (i32.const 0))
            (then
                (call $check_zero_delta (local.get $a) (local.get $b) (local.get $c) (local.get $d))
            )
        )
        ;; Si delta > 0
        (if (i32.gt_s (local.get $disc) (i32.const 0))
            (then
                (call $check_positive_delta (local.get $a) (local.get $b) (local.get $c) (local.get $d))
            )
        )

    )

     (start $main)
)