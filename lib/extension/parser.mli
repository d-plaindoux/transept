module Make (E : Transept_specs.ELEMENT) :
  Transept_specs.PARSER
    with type e = E.t
     and module Stream = Transept_stream.Via_list
     and module Response = Transept_parser.Response.Basic
