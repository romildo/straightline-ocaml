/* parser.mly */

%{

module A = Absyn

let loc x = x

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
%left PLUS MINUS
%left TIMES DIV

%start <Absyn.stm> prog

%%

prog:
| s=stm EOF                       { s }

stm:
| s1=stm SEMI s2=stm              { loc (A.CompoundStm (s1, s2)) }
| x=ID ASSIGN e=exp               { loc (A.AssignStm (x, e)) }
| PRINT LPAREN a=args RPAREN      { loc (A.PrintStm a) }

exp:
| x=NUM                           { loc (A.NumExp x) }
| v=ID                            { loc (A.IdExp v) }
| e1=exp PLUS e2=exp              { loc (A.OpExp (e1, A.Plus, e2)) }
| e1=exp MINUS e2=exp             { loc (A.OpExp (e1, A.Minus, e2)) }
| e1=exp TIMES e2=exp             { loc (A.OpExp (e1, A.Times, e2)) }
| e1=exp DIV e2=exp               { loc (A.OpExp (e1, A.Div, e2)) }
| LPAREN s=stm COMMA e=exp RPAREN { loc (A.EseqExp (s, e)) }

args:
| /* empty */                     { [] }
| e=exp                           { e :: [] }
| e=exp COMMA es=args_rest        { e :: es }

args_rest:
| e=exp                           { e :: [] }
| e=exp COMMA es=args_rest        { e :: es }
