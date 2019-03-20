(* error.mli *)

type error =
  | Internal          of string
  | Illegal_character of char
  | Syntax            of string

type ex = Location.t * error

exception Error of ex

val any_errors   : int ref
val err_msg      : string -> Location.t -> string -> unit
val handle_error : Location.t -> error -> unit
val error        : Location.t -> error -> unit
val warning      : Location.t -> string -> unit
val internal     : string -> 'a
