(* error.ml *)

let any_errors = ref 0

type error =
  | Internal          of string
  | Illegal_character of char
  | Syntax            of string

type ex = Location.t * error

exception Error of ex

let string_of_error = function
  | Internal s          -> "internal error: " ^ s
  | Illegal_character c -> Printf.sprintf "illegal character '%c'" c
  | Syntax s            -> "invalid syntax at or near " ^ s

let err_msg prefix loc msg =
  incr any_errors;
  Format.printf "%a %s: %s\n" Location.print_loc loc prefix msg

let handle_error loc ex =
  err_msg "Error" loc (string_of_error ex)

let warning           = err_msg "Warning"
let error loc err     = handle_error loc err
let internal msg      = raise (Error (Location.mknoloc (Internal msg)))
