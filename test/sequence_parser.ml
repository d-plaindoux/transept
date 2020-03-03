module Parser = Transept_extension.Parser.For_char_list
module Stream = Parser.Stream
module Response = Parser.Response

let build s = Stream.build @@ Transept_utils.Utils.chars_of_string s

let should_parse_two_chars () =
  let expected = Some ('a', 'b'), true
  and computed =
    Response.fold
      Parser.(parse (any <&> any) (build "ab"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option (pair char char)) bool))
    "should_parse_two_chars" expected computed

let should_not_parse_two_chars () =
  let expected = None, true
  and computed =
    Response.fold
      Parser.(parse (any <&> any) (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option (pair char char)) bool))
    "should_not_parse_two_chars" expected computed

let should_parse_choosing_first () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse (any <|> any) (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_choosing_first" expected computed

let should_parse_choosing_second () =
  let expected = Some 'a', true
  and computed =
    Response.fold
      Parser.(parse (fail <|> any) (build "a"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option char) bool))
    "should_parse_choosing_second" expected computed

let test_cases =
  ( "Try sequence and choice parsers"
  , let open Alcotest in
    [
      test_case "Should parse two chars" `Quick should_parse_two_chars
    ; test_case "Should not parse two chars" `Quick should_not_parse_two_chars
    ; test_case "Should parse choosing first char" `Quick
        should_parse_choosing_first
    ; test_case "Should parse choosing second char" `Quick
        should_parse_choosing_second
    ] )
