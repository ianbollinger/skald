module Skald.Place
  ( Place
  , place
  , empty
  , withExit
  , withObject
  ) where

import Dict exposing (Dict)

import Skald.Object as Object exposing (Object)


{-| See `Skald.elm` for documentation.
-}
type alias Place =
  { name : String
  , description : String
  , exits : Dict String String
  , contents : Dict String Object
  }


{-| See `Skald.elm` for documentation.
-}
place : String -> String -> Place
place name description =
  { name = name
  , description = description
  , exits = Dict.empty
  , contents = Dict.empty
  }


{-| An empty place.
-}
empty : Place
empty =
  place "An Error"
    "It's likely the author forgot to add `|> thatBeginsIn place` to her tale."


{-| See `Skald.elm` for documentation.
-}
withExit : String -> String -> Place -> Place
withExit exit to from =
  { from | exits <- Dict.insert exit to from.exits }


{-| See `Skald.elm` for documentation.
-}
withObject : Object -> Place -> Place
withObject object place =
  { place | contents <- Dict.insert (Object.name object) object place.contents }
