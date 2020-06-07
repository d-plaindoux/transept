module Make (Parser : Transept_specs.PARSER with type e = char) : sig
  val tokenizer : string list -> Lexeme.t Parser.t
end
