module Skald.Place
  ( Place
  , place
  , name
  , description
  , exits
  , exitName
  , contents
  , updateContents
  , empty
  , withExit
  , withObject
  ) where

{-|
-}

import Dict exposing (Dict)

import Skald.Object as Object exposing (Object)


{-| See `Skald.elm` for documentation.
-}
type Place =
  Place
    { name : String
    , description : String
    , exits : Dict String String
    , contents : Dict String Object
    }


{-| See `Skald.elm` for documentation.
-}
place : String -> String -> Place
place name description =
  Place
    { name = name
    , description = description
    , exits = Dict.empty
    , contents = Dict.empty
    }


{-| The name of the given place.
-}
name : Place -> String
name (Place place) =
  place.name


{-| The description of the given place.
-}
description : Place -> String
description (Place place) =
  place.description


{-|
-}
contents : Place -> Dict String Object
contents (Place place) =
  place.contents


{-|
-}
exits : Place -> Dict String String
exits (Place place) =
  place.exits


{-| See `Skald.elm` for documentation.
-}
exitName : String -> Place -> Maybe String
exitName exit (Place place) =
  Dict.get exit place.exits


{-|
-}
updateContents : (Dict String Object -> Dict String Object) -> Place -> Place
updateContents f (Place place) =
  Place { place | contents <- f place.contents }


{-| An empty place.
-}
empty : Place
empty =
  place "An Error"
    "It's likely the author forgot to add `|> thatBeginsIn place` to her tale."


{-| See `Skald.elm` for documentation.
-}
withExit : String -> String -> Place -> Place
withExit exit to (Place from) =
  Place { from | exits <- Dict.insert exit to from.exits }


{-| See `Skald.elm` for documentation.
-}
withObject : Object -> Place -> Place
withObject object (Place place) =
  let
    newContents = Dict.insert (Object.name object) object place.contents
  in
    Place { place | contents <- newContents }
