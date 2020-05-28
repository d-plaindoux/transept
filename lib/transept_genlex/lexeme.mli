type t =
  | Float of float
  | String of string
  | Char of char
  | Ident of string
  | Keyword of string
  | Spaces of string
  | Special of char

module Make (Parser : Transept_specs.PARSER with type e = t) : sig
  val float : float Parser.t

  val string : string Parser.t

  val char : char Parser.t

  val ident : string Parser.t

  val kwd : string -> string Parser.t
end
