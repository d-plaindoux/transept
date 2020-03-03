module Make (S : Transept_specs.STREAM) (E : Transept_specs.ELEMENT) = struct
  include Transept_core.Parser.Make_via_stream (S) (E)
end

module For_char_via_stream (S : Transept_specs.STREAM) =
  Make
    (S)
    (struct
      type t = char
    end)

module Via_element_for_list (E : Transept_specs.ELEMENT) =
  Make (Transept_stream.Via_list) (E)

module For_char_list =
  Make
    (Transept_stream.Via_list)
    (struct
      type t = char
    end)
