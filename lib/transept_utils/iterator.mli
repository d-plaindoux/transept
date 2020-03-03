(** The [Iterator] specifies traditional [fold_left] and [fold_right] function
    signatures *)

(** {1 Structure anatomy} *)

module CORE : sig
  type _ t

  val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b
end

(** {1 API} *)

module type API = module type of CORE
