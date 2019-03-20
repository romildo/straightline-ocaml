(*
  x := 2 + 3 * 4;
  print(x)

 *)

let prog1 =
  CompoundStm (AssignStm ("x",
                          OpExp (NumExp 2,
                                 Plus,
                                 OpExp (NumExp 3,
                                        Times,
                                        NumExp 4))),
               PrintStm [IdExp "x"])
