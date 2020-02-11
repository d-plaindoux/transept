module Utils = Transept_utils.Utils
module Stream = Transept_stream.Via_list

let build s = Stream.build @@ Utils.chars_of_string s

let should_read_a_char () =
  let expected = Some 'a' and computed = fst @@ Stream.next (build "a") in
  Alcotest.(check (option char)) "should_read_a_char" expected computed

let should_read_a_second_char () =
  let expected = Some 'b'
  and computed = fst @@ Stream.next @@ snd @@ Stream.next (build "ab") in
  Alcotest.(check (option char)) "should_read_a_second_char" expected computed

let should_read_nothing () =
  let expected = None and computed = fst @@ Stream.next (build "") in
  Alcotest.(check (option char)) "should_read_noting" expected computed

let test_cases =
  ( "Try stream from chars",
    Alcotest.
      [
        test_case "Should read a char" `Quick should_read_a_char;
        test_case "Should read a second char" `Quick should_read_a_second_char;
        test_case "Should read nothing" `Quick should_read_nothing;
      ] )
