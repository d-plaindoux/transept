# Transept

An OCaml modular generalised parser combinator library.

# Parsing arithmetic expressions

This example is the traditional arithmetic expression language. This can be represented by the following abstract data types. 

```ocaml
type operation =
  | Add
  | Minus
  | Mult
  | Div

type expr =
  | Number of float
  | BinOp of operation * expr * expr
```

`Transept` provides modules in order to help parsers construction. In the next fragment `Utils` contains basic functions like `constant`. The `Parser` module is a is parser dedicated to char stream analysis and `Literals`is dedicated to string, float etc. parsing. 

```ocaml
module Utils = Transept.Utils
module Parser = Transept.Extension.Parser.CharParser
module Literals = Transept.Extension.Literals.Make (Parser)
```

Therefore we can propose a first parser dedicated to operations. 

```ocaml
let operator = 
    let open Utils in
    let open Parser in
    (atom '+' <$> constant Add)   <|>
    (atom '-' <$> constant Minus) <|>
    (atom '*' <$> constant Mult)  <|>
    (atom '/' <$> constant Div)
```

Then the simple expression and the expression can be defined by the following parsers.
     
```ocaml
(* sexpr ::= float | '(' expr ')' *)
let rec sexpr () =
  let open Literals in
  let open Parser in
  float <$> (fun f -> Number f) <|> (atom '(' &> do_lazy expr <& atom ')')

(* expr ::= sexpr (operator expr)? *)
and expr () =
  let open Parser in
  do_lazy sexpr <&> opt (operator <&> do_lazy expr) <$> function
  | e1, None -> e1
  | e1, Some (op, e2) -> BinOp (op, e1, e2)
```

Finally a sentence can be easily parsed.

```ocaml
let parse s =
  let open Utils in
  let open Parser in
  Parser.parse (expr ()) @@ Stream.build @@ chars_of_string s
```

# LICENSE 

MIT License

Copyright (c) 2020 Didier Plaindoux

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
