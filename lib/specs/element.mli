module CORE : sig
  type t
end

module type API = module type of CORE
