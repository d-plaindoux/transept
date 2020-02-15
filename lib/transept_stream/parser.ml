module Make (Parser : Transept_specs.PARSER) = struct
  type 'a t = 'a Parser.t * Parser.e Parser.Stream.t

  module Build_via_stream = struct
    type nonrec 'a t = 'a Parser.t -> Parser.e Parser.Stream.t -> 'a t

    let build p s = (p, s)
  end

  module Builder = Build_via_stream

  let build = Build_via_stream.build

  let position = function (_, s) -> Parser.Stream.position s

  let is_empty =
    let open Transept_utils.Utils in
    function
    | (_, s) ->
      Parser.Response.fold Parser.(parse eos s) (constant true) (constant false)
  ;;

  let next = function
    | (p, s) ->
      Parser.Response.fold
        Parser.(parse p s)
        (fun (s, a, _) -> (Some a, (p, s)))
        (fun (s, _) -> (None, (p, s)))
  ;;
end
