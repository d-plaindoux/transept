module Make_via_response_and_stream
    (R : Transept_specs.RESPONSE)
    (S : Transept_specs.STREAM)
    (E : Transept_specs.ELEMENT) :
  Transept_specs.PARSER
    with type e = E.t
     and module Response = R
     and module Stream = S

module Make_via_stream (S : Transept_specs.STREAM) (E : Transept_specs.ELEMENT) :
  Transept_specs.PARSER
    with type e = E.t
     and module Stream = S
     and module Response = Response.Basic
