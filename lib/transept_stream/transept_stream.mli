(** The [Transept_streams] provides an implementation on top of elements list
    and on top of a parser. In addition [Iterator] can be derived from these
    streams. *)

module Via_list = List.Via_list
(** Define stream construction from elements list source. *)

module Via_parser = Parser.Make
(** Define stream construction from parser. *)

module Iterator = Iterator.Make
(** Define iterator generator/ *)
