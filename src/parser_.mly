/* parser.mly */

%{

module A = Absyn

(*
let pos n x = mkloc { loc_start = Parsing.rhs_start_pos n;
                      loc_end = Parsing.rhs_end_pos n;
                    }
                    x

let loc x = mkloc { loc_start = Parsing.symbol_start_pos ();
                    loc_end = Parsing.symbol_end_pos ();
                  }
                  x
 *)

let loc x = x

let parse_error msg =
  match ! Location.lexbuf_ref with
  | Some lexbuf ->
      Error.error (Location.curr_loc lexbuf) (Error.Syntax (Lexing.lexeme lexbuf))
  | None ->
      Error.internal "lexbuf_ref is unset"

%}

%token <float> NUM
%token <string> ID
%token PRINT
%token LPAREN RPAREN
%token COMMA SEMI
%token PLUS MINUS TIMES DIV
%token ASSIGN
%token EOF

%right SEMI
%nonassoc ASSIGN
%left PLUS MINUS
%left TIMES DIV

%start prog
%type <Absyn.stm> prog

%%

prog:
  stm                          { $1 }
;

stm:
  stm SEMI stm                 { loc (A.CompoundStm ($1, $3)) }
| ID ASSIGN exp                { loc (A.AssignStm ($1, $3)) }
| PRINT LPAREN args RPAREN     { loc (A.PrintStm $3) }
;

exp:
  NUM                          { loc (A.NumExp $1) }
| ID                           { loc (A.IdExp $1) }
| exp PLUS exp                 { loc (A.OpExp ($1, A.Plus, $3)) }
| exp MINUS exp                { loc (A.OpExp ($1, A.Minus, $3)) }
| exp TIMES exp                { loc (A.OpExp ($1, A.Times, $3)) }
| exp DIV exp                  { loc (A.OpExp ($1, A.Div, $3)) }
| LPAREN stm COMMA exp RPAREN  { loc (A.EseqExp ($2, $4)) }
;

args:
  /* empty */                  { [] }
| exp                          { $1 :: [] }
| exp COMMA args_rest          { $1 :: $3 }
| error COMMA args_rest        { $3 }
;

args_rest:
  exp                          { $1 :: [] }
| exp COMMA args_rest          { $1 :: $3 }
| error COMMA args_rest        { $3 }
;

%%
