(** Define the [Stream]. This module provides basic operations used to read one
    by one elements from a stream. *)

(** A [Builder] has the capability to build a stream from an alternate data. The
    corresponding type is abstract and strongly linked to the [CORE] module. *)
module type BUILDER = sig
  type _ t

  val build : 'a t
  (** Creates a stream. *)
end

module CORE : sig
  type _ t
  (** The abstract type used for the stream denotation. *)

  module Builder : BUILDER

  val build : 'a Builder.t
  (** Build a fresh [Stream] using the parametric parser and a stream. *)

  val position : 'a t -> int
  (** Provides the current absolute position in the stream. This reflect the
      number of read elements from the stream. *)

  val is_empty : 'a t -> bool
  (** Predicate checking is the stream has at least one element or not. *)

  val next : 'a t -> 'a option * 'a t
  (** Provide the next token if possible and the next stream. *)
end

module type API = module type of CORE
