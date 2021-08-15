module type Location = sig
  type t

  include Preface.Specs.MONOID with type t := t

  val locate : string -> t

end
