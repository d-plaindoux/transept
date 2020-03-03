module Parser = Transept_extension.Parser.For_char_list
module Stream = Parser.Stream
module Response = Parser.Response

let build s = Stream.build @@ Transept_utils.Utils.chars_of_string s

let should_parse_a_char () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse (opt @@ atom 'a') (build "a"))
      (fun (_, a, b) -> a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_a_char" expected computed

let should_parse_nothing () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse (opt @@ atom 'a') (build "b"))
      (fun (_, a, b) -> a, b)
      (fun (_, b) -> Some '?', b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_nothing" expected computed

let should_parse_nothing_with_repeatable () =
  let expected = Some [], false
  and computed =
    Response.fold
      Parser.(parse (optrep @@ atom 'a') (build ""))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option (list char)) bool))
    "should_parse_with_repeatable" expected computed

let should_parse_not_char_with_repeatable () =
  let expected = None, false
  and computed =
    Response.fold
      Parser.(parse (rep @@ atom 'a') (build "b"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option (list char)) bool))
    "should_parse_not_char_with_repeatable" expected computed

let should_partially_parse_with_repeatable () =
  let expected = None, true
  and computed =
    Response.fold
      Parser.(parse (rep @@ (atom 'a' <& atom '=')) (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option (list char)) bool))
    "should_partially_parse_with_repeatable" expected computed

let should_parse_million_chars_with_repeatable () =
  let expected = 1_000_000, true
  and computed =
    Response.fold
      Parser.(parse (optrep @@ atom 'a') (build (String.make 1_000_000 'a')))
      (fun (_, a, b) -> List.length a, b)
      (fun (_, b) -> 0, b)
  in
  Alcotest.(check (pair int bool))
    "should_parse_million_chars_with_repeatable" expected computed

let test_cases =
  ( "Try optional an repeatable parsers"
  , let open Alcotest in
    [
      test_case "Should parse a char" `Quick should_parse_a_char
    ; test_case "Should parse nothing" `Quick should_parse_nothing
    ; test_case "Should parse nothing with repeatable" `Quick
        should_parse_nothing_with_repeatable
    ; test_case "Should parse no char with repeatable" `Quick
        should_parse_not_char_with_repeatable
    ; test_case "Should partially parse with repeatable" `Quick
        should_partially_parse_with_repeatable
    ; test_case "Should parse million chars with repeatable" `Quick
        should_parse_million_chars_with_repeatable
    ] )
