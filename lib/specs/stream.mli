module type BUILDER = sig
  type _ t

  val build : 'a t
end

module CORE : sig
  type _ t

  module Builder : BUILDER

  val build : 'a Builder.t

  val position : 'a t -> int

  val next : 'a t -> 'a option * 'a t
end

module type API = module type of CORE
