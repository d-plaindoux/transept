(** Define [Response] module. *)

(** {1 Structure anatomy} *)

module CORE : sig
  type ('s, 'a) t
  (** Response abstract data type *)

  val success : 's * 'a * bool -> ('s, 'a) t
  (** Define successful response *)

  val failure : 's * bool -> ('s, 'a) t
  (** Define failure response *)

  val fold : ('s, 'a) t -> ('s * 'a * bool -> 'b) -> ('s * bool -> 'b) -> 'b
  (** Catamorphism dedicated to response data type. *)
end

(** {1 API} *)

module type API = module type of CORE
