(** Wrapper around each component of [Transept]. *)

(** {2 Signatures} *)

module Specs = Transept_specs

(** {2 Libraries} *)

module Core = Transept_core
module Stream = Transept_stream

(** {2 Extensions} *)

module Extension = Transept_extension

(** {2 Standard libraries} *)

module Utils = Transept_utils.Utils
module Genlex = Transept_genlex
module Json = Transept_json
