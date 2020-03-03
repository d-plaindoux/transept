(** Define the [Stream] [Iterator] module *)

(** Iterator builder via a [Stream] *)
module Make (Stream : Transept_specs.STREAM) :
  Transept_utils.ITERATOR with type 'a t = 'a Stream.t
