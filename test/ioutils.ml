let test_directory = "../../../test/"

let read_fully filename =
  let text = ref "" in
  let chan = open_in (test_directory ^ filename) in
  try
    while true do
      text := !text ^ "\n" ^ input_line chan
    done;
    !text
  with
  | End_of_file ->
    close_in chan;
    !text
