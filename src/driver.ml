(* driverl.ml *)

let scan lexbuf =
  let rec go () =
    let tok = Lexer.token lexbuf in
    Format.printf "%a %s\n"
                  Location.print_pos lexbuf.Lexing.lex_start_p
                  (Lexer.string_of_token tok);
    match tok with
    | Parser.EOF -> ()
    | _ -> go ()
  in
  go ()

let interpret lexbuf =
  let ast  = Parser.prog Lexer.token lexbuf in
  let tree = Absyntree.tree_of_stm ast in
  if Option.print_ast () then
    begin
      (* print_endline (Tree.string_of_tree (Tree.map Absyntree.node_txt tree)); *)
      print_endline (Box.string_of_box (Tree.box_of_tree (Tree.map Absyntree.node_txt tree)));
      print_endline ""
    end;
  if Option.print_dot () then
    begin
      let name = Option.filename () in
      let out = open_out ((if name = "" then "__stdin__" else name) ^ ".dot") in
      output_string out (Tree.dot_of_tree "AST" (Tree.map Absyntree.node_dot tree))
    end;
  if Option.is_maxargs () then
    Printf.printf "Maximum number of arguments in a print: %d\n" (Maxargs.maxargs ast);
  if Option.will_run () then
    ignore (Interpreter.interpret ast)

let _ =
  Printexc.record_backtrace true;
  Option.parse_cmdline ();
  let lexbuf = Lexing.from_channel (Option.channel ()) in
  Location.init lexbuf (Option.filename ());
  if Option.print_lex () then
    scan lexbuf
  else
    try
      interpret lexbuf
    with
      | Parsing.Parse_error ->
          exit 2
      | Error.Error (loc,err) as e ->
          ( Error.handle_error loc err;
            raise e
          )
