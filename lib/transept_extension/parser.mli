module Make (S : Transept_specs.STREAM) (E : Transept_specs.ELEMENT) :
  Transept_specs.PARSER
    with type e = E.t
     and module Stream = S
     and module Response = Transept_core.Response.Basic

module For_char_via_stream (S : Transept_specs.STREAM) :
  Transept_specs.PARSER
    with type e = char
     and module Stream = S
     and module Response = Transept_core.Response.Basic

module Via_element_for_list (E : Transept_specs.ELEMENT) :
  Transept_specs.PARSER
    with type e = E.t
     and module Stream = Transept_stream.Via_list
     and module Response = Transept_core.Response.Basic

module For_char_list :
  Transept_specs.PARSER
    with type e = char
     and module Stream = Transept_stream.Via_list
     and module Response = Transept_core.Response.Basic
