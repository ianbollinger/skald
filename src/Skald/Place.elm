module Skald.Place
  ( Place
  , place
  , empty
  , withExit
  , withObject
  ) where

import Dict exposing (Dict)

import Skald.Object as Object exposing (Object)


type alias Place =
  { name : String
  , description : String
  , exits : Dict String String
  , contents : Dict String Object
  }


place : String -> String -> Place
place name description =
  { name = name
  , description = description
  , exits = Dict.empty
  , contents = Dict.empty
  }


empty : Place
empty =
  place "An Error"
    "It's likely the author forgot to add `|> thatBeginsIn place` to her tale."


withExit : String -> String -> Place -> Place
withExit exit to from =
  { from | exits <- Dict.insert exit to from.exits }


withObject : Object -> Place -> Place
withObject object place =
  { place | contents <- Dict.insert (Object.name object) object place.contents }
