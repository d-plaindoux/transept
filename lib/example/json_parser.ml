open Json

module Lexeme = Transept_extension.Lexeme
module Genlex = Transept_extension.Genlex

let keywords = [ "{"; "}"; "["; "]"; ","; ":"; "null"; "true"; "false" ]

module Make (Parser : Transept_specs.PARSER with type e = Lexeme.t) = struct
  module Token = Genlex.Token (Parser)
  open Transept_parser.Utils
  open Parser

  let keywords = []

  let bool =
    Token.kwd "true"
    <$> constant @@ Bool true
    <|> (Token.kwd "false" <$> constant @@ Bool false)

  let null = Token.kwd "null" <$> constant Null

  (** TODO Review this case ASAP *)
  let stringValue =
    Token.string <$> function
    | Lexeme.String s -> s
    | _ -> failwith "Impossible"

  let string =
    stringValue <$> function
    | s -> String s

  (** TODO Review this case ASAP *)
  let number =
    Token.float <$> function
    | Lexeme.Float f -> Number f
    | _ -> failwith "Impossible"

  let rec json () =
    null <|> bool <|> do_lazy record <|> do_lazy array <|> string <|> number

  and array () =
    let item = do_lazy json in
    (Token.kwd "["
     &> opt (item <&> optrep (Token.kwd "," &> item))
     <& Token.kwd "]"
     <$> function
     | None -> []
     | Some (e, l) -> e :: l)
    <$> fun r -> Array r

  and record () =
    let item = do_lazy json in
    let attribute = stringValue <& Token.kwd ":" <&> item in
    (Token.kwd "{"
     &> opt (attribute <&> optrep (Token.kwd "," &> attribute))
     <& Token.kwd "}"
     <$> function
     | None -> []
     | Some (e, l) -> e :: l)
    <$> fun l -> Record l

  let parse = json () <& eos
end
