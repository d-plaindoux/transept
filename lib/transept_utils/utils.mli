(** Basic functions *)

val constant : 'a -> 'b -> 'a
(** Produce a function that returns its first argument. [const a b] returns
    always [a]. *)

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
(** Produce the uncurryfied version of the parametric function.
    [uncurry f (x, y)] is equivalent [f x y]. *)

val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
(** Produce the curryfied version of the parametric function [curry f x y] is
    equivalent [f (x, y)].*)

val chars_of_string : string -> char list
(** Transform a string to a characters list. *)

val string_of_chars : char list -> string
(** Transform a characters list to a string. *)
