type 'a t

module Build_via_list :
  Transept_specs.Stream.BUILDER with type 'a t = 'a list -> 'a t

module Make (B : Transept_specs.Stream.BUILDER) :
  Transept_specs.STREAM with type 'a t = 'a t and module Builder = B

module Via_list :
  Transept_specs.STREAM
    with type 'a t = 'a t
     and module Builder = Build_via_list
