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
  , visited
  , setVisited
  , objects
  , object
  , updateObjects
  , empty
  , withDescription
  , whenDescribing
  , withExit
  , containing
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
    , description : Place -> String
    , exits : Exits
    , objects : Objects
    , visited : Bool
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
            , description = \"" ++ description (Place place) ++ "\"
            , exits = " ++ exitsToString ++ "
            , objects = " ++ objectsToString ++ "
            }"


{-| See `Skald.elm` for documentation.
-}
place : String -> Place
place name =
  Place
    { name = name
    , description = always ""
    , exits = Dict.empty
    , objects = Dict.empty
    , visited = False
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
  place.description (Place place)


{-|
-}
objects : Place -> Objects
objects (Place place) =
  place.objects


{-|
-}
object : String -> Place -> Maybe Object
object name (Place place) =
  Dict.get name place.objects


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


{-| See `Skald.elm` for documentation.
-}
visited : Place -> Bool
visited (Place place) =
  place.visited


{-|
-}
setVisited : Bool -> Place -> Place
setVisited visited (Place place) =
  Place { place | visited <- visited }


{-|
-}
updateObjects : (Objects -> Objects) -> Place -> Place
updateObjects f (Place place) =
  Place { place | objects <- f place.objects }


{-| An empty place.
-}
empty : Place
empty =
  -- TODO: make this impossible!
  place "An error has occurred"


{-| See `Skald.elm` for documentation.
-}
withDescription : String -> Place -> Place
withDescription description (Place place) =
  Place { place | description <- always description }


{-| See `Skald.elm` for documentation.
-}
whenDescribing : (Place -> String) -> Place -> Place
whenDescribing describer (Place place) =
  Place { place | description <- describer }


{-| See `Skald.elm` for documentation.
-}
withExit : String -> String -> Place -> Place
withExit exit to (Place from) =
  Place { from | exits <- Dict.insert exit to from.exits }


{-| See `Skald.elm` for documentation.
-}
containing : List Object -> Place -> Place
containing objects =
  let
    update x =
      List.foldr (\object -> Dict.insert (Object.name object) object) x objects
  in
    updateObjects update
