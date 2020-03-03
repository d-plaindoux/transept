module Parser = Transept_extension.Parser.For_char_list
module Utils = Transept_utils.Utils
module Literals = Transept_extension.Literals.Make (Parser)
module Stream = Transept_stream.Via_parser (Parser)

let build p s = Stream.build p (Parser.Stream.build @@ Utils.chars_of_string s)

let tokenizer =
  Parser.(opt Literals.spaces &> Literals.ident <& opt Literals.spaces)

let result (a, s) = a, Stream.position s

let should_read_a_string () =
  let expected = Some "hello", 6
  and computed = result @@ Stream.next (build tokenizer "hello world") in
  Alcotest.(check (pair (option string) int))
    "should_read_a_string" expected computed

let should_read_a_second_string () =
  let expected = Some "world", 11
  and computed =
    result @@ Stream.next @@ snd @@ Stream.next @@ build tokenizer "hello world"
  in
  Alcotest.(check (pair (option string) int))
    "should_read_a_second_string" expected computed

let should_read_nothing () =
  let expected = None, 0
  and computed = result @@ Stream.next (build tokenizer "") in
  Alcotest.(check (pair (option string) int))
    "should_read_a_second_string" expected computed

let should_read_all_tokens () =
  let module Iterator = Transept_stream.Iterator (Stream) in
  let to_list stream = Iterator.fold_right (fun e l -> e :: l) stream [] in
  let expected = [ "This"; "is"; "a"; "test" ]
  and computed = to_list (build tokenizer "This is a test") in
  Alcotest.(check (list string)) "should_read_all_tokens" expected computed

let test_cases =
  ( "Try stream from parser"
  , let open Alcotest in
    [
      test_case "Should read a string" `Quick should_read_a_string
    ; test_case "Should read a second string" `Quick should_read_a_second_string
    ; test_case "Should read nothing" `Quick should_read_nothing
    ; test_case "Should read all tokens" `Quick should_read_all_tokens
    ] )
