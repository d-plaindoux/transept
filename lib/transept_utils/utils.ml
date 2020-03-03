let constant c _ = c

let uncurry f (x, y) = f x y

let curry f x y = f (x, y)

let chars_of_string s = List.init (String.length s) (String.get s)

let string_of_chars chars =
  let buf = Buffer.create 13 in
  List.iter (Buffer.add_char buf) chars;
  Buffer.contents buf
