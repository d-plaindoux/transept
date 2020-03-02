type 'a t = int * 'a list

module Build_via_list = struct
  type nonrec 'a t = 'a list -> 'a t

  let build l = 0, l
end

module Via_list = struct
  module Builder = Build_via_list

  type nonrec 'a t = 'a t

  let build = Builder.build

  let position = function p, _ -> p

  let is_empty s = snd s = []

  let next = function p, [] -> None, (p, []) | p, e :: l -> Some e, (p + 1, l)
end
