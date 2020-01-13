module Make (Parser : Transept_specs.PARSER with type e = char) : sig
  val spaces : unit Parser.t

  val alpha : char Parser.t

  val digit : char Parser.t

  val ident : string Parser.t

  val natural : int Parser.t

  val integer : int Parser.t

  val float : float Parser.t

  val string : string Parser.t

  val char : char Parser.t
end
