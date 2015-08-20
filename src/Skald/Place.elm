-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.Place
  ( Place
  , toString
  , place
  , name
  , description
  , exits
  , exitName
  , objects
  , updateObjects
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
    , exits : Exits
    , objects : Objects
    }


{-|
-}
type alias Exits = Dict String String


{-|
-}
type alias Objects = Dict String Object


{-|
-}
toString : Place -> String
toString (Place place) =
  let
    exitsToString =
      "Dict.fromList \n              [ "
      ++ Dict.foldr (\x y z -> "(\"" ++ x ++ "\", \"" ++ y ++ "\")\n              " ++ z) "" place.exits
      ++ "]"
    objectsToString =
      "Dict.fromList \n              [ "
      ++ Dict.foldr (\x y z -> "(\"" ++ x ++ "\", \"" ++ (Object.name y) ++ "\")\n              " ++ z) "" place.objects
      ++ "]"
  in
    "Place
            { name = \"" ++ place.name ++ "\"
            , description = \"" ++ place.description ++ "\"
            , exits = " ++ exitsToString ++ "
            , objects = " ++ objectsToString ++ "
            }"


{-| See `Skald.elm` for documentation.
-}
place : String -> String -> Place
place name description =
  Place
    { name = name
    , description = description
    , exits = Dict.empty
    , objects = Dict.empty
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
objects : Place -> Objects
objects (Place place) =
  place.objects


{-|
-}
exits : Place -> Exits
exits (Place place) =
  place.exits


{-| See `Skald.elm` for documentation.
-}
exitName : String -> Place -> Maybe String
exitName exit (Place place) =
  Dict.get exit place.exits


{-|
-}
updateObjects : (Objects -> Objects) -> Place -> Place
updateObjects f (Place place) =
  Place { place | objects <- f place.objects }


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
withObject object =
  updateObjects (Dict.insert (Object.name object) object)
