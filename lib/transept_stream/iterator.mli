module Make (Stream : Transept_specs.STREAM) :
  Transept_specs.ITERATOR with type 'a t = 'a Stream.t
