(module 
  
  (global $grid_width (mut i32) (i32.const 90) (export "grid_width"))
  (global $grid_height (mut i32) (i32.const 50) (export "grid_height"))

  (func $init_grid (export "init_grid")
    ;; Initialise la grille (aléatoire ou depuis config)
  )

  (func $load_config (param $config_ptr i32)
    ;; Charge une configuration initiale
  )
)