class type _error = object
end [@bs]
type error = _error Js.t
type error_or_null = error Js.null

type namespace = string

type kind = string

type operator = string

class type _key = object
  method namespace : namespace
  method kind : kind
  method name : string
end [@bs]
type key = _key Js.t

type endCursor

type moreResults

type 'a entity = 'a Js.t

type 'a data_with_key = < key : key
                        ; data : 'a Js.t
                        > Js.t

class type _queryInfo = object
  method moreResults : moreResults
  method endCursor : endCursor
end [@bs]
type queryInfo = _queryInfo Js.t

class type _query = object
  method filter : string -> operator -> string -> unit
  method order : string -> unit
  method limit : int -> unit
  method hasAncestor : key -> unit
  method start : endCursor -> unit

  method run : (error_or_null -> 'entity array -> queryInfo -> unit[@bs])
    -> unit
end [@bs]
type query = _query Js.t

class type queryable = object
  method get : key
    -> (error_or_null -> 'a entity Js.undefined -> unit[@bs])
    -> unit
  method get__many : key array
    -> (error_or_null -> 'a entity array -> unit[@bs])
    -> unit

  method createQuery : kind -> query
  method createQuery__ns : string -> kind -> query
end [@bs]

class type _transaction = object
  inherit queryable

  method run : (error_or_null -> unit[@bs]) -> unit

  method delete : key array -> unit
  method save : 'a data_with_key array -> unit

  method commit : (error_or_null -> unit[@bs]) -> unit
  method rollback : (error_or_null -> unit[@bs]) -> unit
end [@bs]
type transaction = _transaction Js.t

class type _t = object
  inherit queryable

  method save : 'a data_with_key array -> (error_or_null -> unit[@bs]) -> unit
  method delete : key -> (error_or_null -> unit[@bs]) -> unit

  method key__incomplete : kind -> key
  method key : kind * 'a -> key
  method key__ns : < namespace: namespace; path: kind * 'a > Js.t -> key

  method transaction : unit -> transaction
end [@bs]
type t = _t Js.t

module Raw = struct
  external make : unit -> t = "@google-cloud/datastore" [@@bs.module]

  type t
  external datastore : t = "@google-cloud/datastore" [@@bs.module]

  class type _double = object
    method value : float
  end [@bs]
  type double = _double Js.t

  class type _geoPoint = object
    method value : < latitude: float; longitude: float > Js.t
  end [@bs]
  type geoPoint = _geoPoint Js.t

  class type _int = object
    method value : string
  end [@bs]
  type int = _int Js.t

  external double : t -> float -> double = "" [@@bs.send]
  external int : t -> string -> int = "" [@@bs.send]
  external geoPoint : t -> < latitude: float; longitude: float; .. > Js.t
    -> geoPoint = "" [@@bs.send]

  type symbol
  external _KEY : t -> symbol = "KEY" [@@bs.get]
  external key_of_entity : 'a entity -> symbol -> key = "" [@@bs.get_index]

  external _MORE_RESULTS_AFTER_CURSOR : t -> moreResults
    = "MORE_RESULTS_AFTER_CURSOR" [@@bs.get]
  external _MORE_RESULTS_AFTER_LIMIT : t -> moreResults
    = "MORE_RESULTS_AFTER_LIMIT" [@@bs.get]
  external _NO_MORE_RESULTS : t -> moreResults
    = "NO_MORE_RESULTS" [@@bs.get]
end

let datastore = Raw.make

let double n = Raw.double Raw.datastore n
let int n = Raw.int Raw.datastore n
let geoPoint p = Raw.geoPoint Raw.datastore p

let key_of_entity entity = Raw.key_of_entity entity (Raw._KEY Raw.datastore)

let _MORE_RESULTS_AFTER_CURSOR = Raw._MORE_RESULTS_AFTER_CURSOR Raw.datastore
let _MORE_RESULTS_AFTER_LIMIT = Raw._MORE_RESULTS_AFTER_LIMIT Raw.datastore
let _NO_MORE_RESULTS = Raw._NO_MORE_RESULTS Raw.datastore
