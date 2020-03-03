module Basic = struct
  type ('s, 'a) t = ('s * 'a * bool, 's * bool) result

  let success v = Ok v

  let failure v = Error v

  let fold response fSuccess fFailure =
    (match response with Ok v -> fSuccess v | Error v -> fFailure v)
end
