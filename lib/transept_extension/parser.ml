module Make (E : Transept_specs.ELEMENT) = struct
  include Transept_core.Parser.Make_via_stream (Transept_stream.Via_list) (E)
end

module CharParser = Make (struct
  type t = char
end)
