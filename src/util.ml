
let rec intersperse x = function
  | [] -> []
  | [y] -> [y]
  | h :: t -> h :: x :: intersperse x t
