open Json

module Make (P : Transept_specs.PARSER with type e = char) = struct
  module U = Transept_parser.Utils
  module R = P.Response
  module S = P.Stream
  module L = Transept_extension.Literals.Make (P)
  include P

  let skipped = optrep L.spaces <$> U.constant ()

  let skip p = skipped &> p <& skipped

  let kwd s = skip (atoms @@ U.chars_of_string s)

  let bool =
    kwd "true"
    <$> U.constant @@ Bool true
    <|> (kwd "false" <$> U.constant @@ Bool false)

  let null = kwd "null" <$> U.constant Null

  let number = skip L.float <$> fun f -> Number f

  let string = skip L.string <$> fun s -> String s

  let rec json () =
    skip
      (null <|> bool <|> do_lazy record <|> do_lazy array <|> string <|> number)

  and array () =
    let item = do_lazy json in
    (kwd "[" &> opt (item <&> optrep (kwd "," &> item)) <& kwd "]" <$> function
     | None -> []
     | Some (e, l) -> e :: l)
    <$> fun r -> Array r

  and record () =
    let item = do_lazy json in
    let attribute = skip L.string <& kwd ":" <&> item in
    (kwd "{" &> opt (attribute <&> optrep (kwd "," &> attribute)) <& kwd "}"
     <$> function
     | None -> []
     | Some (e, l) -> e :: l)
    <$> fun l -> Record l

  let parse = json () <& eos
end
