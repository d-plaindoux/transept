val constant : 'a -> 'b -> 'a
(** Produce a function that returns its first argument. [const a b] returns
    always [a]. *)

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c

val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c

val chars_of_string : string -> char list

val string_of_chars : char list -> string
