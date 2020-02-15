type ('s, 'a) t =
  | Success of 's * 'a * bool
  | Failure of 's * bool

module Basic = struct
  type nonrec ('s, 'a) t = ('s, 'a) t

  let success (s, a, c) = Success (s, a, c)

  let failure (s, c) = Failure (s, c)

  let fold response fSuccess fFailure =
    match response with
    | Success (s, a, c) -> fSuccess (s, a, c)
    | Failure (s, c) -> fFailure (s, c)
  ;;
end
