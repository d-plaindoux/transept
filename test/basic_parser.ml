module Parser = Transept_extension.Parser.For_char_list
module Stream = Parser.Stream
module Response = Parser.Response

let build s = Stream.build @@ Transept_utils.Utils.chars_of_string s

let should_parse_return () =
  let expected = Some 42, false
  and computed =
    Response.fold
      Parser.(parse (return 42) (build ""))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option int) bool)) "should_return" expected computed

let should_parse_fails () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse fail (build ""))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option int) bool)) "should_fails" expected computed

let should_parse_any () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse any (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool)) "should_fails" expected computed

let should_not_parse_eos () =
  let expected = Some (), false
  and computed =
    Response.fold
      Parser.(parse eos (build ""))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option unit) bool)) "should_not_eos" expected computed

let should_not_parse_any () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse any (build ""))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_not_parse_any" expected computed

let test_cases =
  ( "Try basic parsers"
  , let open Alcotest in
    [
      test_case "Should return" `Quick should_parse_return
    ; test_case "Should fails" `Quick should_parse_fails
    ; test_case "Should parse an atom" `Quick should_parse_any
    ; test_case "Should not parse an atom" `Quick should_not_parse_any
    ] )
