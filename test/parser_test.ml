let () =
  let open Alcotest in
  run "checker"
    [
      Stream_char.test_cases
    ; Basic_parser.test_cases
    ; Atom_parser.test_cases
    ; Execution_parser.test_cases
    ; Sequence_parser.test_cases
    ; Repeatable_parser.test_cases
    ; Json_parser.test_cases
    ; Stream_parser.test_cases
    ]
