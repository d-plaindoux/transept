module Parser = Transept_extension.Parser.For_char_list
module Stream = Parser.Stream
module Response = Parser.Response

let build s = Stream.build @@ Transept_utils.Utils.chars_of_string s

let should_parse_do_try () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse (do_try @@ atom 'a') (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_do_try" expected computed

let should_parse_do_try_and_fail () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse (do_try (atom 'a' <& atom 'b')) (build "ac"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_do_try_and_fail" expected computed

let should_parse_not_a () =
  let expected = Some 'b', true
  and computed =
    Response.fold
      Parser.(parse (not @@ atom 'a') (build "b"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_not_a" expected computed

let should_parse_not_a_and_fail () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse (not @@ atom 'a') (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_not_a_and_fail" expected computed

let should_parse_lookahead () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse (lookahead @@ atom 'a' &> atom 'a') (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_lookahead" expected computed

let test_cases =
  ( "Try execution parsers"
  , let open Alcotest in
    [
      test_case "Should parse do_try" `Quick should_parse_do_try
    ; test_case "Should parse do_try and fail" `Quick
        should_parse_do_try_and_fail
    ; test_case "Should parse not a" `Quick should_parse_not_a
    ; test_case "Should parse not a and fail" `Quick should_parse_not_a_and_fail
    ; test_case "Should parse lookahead" `Quick should_parse_lookahead
    ] )
