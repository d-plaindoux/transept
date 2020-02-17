module Make (Parser : Transept_specs.PARSER with type e = char) = struct
  open Transept_utils.Utils
  open Parser

  let spaces = in_list [ ' '; '\t'; '\r'; '\n' ] <$> constant ()

  let alpha = in_range 'a' 'z' <|> in_range 'A' 'Z'

  let digit = in_range '0' '9'

  let ident = to_list (alpha <&> optrep (alpha <|> digit)) <$> string_of_chars

  let unsigned_number = rep digit

  let natural = rep digit <$> string_of_chars <$> int_of_string

  let sign =
    opt (in_list [ '+'; '-' ]) <$> (function None -> '+' | Some c -> c)

  let signed_number = to_list (sign <&> unsigned_number)

  let integer = signed_number <$> string_of_chars <$> int_of_string

  let rational =
    signed_number
    <&> ( opt @@ to_list (atom '.' <&> unsigned_number)
        <$> (function None -> [] | Some l -> l) )
    <$> uncurry ( @ )

  let float =
    rational
    <&> ( opt @@ to_list (in_list [ 'e'; 'E' ] <&> signed_number)
        <$> (function None -> [] | Some l -> l) )
    <$> uncurry ( @ )
    <$> string_of_chars
    <$> float_of_string

  (** TODO reviewed ASAP *)
  let string =
    atom '"' &> optrep @@ not @@ atom '"' <& atom '"' <$> string_of_chars

  (** TODO reviewed ASAP *)
  let char = atom '\'' &> not @@ atom '\'' <& atom '\''
end
