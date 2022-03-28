open Absyn

let rec maxargs statement =
  match statement with
  | CompoundStm (s1, s2) -> max (maxargs s1) (maxargs s2)
  | AssignStm (_, e) -> maxargs_exp e
  | PrintStm e_list -> max (maxargs_exp_list e_list) (List.length e_list)

and maxargs_exp expression =
  match expression with
  | IdExp _ -> 0
  | NumExp _ -> 0
  | OpExp (e1, _, e2) -> max (maxargs_exp e1) (maxargs_exp e2)
  | EseqExp (s, e) -> max (maxargs s) (maxargs_exp e)

and maxargs_exp_list = function
  | [] -> 0
  | e :: rest -> max (maxargs_exp e) (maxargs_exp_list rest)


(*

(* Definição alternativa, usando List.fold_left *)

let rec maxargs statement =
  match statement with
  | PrintStm args -> List.fold_left
                       max
                       (List.length args)
                       (List.map maxargs_exp args)
  | CompoundStm (s1, s2) -> max (maxargs s1) (maxargs s2)
  | AssignStm (_, e) -> maxargs_exp e

and maxargs_exp expression =
  match expression with
  | IdExp _ -> 0
  | NumExp _ -> 0
  | OpExp (e1, _, e2) -> max (maxargs_exp e1) (maxargs_exp e2)
  | EseqExp (s, e) -> max (maxargs s) (maxargs_exp e)


 *)
