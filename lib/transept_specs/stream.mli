
(** Define the [Stream]. This module provides basic operations used to read one
    by one elements from a stream. *)

(* Can we replace it by a comonad? *)

module CORE : sig
  type e

  type _ t
  (** The abstract type used for the stream denotation. *)

  val is_empty : e t -> bool
  (** Predicate checking if the stream has at least one element or not. *)

  val next : e t -> e option * e t
  (** Provide the next token if possible and the next stream. *)
end

module type API = module type of CORE
