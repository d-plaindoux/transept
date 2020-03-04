(** Define [Parser] modules and all submodules. *)

(** {1 Structure anatomy} *)

(** Parser core module defining abstract type ands main parsing function *)
module type CORE = sig
  module Response : Response.API

  module Stream : Stream.API

  type e
  (** The element abstract type. Elements are provided by the stream used during
      the parsing. *)

  type _ t
  (** The parse abstract type *)

  val parse : 'a t -> e Stream.t -> (e Stream.t, 'a) Response.t
  (** Main parse function. It takes a [Parser.t] type, a [Stream] of elements
      and returns a [Response.t]. *)
end

(** Definition for monadic parser *)
module type MONAD = sig
  type _ t
  (** The parse abstract type *)

  val ( <$> ) : 'a t -> ('a -> 'b) -> 'b t
  (** Mapping over from ['a] to ['b] over ['a t] to ['b t]. *)

  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
  (** [m >>= f] passes the result of computation [m] to function [f]. *)
end

(** Define basic parser. *)
module type BASIC = sig
  type _ t
  (** The parse abstract type *)

  val return : 'a -> 'a t
  (** Parser return a success with the parametric value. *)

  val fail : 'a t
  (** Parser return a failure. *)

  val eos : unit t
  (** Parser checking when a stream has been completly analyze. *)
end

(** Define flow parser like sequence or choice. *)
module type FLOW = sig
  type _ t
  (** The parse abstract type *)

  val ( <&> ) : 'a t -> 'b t -> ('a * 'b) t
  (** Parser dedicated to parser sequence. *)

  val ( &> ) : 'a t -> 'b t -> 'b t
  (** Parser dedicated to parser sequence removing the left parser result. *)

  val ( <& ) : 'a t -> 'b t -> 'a t
  (** Parser dedicated to parser sequence removing the right parser result. *)

  val ( <|> ) : 'a t -> 'a t -> 'a t
  (** Parser dedicated to parser disjunction. *)

  val ( <?> ) : 'a t -> ('a -> bool) -> 'a t
  (** Parser dedicated to parser satifying a given predicate. *)

  val to_list : ('a * 'a list) t -> 'a list t
end

(** Define execution parser like backtracking, lazy or lookahead. *)
module type EXECUTION = sig
  type _ t
  (** The parse abstract type *)

  val do_try : 'a t -> 'a t
  (** Define a backtracking parser. *)

  val do_lazy : (unit -> 'a t) -> 'a t
  (** Define a lazy parser. *)

  val lookahead : 'a t -> 'a t
  (** Define a lookahead parser. *)
end

(** Define atomic parser. *)
module type ATOMIC = sig
  type e
  (** The element abstract type. Elements are provided by the stream used during
      the parsing. *)

  type _ t
  (** The parse abstract type *)

  val any : e t
  (** Define parser accepting any element *)

  val not : e t -> e t
  (** Define parser accepting any element except the recognized one. *)

  val atom : e -> e t
  (** Define parser accepting a given element. *)

  val in_list : e list -> e t
  (** Define parser accepting an element in a given list. *)

  val in_range : e -> e -> e t
  (** Define parser accepting an element in a given range. *)

  val atoms : e list -> e list t
  (** Define parser accepting a given element list i.e. a sequence. *)
end

(** Define repeatable or optional parser. *)
module type REPEATABLE = sig
  type _ t
  (** The parse abstract type. *)

  val opt : 'a t -> 'a option t
  (** Define a parser maybe accepting something. *)

  val optrep : 'a t -> 'a list t
  (** Define a parser accepting something more than once or nothing. *)

  val rep : 'a t -> 'a list t
  (** Define a parser accepting something more than once. *)
end

(** {1 API} *)

module type API = sig
  include CORE

  include MONAD with type 'a t := 'a t

  include BASIC with type 'a t := 'a t

  include FLOW with type 'a t := 'a t

  include EXECUTION with type 'a t := 'a t

  include ATOMIC with type 'a t := 'a t and type e := e

  include REPEATABLE with type 'a t := 'a t

  include MONAD with type 'a t := 'a t
end
