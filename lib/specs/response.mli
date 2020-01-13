module CORE : sig
  type (_, _) t

  val success : 's * 'a * bool -> ('s, 'a) t

  val failure : 's * bool -> ('s, 'a) t

  val fold : ('s, 'a) t -> ('s * 'a * bool -> 'b) -> ('s * bool -> 'b) -> 'b
end

module type API = module type of CORE
