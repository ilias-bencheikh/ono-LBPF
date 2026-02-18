(module 
  (import "ono" "print_cell" (func $print_cell (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))
  (import "env" "grid_width" (global $grid_width i32))
  (import "env" "grid_height" (global $grid_height i32))
  (import "env" "coords_to_index" (func $coords_to_index (param i32 i32) (result i32)))


  (func $print_grid (export "print_grid")
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
      (local.set $cellule (i32.load8_u (local.get $i)))
      (call $print_cell (local.get $cellule))
      (local.set $col (i32.add (local.get $col) (i32.const 1)))
      (br_if $loop (i32.lt_u (local.get $col) (global.get $grid_width)))
    )
  )

)