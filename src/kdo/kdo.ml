module Compile = struct
  module Wat = struct
    let until_wasm = Owi.Compile.Text.until_binary
    let until_link = Owi.Compile.Text.until_link
  end

  module Wasm = Owi.Compile.Binary
end

module Concrete = struct
  module I32 = Owi.Concrete_i32
  module I64 = Owi.Concrete_i64
  module Extern_func = Owi.Concrete_extern_func
end

module Symbolic = struct
  module I32 = Owi.Symbolic_i32
  module Extern_func = Owi.Symbolic_extern_func
  module Choice = Owi.Symbolic_choice
  module Driver = Owi.Symbolic_driver
  module Parameters = Owi.Symbolic_parameters
  module Model = Owi.Model
end

module Extern = Owi.Extern
module Kind = Owi.Kind

module Link = struct
  module Wasm = Owi.Link.Binary
  module State = Owi.Link.State
  module Extern = Owi.Link.Extern
end

module Linked = Owi.Linked

module Parse = struct
  module Wat = Owi.Parse.Text
  module Wasm = Owi.Parse.Binary
end

module Validate = struct
  module Wasm = Owi.Binary_validate
  module Wat = Owi.Text_validate
end

module Wat = Owi.Text

module Wasm = struct
  include Owi.Binary

  module Module = struct
    include Module

    let pp ppf m =
      let m = Owi.Binary_to_text.modul m in
      Wat.Module.pp ppf m
  end
end

module Interpret = struct
  module Default_parameters = Owi.Interpret.Default_parameters
  module Concrete = Owi.Interpret.Concrete
  module Symbolic = Owi.Interpret.Symbolic
end

module R = Owi.Result
