# The straightline programming language

**Straightline** is a micro programming language used in the book series [Modern Compiler Implementation](http://www.cs.princeton.edu/~appel/modern/) by Andrew Appel.

# Working with git repositories

## Initial setup to work with the straightline-ocaml project in BCC328

In order to develop the activities of the BCC328 (Compiler Construction 1) course you should:

- Have a [github](https://github.com/) account. If you do not have one, visit the github site and [sign up](https://github.com/join).
- [Log in](https://github.com/login) to github.
- Visit the main [straightline-ocaml](https://github.com/romildo/straightline-ocaml) project page.
- Fork the straightline-ocaml project. For that use the `Fork` buttom at the top right of the project page.
  ![forking](images/fork1.png)
  This will create your own copy of the main repository. It can be freely modified by you. But probably you do not have permission to modify the main repository.
- In your computer clone your fork of the straightline-ocaml project. Notice that in the commands that follow any text written between angular brackets `<>` shold be replaced by more appropriate text, according to your setup. For instance `<working directory` should be replaced by the name of the directory (folder) for the working activities.
```
$ cd <working directory>
$ git clone https://github.com/<owner>/straightline-ocaml.git
$ cd straightline-ocaml
```
- Set the the upstream remote repository for your clone. The upstream remote repository is the main repository of the project from which the fork was made.
```
$ git remote add upstream https://github.com/romildo/straightline-ocaml.git
```
All remote repositories can be listed with the following command:
```
$ git remote -v
```

Similar steps will also be followed when starting other github based projects on the course.

The above commands were presented to you using the command line. There are other ways to accomplish them, though. For instance they may be integrated in development environments like [IntelliJ IDEA](https://www.jetbrains.com/idea), [Eclipse](https://www.eclipse.org), [Atom](https://atom.io/) and [Visual Studio SCode](https://code.visualstudio.com/).

## When testing a version of the straightline compiler

- Change your working directory to the folder containing your clone.
```
$ cd <working directory>/straightline-ocaml
```
- Select the master branch of the clone of your forked project.
```
$ git branch
$ git checkout master
```
- Pull the latest changes from the remote repository.
```
$ git pull upstream master
```
- Create and select the appropriate branch for the activity.
```
$ git checkout -b <activity>
```
- Use the project code to do whatever is needed.

## To submit an activity

- Select the master branch of the clone of your forked project.
```
$ cd <working directory>/straightline-ocaml
$ git checkout master
```
- Pull the latest changes from the remote repository.
```
$ git pull upstream master
```
- Create a new branch where you will develop the activity.
```
$ git checkout -b <activity>
```
- Develop the activity.
- Check the status of your cloned repository:
```
git status
```
This command list new and modified files.

- Add any new or modified file of interest to the revision history:
```
git add <files>
```
- Commit the changes:
```
git commit -m <message>
```
- Push your changes to your forked project.
```
git push origin <activity>
```
- Make a pull request (PR) from your forked project at github.

# Compiling with ocaml

## To remove the generated files

```
$ ocamlbuild -clean
```

## To compile the project

```
$ ocamlbuild driver.native -use-ocamlfind

```


# Grammar

- The syntax of the language is given by a context free grammar.
- Only the production rules are explicitly given.
- The sets of terminals and non-terminals are obtained from the rules.
- The initial symbol is the non-terminal on the left side of the first production rule.

Production rule                   | Internal representation
----------------------------------|-------------------------
_Stm_ → _Stm_ `;` _Stm_           | CompoundStm
_Stm_ → `id` `:=` _Exp_           | AssignStm
_Stm_ → `print` `(` _ExpList_ `)` | PrintStm
_Exp_ → `id`                      | IdExp
_Exp_ → `num`                     | NumExp
_Exp_ → _Exp_ _Binop_ _Exp_       | OpExp
_Exp_ → `(` _Stm_ `,` _Exp_ `)`   | EseqExp
_ExpList_ → _Exp_                 | LastExpList
_ExpList_ → _Exp_ `,` _ExpList_   | PairExpList
_Binop_ → `+`                     | Plus
_Binop_ → `-`                     | Minus
_Binop_ → `*`                     | Times
_Binop_ → `/`                     | Div

# Example

```
a := 5 + 3;
b := ( print(a, a - 1), 10*a);
print(b)

```

![ast](images/ast.png)

## General guidelines for building the AST

- There is an **algebraic data type** for each interesting non terminal (representing a kind of phrase in the source language).
- There is a **data constructor** for each production rule for that non terminal (representing a particular form for the phrase).

For instance, the _Stm_ non terminal represents statements. So there is a type, named `stm` to represent all forms of statements. As there are three forms of statements, for each one there is a data constructor of `stm`:

- compound statements, represented by the `Compoundstm` constructor
- assignment statements, represented by the `AssignStm` constructor
- print statements, represented by the `PrintStm` constructor

# Activities

## Building an abstract syntax tree

Add a `Test` module to the project, with a `main` function that, when applied, creates the AST for the program given above, and prints it.

As an example, below is the AST for the program:

```
x := 2 + 3 * 4;
print(x)
```

``` ocaml
let prog1 =
  CompoundStm (AssignStm ("x",
                          OpExp (NumExp 2,
                                 Plus,
                                 OpExp (NumExp 3,
                                        Times,
                                        NumExp 4))),
               PrintStm [IdExp "x"])
```

## Pretty printing the AST

<!-- Make `absyn.AST` implement the interface `vavr.render.ToTree<String>` from the `javalang-render` library. This will allow converting the AST to general trees of `String` that can be easily drawn in different ways. -->

<!-- 1. Add the `implements` clause to the class declaration of `absyn.AST`. -->
<!-- 2. Implement the method `toTree` in each concrete subclass of `absyn.AST`. It has no arguments and returns a `vavr.collection.Tree.Node<String>` corresponding to the AST. -->
<!-- 3. Test with the AST written previously, drawing it in the terminal. -->

## Calculating the maximum number of arguments in print statements

Define a function `maxargs` to calculate the maximum number of arguments in print statements ocurring in a given straightline program.

It should receive a statement and returs an integer.

Test with the AST you have created above.

## Interpreting

Add a method `interp` to run a program.

It should have a `(string, int) Hashtbl.t` representing the memory, and a statement as arguments, and run the given program using the given memory.

The memory is a hash table where the keys are variable names, and the associated values are the value of the variable.

Test with the AST you have created above.

## Write test units for the project

<!-- Write the class `MainTest` in the directory `test/java` to test the interpreter. -->

# Assignment (Trabalho)

<!-- Faça as seguintes modificações no projeto do compilador da linguagem: -->

<!-- - acrescente literais booleanos: `#t` para verdadeiro, e `#f` para falso -->

<!-- - acrecente os operadores relacionais `==`, `<>`, `>`, `>=`, `<`, -->
<!--   `<=`, para as operações relacionais, com precedência menor que os -->
<!--   operadores aritméticos, e não associativos. -->

<!-- - acrecente o operador lógico `and` para a conjunção lógica, com -->
<!--   precedência menor que os operadores relacionais, e associatividade à -->
<!--   esquerda. -->

<!-- - acrecente o operador lógico `or` para a disjunção lógica, com -->
<!--   precedência menor que `and`, e associatividade à esquerda. -->

<!-- - acrescente o comando condicional -->
<!-- ``` -->
<!-- if <exp> then <stm> else <stm> -->
<!-- ``` -->
<!--   onde <exp> é uma expressão lógica, e <stm> é um comando. Em sua execução avalia-se a expressão, e ela for verdadeira executa-se o primeiro comando. -->

<!-- - acrescente o comando condicional -->
<!-- ``` -->
<!-- if <exp> then <stm> -->
<!-- ``` -->
<!--   onde `<exp>` é uma expressão lógica, e `<stm>` é um comando. Em sua -->
<!--   execução avalia-se a expressão, e ela for verdadeira executa-se o -->
<!--   primeiro comando. Caso contráro executa-se o segundo comando. -->

<!-- - acrescente o comando de repetição -->
<!-- ``` -->
<!-- while <exp> do <stm> -->
<!-- ``` -->
<!--   onde `<exp>` é uma expressão lógica, e `<stm>` é um comando.  Em sua -->
<!--   execução executa-se o comando enquanto a expressão for verdadeira. -->

<!-- - acrescentar o comando -->
<!-- ``` -->
<!-- read <id> -->
<!-- ``` -->
<!--   que quando executado obtém da entrada padrão um valor inteiro, -->
<!--   armazenando-o na variável indicada. -->
