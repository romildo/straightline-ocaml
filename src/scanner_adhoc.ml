(* scanner for the straigh-line programming language *)

type token =
  | TokSemicolumn
  | TokId of string
  | TokAssign
  | TokPrint
  | TokLParen
  | TokRParen
  | TokComma
  | TokNum of float
  | TokPlus
  | TokMinus
  | TokTimes
  | TokDiv
  | TokEOF

let string_of_token = function
  | TokSemicolumn -> "TokSemicolumn"
  | TokId x -> "TokId[" ^ x ^ "]"
  | TokAssign -> "TokAssign"
  | TokPrint -> "TokAssign"
  | TokLParen -> "TokLParen"
  | TokRParen -> "TokRParen"
  | TokComma -> "TokComma"
  | TokNum x -> "TokNum[" ^ string_of_float x ^ "]"
  | TokPlus -> "TokPlus"
  | TokMinus -> "TokMinus"
  | TokTimes -> "TokTimes"
  | TokDiv -> "TokDiv"
  | TokEOF -> "TokEOF"

type scanner_buffer =
  { mutable buffer : char list;
    channel : in_channel
  }

let get_char sbuffer =
  match sbuffer.buffer with
  | c::cs ->
       sbuffer.buffer <- cs;
       Some c
  | [] ->
       try
         Some (input_char sbuffer.channel)
       with
         End_of_file -> None

let unget_char sbuffer c =
  sbuffer.buffer <- c :: sbuffer.buffer

let scanner_buffer_from_channel channel =
  { buffer = []; channel = channel }

let is_digit c =
  '0' <= c && c <= '9'

let is_letter c =
  'a' <= c && c <= 'z'  ||  'A' <= c && c <= 'Z'

let rec get_token f =
  match get_char f with
  | None -> TokEOF
  | Some x ->
       match x with
       | ' '
       | '\n'
       | '\t' -> get_token f
       | '#' ->
            let rec loop () =
              match get_char f with
              | Some y when y <> '\n' -> loop ()
              | _ -> get_token f
            in
            loop ()
       | '(' -> TokLParen
       | ')' -> TokRParen
       | ';' -> TokSemicolumn
       | ',' -> TokComma
       | _ when is_digit x ->
            (* modificar para aceitar números decimais *)
            let rec loop str =
              match get_char f with
              | Some y ->
                   if is_digit y then
                     loop (str ^ String.make 1 y)
                   else
                     ( unget_char f y; TokNum (float_of_string str) )
              | None ->
                   TokNum (float_of_string str)
            in
            loop (String.make 1 x)
       (* acrescentar operadores, identificadores, etc *)
       | _ ->
	    print_string "unexpected char: ";
	    print_char x;
	    print_newline ();
	    get_token f

let main () =
  let channel =
    if Array.length Sys.argv = 2 then
      open_in Sys.argv.(1)
    else
      stdin
  in
  let rec go f =
    let t = get_token f in
    print_endline (string_of_token t);
    if t <> TokEOF then
      go f
  in
  go (scanner_buffer_from_channel channel)

let _ = main ()
