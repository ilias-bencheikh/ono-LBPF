(module
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $newline (import "ono" "newline"))
  (func $clear_screen (import "ono" "clear_screen"))
  (func $sleep (import "ono" "sleep") (param f32))

  (func $main
    ;; "🦊 🦊"
    i32.const 1
    call $print_cell
    i32.const 0
    call $print_cell
    i32.const 1
    call $print_cell
    call $newline

    ;; " 🦊 "
    i32.const 0
    call $print_cell
    i32.const 1
    call $print_cell
    i32.const 0
    call $print_cell
    call $newline

    ;; "🦊 🦊"
    i32.const 1
    call $print_cell
    i32.const 0
    call $print_cell
    i32.const 1
    call $print_cell
    call $newline

    ;; Affichage
    call $clear_screen
  )
  
  (start $main)
)
