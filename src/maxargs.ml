open Absyn

let maxargs statement =
  match statement with
  | PrintStm args -> List.length args

