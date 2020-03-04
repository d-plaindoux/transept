# Transept

![Transept](https://github.com/d-plaindoux/transept/workflows/Transept/badge.svg)

An OCaml modular and generalised parser combinator library.

# Parsing arithmetic expressions

## ADTs definition

This example is the traditional arithmetic expression language. This can be represented by the following abstract data 
types.
In this first example we only care about significant items like `float`, parenthesis and finally operations. 

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

## Parsers with a direct style 

Direct style means we parse a stream of characters. In this case all characters are significant even spaces. 

### Required modules

`Transept` provides modules in order to help parsers construction. In the next fragment `Utils` contains basic functions 
like `constant`. The `Parser` module is a is parser dedicated to char stream analysis and `Literals`is dedicated to string, 
float etc. parsing. 

```ocaml
module Utils = Transept.Utils
module CharParser = Transept.Extension.Parser.For_char_list
module Literals = Transept.Extension.Literals.Make (CharParser)
```

### Operation parser

Therefore we can propose a first parser dedicated to operations. 

```ocaml
let operator = 
    let open Utils in
    let open CharParser in
    (atom '+' <$> constant Add)   <|>
    (atom '-' <$> constant Minus) <|>
    (atom '*' <$> constant Mult)  <|>
    (atom '/' <$> constant Div)
```

### Expression parser

Then the simple expression and the expression can be defined by the following parsers.
     
```ocaml
let expr = 
    (* sexpr ::= float | '(' expr ')' *)
    let rec sexpr () =
      let open Literals in
      let open CharParser in
      float <$> (fun f -> Number f) <|> (atom '(' &> do_lazy expr <& atom ')')
    
    (* expr ::= sexpr (operator expr)? *)
    and expr () =
      let open CharParser in
      do_lazy sexpr <&> opt (operator <&> do_lazy expr) <$> function
      | e1, None -> e1
      | e1, Some (op, e2) -> BinOp (op, e1, e2)
    
    in expr
```

Finally a sentence can be easily parsed.

```ocaml
let parse s =
    let open Utils in
    let open CharParser in
    parse (expr ()) @@ Stream.build @@ chars_of_string s
```

With this solution we don't skip whitespaces. It means `1+(2+3)` is parsed when `1 + (2 + 3)` is not!  

## The indirect style

Since `Transept` is a generalized version, it's possible to parse something other than characters. For this purpose a 
generic lexer is proposed thanks to the `Genlex` module. 

### Required modules

`Transept` provides modules in order to help parsers construction. In the next fragment `Utils` contains basic functions 
like `constant`. The `CharParser` module is a is parser dedicated to char stream analysis and `Stream`is dedicated to 
parsing using another parser.

```ocaml
module Utils = Transept_utils.Utils
module CharParser = Transept_extension.Parser.For_char_list
module Stream = Transept_stream.Via_parser (CharParser)
module Genlex = Transept_genlex.Genlex.Make (CharParser)
```

### Main parser

```ocaml
module Parser =
  Transept_core.Parser.Make_via_stream
    (Stream)
    (struct
      type t = Transept_genlex.Lexeme.t
    end)

module Token = Transept_genlex.Genlex.Token (Parser) 
```


### Operation parser

Therefore we can propose a first parser dedicated to operations. 

```ocaml
let operator = 
    let open Utils in
    let open Parser in
    let open Token in
    (kwd "+" <$> constant Add)   <|>
    (kwd "-" <$> constant Minus) <|>
    (kwd "*" <$> constant Mult)  <|>
    (kwd "/" <$> constant Div)
```

### Expression parser

Then the simple expression and the expression can be defined by the following parsers.
     
```ocaml
let expr = 
    (* sexpr ::= float | '(' expr ')' *)
    let rec sexpr () =
      let open Parser in
      let open Token in
      float <$> (fun f -> Number f) <|> (kwd "(" &> do_lazy expr <& kwd ")")
    
    (* expr ::= sexpr (operator expr)? *)
    and expr () =
      let open Parser in
      do_lazy sexpr <&> opt (operator <&> do_lazy expr) <$> function
      | e1, None -> e1
      | e1, Some (op, e2) -> BinOp (op, e1, e2)
    
    in expr
```

Finally a sentence can be parsed using parsers. First one `CharParser` parses char stream and is used by the `Genlex` in order to create a stream
of lexemes. The second one `Parser` is used to parse the previous lexeme stream.

```ocaml
let parse s =
    let open Utils in
    let open Parser in
    let tokenizer = Genlex.tokenizer_with_spaces ["+"; "/"; "*"; "/"; "("; ")"] in
    let stream = Stream.build tokenizer (CharParser.Stream.build @@ Utils.chars_of_string s) in
    parse (expr ()) stream
```

With this solution whitespaces are skipped by the generic lexer. It means `1 + ( 2+ 3)` is parsed correctly now.  

A [JSON Parser](https://github.com/d-plaindoux/transept/blob/master/lib/transept_json/json_parser.ml) has been designed with this approch based on a low level parser producing tokens and a high level parser producing JSON terms from tokens.

# LICENSE 

MIT License

Copyright (c) 2020 Didier Plaindoux

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
