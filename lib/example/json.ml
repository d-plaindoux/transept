type t =
  | Null
  | Bool of bool
  | Array of t list
  | Record of (string * t) list
  | Number of float
  | String of string
