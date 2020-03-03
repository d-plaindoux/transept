(** The [Transept_specs] provides all signatures mandatory for [Transept]. *)

module Element = Element
(** Describes an element *)

module Stream = Stream
(** Describes a stream *)

module Response = Response
(** Describes a response *)

module Parser = Parser
(** Describes a parser *)

(** {1 API Shortcuts}

    Shortcuts for the API of each objects (by convention, OCaml module types are
    in uppercase). *)

module type ELEMENT = Element.API

module type STREAM = Stream.API

module type RESPONSE = Response.API

module type PARSER = Parser.API
