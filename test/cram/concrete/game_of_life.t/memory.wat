(module 
  (import "env" "grid_width" (global $grid_width i32))
  (import "env" "grid_height" (global $grid_height i32))

  (memory $mem 1) 

  (func $coords_to_index (param $i i32) (param $j i32) (result i32) (export "coords_to_index")
  ;; Convertit (i,j) en index 1D
  )

  (func $index_to_coords (param $index i32) (result i32 i32)
  ;; Convertit index 1D en (i,j)
  )
)