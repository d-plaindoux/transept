type 'a t = int * 'a list

module Build_via_list = struct
  type nonrec 'a t = 'a list -> 'a t

  let build l = 0, l
end

module Make (B : Transept_specs.Stream.BUILDER) = struct
  module Builder = B

  type nonrec 'a t = 'a t

  let build = B.build

  let position = function
    | p, _ -> p

  let next = function
    | p, [] -> None, (p, [])
    | p, e :: l -> Some e, (p + 1, l)
end

module Via_list = struct
  include Make (Build_via_list)
end
