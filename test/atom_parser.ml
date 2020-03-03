module Parser = Transept_extension.Parser.For_char_list
module Stream = Parser.Stream
module Response = Parser.Response

let build s = Stream.build @@ Transept_utils.Utils.chars_of_string s

let should_parse_a_char () =
  let expected = (Some 'a', true), 1
  and computed =
    Response.fold
      Parser.(parse (atom 'a') (build "a"))
      (fun (s, a, b) -> (Some a, b), Stream.position s)
      (fun (s, b) -> (None, b), Stream.position s)
  in
  Alcotest.(check (pair (pair (option char) bool) int))
    "should_parse_a_char" expected computed

let should_not_parse_a_char () =
  let expected = (None, false), 1
  and computed =
    Response.fold
      Parser.(parse (atom 'a') (build "b"))
      (fun (s, a, b) -> (Some a, b), Stream.position s)
      (fun (s, b) -> (None, b), Stream.position s)
  in
  Alcotest.(check (pair (pair (option char) bool) int))
    "should_not_parse_a_char" expected computed

let should_parse_a_char_in_a_range () =
  let expected = Some 'f', true
  and computed =
    Response.fold
      Parser.(parse (in_range 'a' 'z') (build "f"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_a_char_in_a_range" expected computed

let should_parse_anything_else_a_char () =
  let expected = Some 'b', true
  and computed =
    Response.fold
      Parser.(parse (not (atom 'a' <|> atom 'c')) (build "b"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_anything_else_a_char" expected computed

let should_parse_a_char_with_choice () =
  let expected = Some 'b', true
  and computed =
    Response.fold
      Parser.(parse (atom 'a' <|> atom 'b') (build "b"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_a_char" expected computed

let should_parse_a_char_in_list () =
  let expected = Some 'b', true
  and computed =
    Response.fold
      Parser.(parse (in_list [ 'a'; 'b' ]) (build "b"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_a_char_in_list" expected computed

let should_parse_chars () =
  let expected = ([ 'a'; 'b' ], true), 2
  and computed =
    Response.fold
      Parser.(parse (atoms [ 'a'; 'b' ]) (build "ab"))
      (fun (s, a, b) -> (a, b), Stream.position s)
      (fun (s, b) -> ([], b), Stream.position s)
  in
  Alcotest.(check (pair (pair (list char) bool) int))
    "should_parse_chars" expected computed

let test_cases =
  ( "Try char parser"
  , let open Alcotest in
    [
      test_case "Should parse a char" `Quick should_parse_a_char
    ; test_case "Should not parse a char" `Quick should_not_parse_a_char
    ; test_case "Should parse a char in a range" `Quick
        should_parse_a_char_in_a_range
    ; test_case "Should parse anything else a char" `Quick
        should_parse_anything_else_a_char
    ; test_case "Should parse a char in a list" `Quick
        should_parse_a_char_in_list
    ; test_case "Should parse a char with a choice" `Quick
        should_parse_a_char_with_choice
    ; test_case "Should parse chars" `Quick should_parse_chars
    ] )
