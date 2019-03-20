(* option.mli *)

val print_lex : unit -> bool
val print_ast : unit -> bool
val print_dot : unit -> bool
val will_run : unit -> bool
val is_maxargs : unit -> bool
val filename : unit -> string
val channel : unit -> in_channel

val parse_cmdline : unit -> unit
