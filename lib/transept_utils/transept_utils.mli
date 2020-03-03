(** The [Transept_utils] provides basic function and modules used by [Transept] *)

module Utils = Utils
(** Describes the basic functions *)

module Iterator = Iterator
(** Describes the minimal iterator module *)

(** {1 API Shortcuts}

    Shortcuts for the API of each objects (by convention, OCaml module types are
    in uppercase). *)

module type ITERATOR = Iterator.API
