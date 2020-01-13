module Make (Parser : Transept_specs.PARSER) : sig
  type 'a t

  module Build_via_stream :
    Transept_specs.Stream.BUILDER
      with type 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

  module Stream :
    Transept_specs.STREAM
      with type 'a t = 'a t
       and module Builder = Build_via_stream

  module Builder :
    Transept_specs.Stream.BUILDER
      with type 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

  val build : 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

  val position : 'a t -> int

  val next : 'a t -> 'a option * 'a t
end
