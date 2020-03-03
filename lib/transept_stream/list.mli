(** Propose a [Stream] implementation from an elements list source *)

type 'a t
(** The type of data manipulated by the [Stream] implemented on top of list. *)

module Build_via_list :
  Transept_specs.Stream.BUILDER with type 'a t = 'a list -> 'a t
(** The stream builder module with an element list as a source. *)

(** The stream module with an element list as a source. *)
module Via_list :
  Transept_specs.STREAM
    with type 'a t = 'a t
     and module Builder = Build_via_list
