type extern_func = Kdo.Concrete.Extern_func.extern_func

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()


let random_i32  (_ : unit) : (Kdo.Concrete.I32.t,_) Result.t = 
  let randint = Random.int32 Int32.max_int in 
  Ok (Kdo.Concrete.I32.of_int32 randint)


let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions = [ 
    ("print_i32", Extern_func (i32 ^->. unit, print_i32));
    ("print_i64", Extern_func (i64 ^->. unit, print_i64));
    ("random_i32", Extern_func (unit ^->. i32 , random_i32))
    ] in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
