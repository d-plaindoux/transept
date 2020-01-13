module type CORE = sig
  module Response : Response.API

  module Stream : Stream.API

  type e

  type _ t

  val parse : 'a t -> e Stream.t -> (e Stream.t, 'a) Response.t
end

module type MONAD = sig
  type _ t

  val ( <$> ) : 'a t -> ('a -> 'b) -> 'b t

  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
end

module type BASIC = sig
  type _ t

  val return : 'a -> 'a t

  val fail : 'a t

  val eos : unit t
end

module type FLOW = sig
  type _ t

  val ( <&> ) : 'a t -> 'b t -> ('a * 'b) t

  val to_list : ('a * 'a list) t -> 'a list t

  val ( &> ) : 'a t -> 'b t -> 'b t

  val ( <& ) : 'a t -> 'b t -> 'a t

  val ( <|> ) : 'a t -> 'a t -> 'a t

  val ( <?> ) : 'a t -> ('a -> bool) -> 'a t
end

module type EXECUTION = sig
  type _ t

  val do_try : 'a t -> 'a t

  val do_lazy : (unit -> 'a t) -> 'a t

  val lookahead : 'a t -> 'a t
end

module type ATOMIC = sig
  type e

  type _ t

  val any : e t

  val not : e t -> e t

  val atom : e -> e t

  val in_list : e list -> e t

  val in_range : e -> e -> e t

  val atoms : e list -> e list t
end

module type REPEATABLE = sig
  type _ t

  val opt : 'a t -> 'a option t

  val optrep : 'a t -> 'a list t

  val rep : 'a t -> 'a list t
end

module type API = sig
  include CORE

  include BASIC with type 'a t := 'a t

  include ATOMIC with type 'a t := 'a t and type e := e

  include FLOW with type 'a t := 'a t

  include EXECUTION with type 'a t := 'a t

  include REPEATABLE with type 'a t := 'a t

  include MONAD with type 'a t := 'a t
end
