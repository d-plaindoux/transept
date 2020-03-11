module Make (Parser : Transept_specs.PARSER with type e = char) = struct
  open Transept_utils.Utils
  open Lexeme

  open Transept_extension.Literals.Make (Parser)

  let tokenizer s l =
    let open Parser in
    let keywords =
      List.fold_left (fun p e -> p <|> atoms e) fail
      @@ List.map chars_of_string l
      <$> string_of_chars
    and skipped = optrep s <$> constant () in
    skipped
    &> (keywords <$> (fun e -> Keyword e))
    <|> (float <$> (fun e -> Float e))
    <|> (string <$> (fun e -> String e))
    <|> (char <$> (fun e -> Char e))
    <|> (ident <$> (fun e -> Ident e))
    <& skipped

  let tokenizer_with_spaces l = tokenizer spaces l
end

module Token (Parser : Transept_specs.PARSER with type e = Lexeme.t) = struct
  open Parser

  let float = any >>= (function Lexeme.Float f -> return f | _ -> fail)

  let string = any >>= (function Lexeme.String s -> return s | _ -> fail)

  let char = any >>= (function Lexeme.Char c -> return c | _ -> fail)

  let ident = any >>= (function Lexeme.Ident i -> return i | _ -> fail)

  let kwd s = any >>= (fun a -> if a = Lexeme.Keyword s then return s else fail)
end
