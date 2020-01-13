type ('s, 'a) t =
  | Success of 's * 'a * bool
  | Failure of 's * bool

module Basic : Transept_specs.RESPONSE with type ('s, 'a) t = ('s, 'a) t
