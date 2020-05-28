module Make (Parser : Transept_specs.PARSER with type e = char) = struct
  open Transept_utils.Utils
  open Lexeme

  open Transept_extension.Literals.Make (Parser)

  let tokenizer l =
    let open Parser in
    let keywords =
      List.fold_left (fun p e -> p <|> atoms e) fail
      @@ List.map chars_of_string l
      <$> string_of_chars
    in
    spaces
    <$> (fun e -> Spaces e)
    <|> (keywords <$> (fun e -> Keyword e))
    <|> (float <$> (fun e -> Float e))
    <|> (string <$> (fun e -> String e))
    <|> (char <$> (fun e -> Char e))
    <|> (ident <$> (fun e -> Ident e))
    <|> (any <$> (fun e -> Special e))
  ;;
end
