(** The [Element] module provides a simple type [t]. This type is used to denote
    elements in parsed streams. *)

(** {1 Structure anatomy} *)

module CORE : sig
  type t
end

(** {1 API} *)

module type API = module type of CORE
(** The complete interface of an [Element]. *)
