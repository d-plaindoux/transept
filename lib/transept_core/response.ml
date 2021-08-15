module Response = struct
  type ('s, 'a) t = ('s * 'a * bool, 's * bool) result

  let success v = Ok v

  let failure v = Error v

  let fold response s f =
    (match response with Ok v -> s v | Error v -> f v)
end
