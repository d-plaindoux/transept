(** The [Transept_specs] provides all signatures mandatory for [Transept]. *)

module Response = Response

module Stream = Stream

(** Describes a response *)

(** {1 API Shortcuts}
    Shortcuts for the API of each objects (by convention, OCaml module types are
    in uppercase). *)

module type RESPONSE = Response.API

module type STREAM = Stream.API
