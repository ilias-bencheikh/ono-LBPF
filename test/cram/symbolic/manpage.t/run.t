Test the output of the man page:
  $ ono symbolic --help=plain
  NAME
         ono-symbolic
  
  SYNOPSIS
         ono symbolic [OPTION]… FILE
  
  ARGUMENTS
         FILE (required)
             Source file to analyze.
  
  OPTIONS
         --constraint=N (absent=0)
             Constraint number to use for symbolic Game of Life executions.
  
         --export-config
             Export the first symbolic Game of Life model to
             test/config/out.json and test/config/out.life.
  
         --grid-height=HEIGHT (absent=3)
             Grid height to use for symbolic Game of Life executions.
  
         --grid-width=WIDTH (absent=3)
             Grid width to use for symbolic Game of Life executions.
  
         -n N (absent=0)
             N parameter for symbolic Game of Life constraints that need it.
  
         --no-stop-at-failure
             Continue symbolic exploration after a failure instead of stopping
             at the first one.
  
         -x X (absent=0)
             X coordinate for symbolic Game of Life constraints that need it.
  
         --x-prime=X_PRIME (absent=0)
             Second X coordinate for line constraints in symbolic Game of Life.
  
         -y Y (absent=0)
             Y coordinate for symbolic Game of Life constraints that need it.
  
         --y-prime=Y_PRIME (absent=0)
             Second Y coordinate for column constraints in symbolic Game of
             Life.
  
  COMMON OPTIONS
         --color=WHEN (absent=auto)
             Colorize the output. WHEN must be one of auto, always or never.
  
         --help[=FMT] (default=auto)
             Show this help in format FMT. The value FMT must be one of auto,
             pager, groff or plain. With auto, the format is pager or plain
             whenever the TERM env var is dumb or undefined.
  
         -q, --quiet
             Be quiet. Takes over -v and --verbosity.
  
         -v, --verbose
             Increase verbosity. Repeatable, but more than twice does not bring
             more.
  
         --verbosity=LEVEL (absent=warning or ONO_VERBOSITY env)
             Be more or less verbose. LEVEL must be one of quiet, error,
             warning, info or debug. Takes over -v.
  
         --version
             Show version information.
  
  EXIT STATUS
         ono symbolic exits with:
  
         0   on success.
  
         1   on conversion to integer error in Wasm code.
  
         2   on unreachable instruction in Wasm code.
  
         3   on division by zero in Wasm code.
  
         4   on integer overflow in Wasm code.
  
         5   on stack overflow in Wasm code.
  
         6   on out of bounds memory access in Wasm code.
  
         123 on indiscriminate errors reported on standard error.
  
         124 on command line parsing errors.
  
         125 on unexpected internal errors (bugs).
  
  ENVIRONMENT
         These environment variables affect the execution of ono symbolic:
  
         ONO_VERBOSITY
             See option --verbosity.
  
  SEE ALSO
         ono(1)
  
