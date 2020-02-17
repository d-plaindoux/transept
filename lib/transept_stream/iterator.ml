module Make (Stream : Transept_specs.STREAM) = struct
  type 'a t = 'a Stream.t

  let fold_right fSome s fNone =
    let rec iterate s r =
      match Stream.next s with
      | None, _ -> r
      | Some a, s -> fSome a @@ iterate s r
    in
    iterate s fNone

  let fold_left fSome fNone s =
    let rec iterate r s =
      match Stream.next s with
      | None, _ -> r
      | Some a, s -> iterate (fSome r a) s
    in
    iterate fNone s
end
