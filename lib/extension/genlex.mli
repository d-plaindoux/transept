module Make (Parser : Transept_specs.PARSER with type e = char) : sig
  val tokenizer : unit Parser.t -> string list -> Lexeme.t Parser.t

  val tokenizer_with_spaces : string list -> Lexeme.t Parser.t
end

module Token (Parser : Transept_specs.PARSER with type e = Lexeme.t) : sig
  val float : Lexeme.t Parser.t

  val string : Lexeme.t Parser.t

  val char : Lexeme.t Parser.t

  val ident : Lexeme.t Parser.t

  val kwd : string -> Lexeme.t Parser.t
end
