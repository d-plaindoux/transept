module Utils = Transept_utils.Utils

module Monadic_via_response (R : Transept_specs.RESPONSE) = struct
  let ( <$> ) p f s =
    let open R in
    fold (p s)
      (fun (s, a, consumed) -> success (s, f a, consumed))
      (fun (s, consumed) -> failure (s, consumed))

  let ( >>= ) p f s =
    let open R in
    fold (p s)
      (fun (s, a, consumed_1) ->
        fold (f a s)
          (fun (s, b, consumed_2) -> success (s, b, consumed_1 || consumed_2))
          (fun (s, consumed) -> failure (s, consumed)))
      (fun (s, consumed) -> failure (s, consumed))
end

module Basic_via_response_and_stream
    (R : Transept_specs.RESPONSE)
    (S : Transept_specs.STREAM) =
struct
  let return a s = R.(success (s, a, false))

  let fail s = R.(failure (s, false))

  let eos s =
    let open R in
    S.(if is_empty s then success (s, (), false) else failure (s, false))

  let any s =
    let open R in
    match S.next s with
    | Some e, s -> success (s, e, true)
    | None, s -> failure (s, false)
end

module Flow_via_response (R : Transept_specs.RESPONSE) = struct
  open Monadic_via_response (R) (* TODO review this code ASAP *)

  let ( <&> ) pl pr s =
    let open R in
    fold (pl s)
      (fun (s, a, consumed_1) ->
        fold (pr s)
          (fun (s, b, consumed_2) ->
            success (s, (a, b), consumed_1 || consumed_2))
          (fun (s, consumed_2) -> failure (s, consumed_1 || consumed_2)))
      (fun (s, consumed) -> failure (s, consumed))

  let ( <& ) pl pr = pl <&> pr <$> fst

  let ( &> ) pl pr = pl <&> pr <$> snd

  let ( <|> ) pl pr s =
    let open R in
    fold (pl s)
      (fun (s, a, consumed) -> success (s, a, consumed))
      (fun (s', consumed) -> if consumed then failure (s', consumed) else pr s)

  let ( <?> ) p f s =
    let open R in
    fold (p s)
      (fun (s, a, consumed) ->
        if f a then success (s, a, consumed) else failure (s, false))
      (fun (s, _) -> failure (s, false))

  let to_list p = p <$> (fun (e, l) -> e :: l)
end

module Execution_via_response (R : Transept_specs.RESPONSE) = struct
  let do_try p s =
    let open R in
    fold (p s)
      (fun (s, a, consumed) -> success (s, a, consumed))
      (fun (s, _) -> failure (s, false))

  let do_lazy p s = p () s

  let lookahead p s =
    let open R in
    fold (p s)
      (fun (_, a, _) -> success (s, a, false))
      (fun (s, b) -> failure (s, b))
end

module Atomic_via_response_and_stream
    (R : Transept_specs.RESPONSE)
    (S : Transept_specs.STREAM) =
struct
  open Basic_via_response_and_stream (R) (S) (* TODO review this code ASAP *)

  open Monadic_via_response (R) (* TODO review this code ASAP *)

  open Execution_via_response (R) (* TODO review this code ASAP *)

  open Flow_via_response (R) (* TODO review this code ASAP *)

  let not p s =
    R.(fold (p s) (fun (s, _, _) -> failure (s, false)) (fun _ -> any s))

  let atom e = any <?> (fun e' -> e' = e)

  let in_list l = any <?> (fun e -> List.mem e l)

  let in_range min max = any <?> (fun e' -> min <= e' && e' <= max)

  let atoms l =
    let open List in
    do_try (fold_left (fun p e -> p <& atom e) (return ()) l)
    <$> Utils.constant l
end

module Repeatable_via_response
    (R : Transept_specs.RESPONSE)
    (S : Transept_specs.STREAM) =
struct
  open Basic_via_response_and_stream (R) (S) (* TODO review this code ASAP *)

  open Monadic_via_response (R) (* TODO review this code ASAP *)

  open Execution_via_response (R) (* TODO review this code ASAP *)

  open Flow_via_response (R) (* TODO review this code ASAP *)

  let opt p = p <$> (fun e -> Some e) <|> return None

  let sequence optional p s =
    let open R in
    (* sequence is tail recursive *)
    let rec sequence s aux b =
      fold (p s)
        (fun (s, a, b') -> sequence s (a :: aux) (b || b'))
        (fun (s', b') ->
          if aux != [] || optional
          then success (s, List.rev aux, b || b')
          else failure (s', b || b'))
    in
    sequence s [] false

  let optrep p = sequence true p

  let rep p = sequence false p
end

module Make_via_response_and_stream
    (R : Transept_specs.RESPONSE)
    (S : Transept_specs.STREAM)
    (E : Transept_specs.ELEMENT) =
struct
  module Response = R
  module Stream = S

  type e = E.t

  type 'a t = e Stream.t -> (e Stream.t, 'a) Response.t

  let parse p s = p s

  include Monadic_via_response (R)
  include Basic_via_response_and_stream (R) (S)
  include Flow_via_response (R)
  include Atomic_via_response_and_stream (R) (S)
  include Execution_via_response (R)
  include Repeatable_via_response (R) (S)
end

module Make_via_stream (S : Transept_specs.STREAM) (E : Transept_specs.ELEMENT) =
struct
  include Make_via_response_and_stream (Response.Basic) (S) (E)
end
