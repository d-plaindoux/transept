module Utils = Transept_utils.Utils
module CharParser = Transept_extension.Parser.For_char_list
module Stream = Transept_stream.Via_parser (CharParser)

let build s =
  let module Genlex = Transept_genlex.Lexer.Make (CharParser) in
  let keywords = Transept_json.Parser.keywords in
  let tokenizer = Genlex.tokenizer_with_spaces keywords in
  Stream.build tokenizer (CharParser.Stream.build @@ Utils.chars_of_string s)

module Parser =
  Transept_core.Parser.Make_via_stream
    (Stream)
    (struct
      type t = Transept_genlex.Lexeme.t
    end)

module Json = Transept_json.Type
module Json_parser = Transept_json.Parser.Make (Parser)
module Response = Parser.Response
module Json_pp = Transept_json.PrettyPrinter

let json = Alcotest.testable Json_pp.pp (Json_pp.eq ( = ))

let should_parse_null () =
  let expected = (Some Json.Null, true), 4
  and computed =
    Response.fold
      (Parser.parse Json_parser.null (build "null"))
      (fun (s, a, c) -> (Some a, c), Parser.Stream.position s)
      (fun (s, c) -> (None, c), Parser.Stream.position s)
  in
  Alcotest.(check (pair (pair (option json) bool) int))
    "should_parse_null" expected computed

let should_parse_true () =
  let expected = Some (Json.Bool true), true
  and computed =
    Response.fold
      (Parser.parse Json_parser.bool (build "true"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_true" expected computed

let should_parse_false () =
  let expected = Some (Json.Bool false), true
  and computed =
    Response.fold
      (Parser.parse Json_parser.bool (build "false"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_false" expected computed

let should_parse_float () =
  let expected = Some (Json.Number 12.3), true
  and computed =
    Response.fold
      (Parser.parse Json_parser.number (build "12.3"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_float" expected computed

let should_parse_string () =
  let expected = Some (Json.String "Hello"), true
  and computed =
    Response.fold
      (Parser.parse Json_parser.string (build "\"Hello\""))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_float" expected computed

let should_parse_empty_array () =
  let expected = Some (Json.Array []), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.array ()) (build "[]"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_empty_array" expected computed

let should_parse_array_with_singleton () =
  let expected = Some (Json.Array [ Json.Number 12.0 ]), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.array ()) (build "[ 12 ]"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_array_with_singleton" expected computed

let should_parse_array () =
  let expected =
    Some (Json.Array [ Json.Number 12.0; Json.String "toto" ]), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.array ()) (build "[ 12, \"toto\" ]"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_array" expected computed

let should_parse_empty_record () =
  let expected = Some (Json.Record []), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.record ()) (build "{}"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_empty_record" expected computed

let should_parse_record_with_singleton () =
  let expected = Some (Json.Record [ "a", Json.Number 12.0 ]), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.record ()) (build "{ \"a\": 12 }"))
      (fun (_, a, c) -> Some a, c)
      (fun (_, c) -> None, c)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_record_with_singleton" expected computed

let should_parse_record () =
  let expected =
    Some (Json.Record [ "a", Json.Number 12.0; "b", Json.Array [] ]), true
  and computed =
    Response.fold
      (Parser.parse (Json_parser.record ())
         (build "{ \"a\" : 12, \"b\" : [] }"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_record" expected computed

let should_parse_json () =
  let expected =
    ( Some
        (Json.Record
           [
             "a", Json.Number 12.0
           ; ( "b"
             , Json.Array
                 [ Json.Record [ "a", Json.Number 12.0; "b", Json.Array [] ] ] )
           ])
    , true )
  and computed =
    Response.fold
      (Parser.parse (Json_parser.json ())
         (build "{ \"a\" : 12, \"b\" : [{ \"a\" : 12, \"b\" : [] }] }"))
      (fun (_, a, b) -> Some a, b)
      (fun (_, b) -> None, b)
  in
  Alcotest.(check (pair (option json) bool))
    "should_parse_json" expected computed

let should_parse_a_large_json () =
  let content = Ioutils.read_fully "samples/127k.json" in
  let expected = "OK"
  and computed =
    Response.fold
      (Parser.parse (Json_parser.json ()) (build content))
      (Utils.constant "OK")
      (fun (s, _) ->
        "Error at char <" ^ (string_of_int @@ Stream.position s) ^ ">\n")
  in
  Alcotest.(check string) "should_parse_a_large_json" expected computed

let should_parse_a_json_not_well_formed () =
  let content = Ioutils.read_fully "samples/nwff.json" in
  let expected = false, 17
  and computed =
    Response.fold
      (Parser.parse (Json_parser.json ()) (build content))
      (fun (s, _, _) -> true, Stream.position s)
      (fun (s, _) -> false, Stream.position s)
  in
  Alcotest.(check (pair bool int))
    "should_parse_a_json_not_well_formed" expected computed

let test_cases =
  ( "Try json parsers"
  , let open Alcotest in
    [
      test_case "Should parse null" `Quick should_parse_null
    ; test_case "Should parse true" `Quick should_parse_true
    ; test_case "Should parse false" `Quick should_parse_false
    ; test_case "Should parse float" `Quick should_parse_float
    ; test_case "Should parse string" `Quick should_parse_string
    ; test_case "Should parse empty array" `Quick should_parse_empty_array
    ; test_case "Should parse array with one element" `Quick
        should_parse_array_with_singleton
    ; test_case "Should parse array" `Quick should_parse_array
    ; test_case "Should parse empty record" `Quick should_parse_empty_record
    ; test_case "Should parse record with one element" `Quick
        should_parse_record_with_singleton
    ; test_case "Should parse record" `Quick should_parse_record
    ; test_case "Should parse json" `Quick should_parse_json
    ; test_case "Should parse a large json" `Quick should_parse_a_large_json
    ; test_case "Should parse a json not well formed" `Quick
        should_parse_a_json_not_well_formed
    ] )
