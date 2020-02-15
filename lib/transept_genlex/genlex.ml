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
    &> ( float
       <$> (fun e -> Float e)
       <|> (string <$> (fun e -> String e))
       <|> (char <$> (fun e -> Char e))
       <|> (keywords <$> (fun e -> Keyword e)) )
    <|> (ident <$> (fun e -> Ident e))
    <& skipped
  ;;

  let tokenizer_with_spaces l = tokenizer spaces l
end

module Token (Parser : Transept_specs.PARSER with type e = Lexeme.t) = struct
  let float = Parser.(any <?> (function Lexeme.Float _ -> true | _ -> false))

  let string = Parser.(any <?> (function Lexeme.String _ -> true | _ -> false))

  let char = Parser.(any <?> (function Lexeme.Char _ -> true | _ -> false))

  let ident = Parser.(any <?> (function Lexeme.Ident _ -> true | _ -> false))

  let kwd s = Parser.(any <?> (fun a -> a = Lexeme.Keyword s))
end
