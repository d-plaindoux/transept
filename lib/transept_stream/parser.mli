module Make (Parser : Transept_specs.PARSER) : sig
  type 'a t

  module Builder :
    Transept_specs.Stream.BUILDER
      with type 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

  val build : 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

  val position : 'a t -> int

  val is_empty : 'a t -> bool

  val next : 'a t -> 'a option * 'a t
end
