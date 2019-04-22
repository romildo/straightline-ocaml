(* lexer.mll *)

{
}

let alpha = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let id = alpha+ (alpha|digit|'_')*
let num = digit+ ("." digit*)? | (digit* ".")? digit+


(* in the actions, lexbuf is bound to the current lexer buffer, the
   extra implicit last argument of the entry points *)

rule token = parse
  | [' ' '\t']    { token lexbuf }
  | '\n'	  { Lexing.new_line lexbuf; token lexbuf }
  | "//" [^'\n']* { token lexbuf }
  | "print"	  { Parser.PRINT }
  | num as lxm    { Parser.NUM (float_of_string lxm) }
  | id as lxm	  { Parser.ID lxm }
  | ":="	  { Parser.ASSIGN }
  | '+'		  { Parser.PLUS }
  | '-'		  { Parser.MINUS }
  | '*'		  { Parser.TIMES }
  | '/'		  { Parser.DIV }
  | '('		  { Parser.LPAREN }
  | ')'		  { Parser.RPAREN }
  | ';'		  { Parser.SEMI }
  | ','		  { Parser.COMMA }
  | eof		  { Parser.EOF }
  | _             { Error.error
                      { Location.loc_start = lexbuf.Lexing.lex_start_p;
                        Location.loc_end = lexbuf.Lexing.lex_curr_p;
                      }
                      (Error.Illegal_character (Lexing.lexeme_char lexbuf 0));
                    token lexbuf
                  }

{

let string_of_token = function
  | Parser.NUM x    -> "NUM(" ^ string_of_float x ^ ")"
  | Parser.ID x     -> "ID(" ^ x ^ ")"
  | Parser.PRINT    -> "PRINT"
  | Parser.LPAREN   -> "LPAREN"
  | Parser.RPAREN   -> "RPAREN"
  | Parser.ASSIGN   -> "ASSIGN"
  | Parser.COMMA    -> "COMMA"
  | Parser.SEMI     -> "SEMI"
  | Parser.PLUS     -> "PLUS"
  | Parser.MINUS    -> "MINUS"
  | Parser.TIMES    -> "TIMES"
  | Parser.DIV      -> "DIV"
  | Parser.EOF      -> "EOF"

}
