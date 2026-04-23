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
        ;; Init des coeff
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        (local $x i32)
        (local $result i32)

        (local.set $a (call $read_int))
        (local.set $b (call $read_int))
        (local.set $c (call $read_int))
        (local.set $d (call $read_int))

        ;; Génération symbolique
        (local.set $x (call $i32_symbol))

        ;; Calcul du polynôme
        (local.set $result (call $poly (local.get $x) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))

        ;; Si poly(x) == 0 alors on a trouvé une racine
        (if (i32.eq (local.get $result) (i32.const 0))
            (then
            unreachable ;; BUG
        ) (else
            return
        )
        )

    )
    (start $main)
)