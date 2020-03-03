(** Propose a [Stream] implementation from a parser *)

module Make (Parser : Transept_specs.PARSER) : sig
  type 'a r
  (** The abstract type used for the stream denotation. *)

  module Build_via_stream :
    Transept_specs.Stream.BUILDER
      with type 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a r
  (** The stream builder module with a parser as a source. *)

  (** The stream module with a parser as a source. *)
  module Stream :
    Transept_specs.STREAM
      with type 'a t = 'a r
       and module Builder = Build_via_stream

  include module type of Stream
end
