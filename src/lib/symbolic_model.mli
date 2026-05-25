type configuration = Concrete_ono_common.configuration

val configuration_of_json_file :
  width:int ->
  height:int ->
  Fpath.t ->
  (configuration, [> `Msg of string ]) result

val write_life_file :
  configuration -> Fpath.t -> (unit, [> `Msg of string ]) result
