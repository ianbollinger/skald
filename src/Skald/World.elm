module Skald.World
  -- TODO: Hide internals.
  ( World
  , getPlace
  , getCurrentPlace
  ) where

import Dict exposing (Dict)

import Skald.Place exposing (Place)


type alias World =
  { currentPlace : String
  , places : Dict String Place
  }


-- Retrieves the place with the given name from the given world.
getPlace : String -> World -> Place
getPlace name world =
  case Dict.get name world.places of
    Just place -> place
    Nothing -> Skald.Place.empty


getCurrentPlace : World -> Place
getCurrentPlace world = getPlace world.currentPlace world
