module Compile : sig
  module Wat : sig
    val until_wasm :
      unsafe:bool -> Owi.Text.Module.t -> Owi.Binary.Module.t Owi.Result.t

    val until_link :
      unsafe:bool ->
      name:string option ->
      'a Owi.Link.State.t ->
      Owi.Text.Module.t ->
      ('a Owi.Linked.Module.t * 'a Owi.Link.State.t) Owi.Result.t
  end

  module Wasm = Owi.Compile.Binary
end

module Concrete : sig
  module I32 = Owi.Concrete_i32
  module I64 = Owi.Concrete_i64
  module F32 = Owi.Concrete_f32
  module F64 = Owi.Concrete_f64
  module Extern_func = Owi.Concrete_extern_func
end

module Symbolic : sig
  module I32 = Owi.Symbolic_i32
  module I64 = Owi.Symbolic_i64
  module F32 = Owi.Symbolic_f32
  module F64 = Owi.Symbolic_f64
  module Extern_func = Owi.Symbolic_extern_func
  module Choice = Owi.Symbolic_choice
  module Driver = Owi.Symbolic_driver
  module Parameters = Owi.Symbolic_parameters
  module Model = Owi.Model
end

module Extern = Owi.Extern
module Kind = Owi.Kind

module Link : sig
  module Wasm = Owi.Link.Binary
  module State = Owi.Link.State
  module Extern = Owi.Link.Extern
end

module Linked = Owi.Linked

module Parse : sig
  module Wat = Owi.Parse.Text
  module Wasm = Owi.Parse.Binary
end

module Validate : sig
  module Wasm = Owi.Binary_validate
  module Wat = Owi.Text_validate
end

module Wat = Owi.Text

module Wasm : sig
  type indice = int

  type block_type = Owi.Binary.block_type =
    | Bt_raw of (indice option * Wat.func_type)

  type instr = Owi.Binary.instr =
    | I32_const of Concrete.I32.t
    | I64_const of Concrete.I64.t
    | F32_const of Concrete.F32.t
    | F64_const of Concrete.F64.t
    | V128_const of Owi.Concrete_v128.t
    | I_unop of Wat.nn * Wat.iunop
    | F_unop of Wat.nn * Wat.funop
    | I_binop of Wat.nn * Wat.ibinop
    | F_binop of Wat.nn * Wat.fbinop
    | V_ibinop of Wat.ishape * Wat.vibinop
    | I_testop of Wat.nn * Wat.itestop
    | I_relop of Wat.nn * Wat.irelop
    | F_relop of Wat.nn * Wat.frelop
    | I_extend8_s of Wat.nn
    | I_extend16_s of Wat.nn
    | I64_extend32_s
    | I32_wrap_i64
    | I64_extend_i32 of Wat.sx
    | I_trunc_f of Wat.nn * Wat.nn * Wat.sx
    | I_trunc_sat_f of Wat.nn * Wat.nn * Wat.sx
    | F32_demote_f64
    | F64_promote_f32
    | F_convert_i of Wat.nn * Wat.nn * Wat.sx
    | I_reinterpret_f of Wat.nn * Wat.nn
    | F_reinterpret_i of Wat.nn * Wat.nn
    | Ref_null of Wat.heap_type
    | Ref_is_null
    | Ref_func of indice
    | Drop
    | Select of Wat.val_type list option
    | Local_get of indice
    | Local_set of indice
    | Local_tee of indice
    | Global_get of indice
    | Global_set of indice
    | Table_get of indice
    | Table_set of indice
    | Table_size of indice
    | Table_grow of indice
    | Table_fill of indice
    | Table_copy of indice * indice
    | Table_init of indice * indice
    | Elem_drop of indice
    | I_load of indice * Wat.nn * Wat.memarg
    | F_load of indice * Wat.nn * Wat.memarg
    | I_store of indice * Wat.nn * Wat.memarg
    | F_store of indice * Wat.nn * Wat.memarg
    | I_load8 of indice * Wat.nn * Wat.sx * Wat.memarg
    | I_load16 of indice * Wat.nn * Wat.sx * Wat.memarg
    | I64_load32 of indice * Wat.sx * Wat.memarg
    | I_store8 of indice * Wat.nn * Wat.memarg
    | I_store16 of indice * Wat.nn * Wat.memarg
    | I64_store32 of indice * Wat.memarg
    | Memory_size of indice
    | Memory_grow of indice
    | Memory_fill of indice
    | Memory_copy of indice * indice
    | Memory_init of indice * indice
    | Data_drop of indice
    | Nop
    | Unreachable
    | Block of string option * block_type option * expr Owi.Annotated.t
    | Loop of string option * block_type option * expr Owi.Annotated.t
    | If_else of
        string option
        * block_type option
        * expr Owi.Annotated.t
        * expr Owi.Annotated.t
    | Br of indice
    | Br_if of indice
    | Br_table of indice array * indice
    | Return
    | Return_call of indice
    | Return_call_indirect of indice * block_type
    | Return_call_ref of block_type
    | Call of indice
    | Call_indirect of indice * block_type
    | Call_ref of indice
    | Extern_externalize
    | Extern_internalize

  and expr = instr Owi.Annotated.t list

  val pp_instr : short:bool -> instr Fmt.t
  val iter_expr : (instr -> unit) -> expr Owi.Annotated.t -> unit

  module Func = Owi.Binary.Func
  module Export = Owi.Binary.Export
  module Global = Owi.Binary.Global
  module Data = Owi.Binary.Data
  module Elem = Owi.Binary.Elem
  module Custom = Owi.Binary.Custom

  module Module : sig
    module Exports = Owi.Binary.Module.Exports

    type t = Owi.Binary.Module.t = {
      id : string option;
      types : Wat.Typedef.t array;
      global : (Global.t, Wat.Global.Type.t) Owi__Origin.t array;
      table : (Wat.Table.t, Wat.Table.Type.t) Owi__Origin.t array;
      mem : (Wat.Mem.t, Wat.limits) Owi__Origin.t array;
      func : (Func.t, block_type) Owi__Origin.t array;
      elem : Elem.t array;
      data : Data.t array;
      exports : Exports.t;
      start : indice option;
      custom : Custom.t list;
    }

    val pp : Format.formatter -> t -> unit
  end
end

module Interpret : sig
  module Default_parameters = Owi.Interpret.Default_parameters
  module Concrete = Owi.Interpret.Concrete
  module Symbolic = Owi.Interpret.Symbolic
end

module R = Owi.Result
