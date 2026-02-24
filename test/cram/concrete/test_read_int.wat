(module
  (import "ono" "print_i32" (func $print_i32 (param i32)))
  (import "ono" "read_int" (func $read_int (result i32)))
  (import "ono" "newline" (func $newline))

  (func $main
    ;; Lire la première dimension
    (call $print_i32 (call $read_int))
    (call $newline)
    
    ;; Lire la deuxième dimension
    (call $print_i32 (call $read_int))
    (call $newline)
  )
)
