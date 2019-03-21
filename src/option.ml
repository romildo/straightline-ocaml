(* option.ml *)


let lex     = ref false
let ast     = ref false
let dot     = ref false
let run     = ref true
let maxargs = ref false
let file    = ref ""
let inch    = ref stdin

let print_lex ()  = !lex
let print_ast ()  = !ast
let print_dot ()  = !dot
let will_run ()   = !run
let is_maxargs () = !maxargs
let filename ()   = !file
let channel ()    = !inch

let set_input s =
  try
    file := s;
    inch := open_in s
  with Sys_error err ->
    raise (Arg.Bad ("Could not open file " ^ err))


let usage_msg = "Usage: " ^ "driver" ^ " [OPTION]... FILE\n"

let rec usage () =
  Arg.usage options usage_msg;
  exit 0

and options =
  [ "-lex",     Arg.Set lex,     "\t\tDisplay sequence of lexical symbols"
  ; "-ast",     Arg.Set ast,     "\t\tDisplay abstract syntax tree"
  ; "-dot",     Arg.Set dot,     "\t\tGenerate abstract syntax tree as a dot program"
  ; "-run",     Arg.Set run,     "\t\tRun the input program"
  ; "-maxargs", Arg.Set maxargs, "\tCalculate maximum number of arguments in a print statement"
  ; "-help",    Arg.Unit usage,  "\tDisplay this list of options"
  ; "--help",   Arg.Unit usage,  "\tDisplay this list of options"
  ]

let parse_cmdline () =
  Arg.parse options set_input usage_msg

