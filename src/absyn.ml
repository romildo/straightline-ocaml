(* absyn.ml *)

type id = string

type binop = Plus | Minus | Times | Div

type stm = CompoundStm of stm * stm
         | AssignStm of id * exp
         | PrintStm of exp list

 and exp = IdExp of string
         | NumExp of float
         | OpExp of exp * binop * exp
         | EseqExp of stm * exp
