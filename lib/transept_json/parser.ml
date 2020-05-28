module Lexeme = Transept_genlex.Lexeme
module Genlex = Transept_genlex.Lexer

let keywords = [ "{"; "}"; "["; "]"; ","; ":"; "null"; "true"; "false" ]

module Make (Parser : Transept_specs.PARSER with type e = Lexeme.t) = struct
  open Lexeme.Make (Parser)

  open Transept_utils.Utils
  open Json
  open Parser

  let null = kwd "null" <$> constant Null

  let bool =
    kwd "true"
    <$> constant @@ Bool true
    <|> (kwd "false" <$> constant @@ Bool false)
  ;;

  let string_value = string

  let string = string_value <$> (function s -> String s)

  (** Unable to use GADT *)
  let number = float <$> (function f -> Number f)

  let rec array () =
    let item = do_lazy json in
    kwd "["
    &> opt (item <&> optrep (kwd "," &> item))
    <& kwd "]"
    <$> (function None -> [] | Some (e, l) -> e :: l)
    <$> (fun r -> Array r)

  and record () =
    let item = do_lazy json in
    let attribute = string_value <& kwd ":" <&> item in
    kwd "{"
    &> opt (attribute <&> optrep (kwd "," &> attribute))
    <& kwd "}"
    <$> (function None -> [] | Some (e, l) -> e :: l)
    <$> (fun l -> Record l)

  and json () =
    null <|> bool <|> do_lazy record <|> do_lazy array <|> string <|> number
  ;;

  let parse = json () <& eos
end
