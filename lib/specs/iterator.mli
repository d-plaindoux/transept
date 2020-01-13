module CORE : sig
  type _ t

  val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b
end

module type API = module type of CORE
