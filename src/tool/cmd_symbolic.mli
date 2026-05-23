val info : Cmdliner.Cmd.info
val term : (unit, [> `Msg of string ]) result Cmdliner.Term.t
val cmd : Ono_cli.outcome Cmdliner.Cmd.t
