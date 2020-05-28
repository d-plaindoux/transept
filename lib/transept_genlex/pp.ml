open Lexeme

let pp ppf = function
  | Float value -> Format.fprintf ppf "%f" value
  | String value -> Format.fprintf ppf "\"%s\"" value
  | Char value -> Format.fprintf ppf "'%c'" value
  | Ident value -> Format.fprintf ppf "%s" value
  | Keyword value -> Format.fprintf ppf "%s" value
  | Spaces value -> Format.fprintf ppf "%s" value
  | Special value -> Format.fprintf ppf "%c" value
;;

let to_string = Format.asprintf "%a" pp
