open Absyn

let string_of_oper = function
  | Plus   -> "+"
  | Minus  -> "-"
  | Times  -> "*"
  | Div    -> "/"

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) [];;

let implode l =
  let res = String.create (List.length l) in
  let rec imp i = function
    | [] -> res
    | c :: l -> res.[i] <- c; imp (i + 1) l in
  imp 0 l;;

let escape_dot s =
  implode
    (List.fold_right
       (fun c cs ->
         match c with
           | '\n' -> '\\' :: 'n' :: cs
           | '<' | '{' | '|' | '}' | '>' | ' ' -> '\\' :: c :: cs
           | _ -> c :: cs
       )
       (explode s)
       [])

let node_dot s =
  let node_dot = function
    | [] -> ""
    | [x] -> escape_dot x
    | xs -> "{ " ^ String.concat " | " (List.map escape_dot xs) ^ " }"
  in
  let s' = node_dot s in
  (* print_string s'; *)
  s'

let node_txt xs =
  String.concat ":" xs

let rec tree_of_stm = function
  | CompoundStm (s1,s2) -> Tree.mkt ["CompoundStm"] [tree_of_stm s1; tree_of_stm s2]
  | AssignStm (v,e)     -> Tree.mkt ["AssignStm"] [Tree.mkt [v] []; tree_of_exp e]
  | PrintStm es         -> Tree.mkt ["PrintStm"] (List.map tree_of_exp es)

and tree_of_exp = function
  | NumExp x         -> Tree.mkt ["NumExp " ^ string_of_float x] []
  | IdExp x          -> Tree.mkt ["IdExp " ^ x] []
  | OpExp (e1,op,e2) -> Tree.mkt ["OpExp " ^ string_of_oper op] [tree_of_exp e1; tree_of_exp e2]
  | EseqExp (s,e)    -> Tree.mkt ["EseqExp"] [tree_of_stm s; tree_of_exp e]
