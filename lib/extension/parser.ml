module Make (E : Transept_specs.ELEMENT) = struct
  include Transept_parser.Parser.Make_via_stream (Transept_stream.Via_list) (E)
end
