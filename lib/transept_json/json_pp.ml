open Json

(* cf. https://github.com/xvw/planet/blob/master/src/paperwork/json.ml *)

let rec pp ppf = function
  | String value -> Format.fprintf ppf "\"%s\"" value
  | Bool true -> Format.fprintf ppf "true"
  | Bool false -> Format.fprintf ppf "false"
  | Number value -> Format.fprintf ppf "%f" value
  | Null -> Format.fprintf ppf "null"
  | Array x -> Format.fprintf ppf "[@[<hov 1>%a@]]" ppa x
  | Record x -> Format.fprintf ppf "{@[<hov 1>%a@]}" ppr x

and ppa ppf = function
  | x :: (_ :: _ as xs) ->
    let () = Format.fprintf ppf "%a,@ " pp x in
    ppa ppf xs
  | x :: xs ->
    let () = Format.fprintf ppf "%a" pp x in
    ppa ppf xs
  | [] -> ()

and ppr ppf = function
  | (key, x) :: (_ :: _ as xs) ->
    let () = Format.fprintf ppf "\"%s\": %a,@ " key pp x in
    ppr ppf xs
  | (key, x) :: xs ->
    let () = Format.fprintf ppf "\"%s\": %a" key pp x in
    ppr ppf xs
  | [] -> ()

let eq_list f a b =
  let rec aux = function
    | [], [] -> true
    | x :: xs, y :: ys -> f x y && aux (xs, ys)
    | _ -> false
  in
  aux (a, b)

let eq_record f a b =
  let rec aux = function
    | [], [] -> true
    | (sx, x) :: xs, (sy, y) :: ys -> sx = sy && f x y && aux (xs, ys)
    | _ -> false
  in
  aux (a, b)

let eq f a b =
  let aux = function
    | Null, Null -> true
    | Bool b1, Bool b2 -> b1 = b2
    | Number b1, Number b2 -> b1 = b2
    | String b1, String b2 -> b1 = b2
    | Array b1, Array b2 -> eq_list f b1 b2
    | Record b1, Record b2 -> eq_record f b1 b2
    | _ -> false
  in
  aux (a, b)

let to_string = Format.asprintf "%a" pp
