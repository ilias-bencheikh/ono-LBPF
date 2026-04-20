(module
    (func $read_int (import "ono" "read_int") (result i32))
    (func $i32_symbol (import "ono" "i32_symbol") (result i32))
    (func $print_i32  (import "ono" "print_i32") (param i32))

    ;; Calcul du polynôme avec
    (func $poly (param $a i32) (param $b i32) (param $c i32) (param $d i32) (result i32)
        ;; Init x, x**2 et x**3
        (local $x i32)
        (local $x2 i32)
        (local $x3 i32)

        ;; Génération symbolique
        (local.set $x (call $i32_symbol))
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
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)

        (local.set $a (call $read_int))
        (local.set $b (call $read_int))
        (local.set $c (call $read_int))
        (local.set $d (call $read_int))

        ;; Calcul du polynôme
        (call $poly (local.get $a) (local.get $b) (local.get $c) (local.get $d))

        ;; Comparaison
        i32.const 0
        i32.eq

        (if (then
            unreachable ;; BUG
        ) (else
            return
        )
        )

    )
    (start $main)
)