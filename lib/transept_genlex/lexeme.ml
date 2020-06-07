type t =
  | Float of float
  | String of string
  | Char of char
  | Ident of string
  | Keyword of string
  | Spaces of string
  | Special of char

module Make (Parser : Transept_specs.PARSER with type e = t) = struct
  open Parser

  let spaces = any >>= (function Spaces v -> return v | _ -> fail)

  let any = opt spaces &> any <& opt spaces

  let float = any >>= (function Float v -> return v | _ -> fail)

  let string = any >>= (function String v -> return v | _ -> fail)

  let char = any >>= (function Char v -> return v | _ -> fail)

  let ident = any >>= (function Ident v -> return v | _ -> fail)

  let kwd s =
    any
    >>= (function Keyword v -> if s = v then return s else fail | _ -> fail)
  ;;
end
