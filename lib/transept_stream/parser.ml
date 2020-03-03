module Make (Parser : Transept_specs.PARSER) = struct
  type 'a r = 'a Parser.t * Parser.e Parser.Stream.t

  module Build_via_stream = struct
    type nonrec 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a r

    let build p s = p, s
  end

  module Stream = struct
    type nonrec 'a t = 'a r

    module Builder = Build_via_stream

    let build = Build_via_stream.build

    let position = function _, s -> Parser.Stream.position s

    let is_empty = function
      | _, s ->
        let open Parser in
        let open Parser.Response in
        let open Transept_utils.Utils in
        fold (parse eos s) (constant true) (constant false)

    let next = function
      | p, s ->
        let open Parser in
        let open Parser.Response in
        fold (parse p s)
          (fun (s, a, _) -> Some a, (p, s))
          (fun (s, _) -> None, (p, s))
  end

  include Stream
end
