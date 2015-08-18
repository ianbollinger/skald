module Skald.World
  ( World
  , getPlace
  , getCurrentPlace
  , removeObject
  ) where

import Dict exposing (Dict)

import Skald.Place exposing (Place)


type World = World
  { currentPlace : String
  , places : Dict String Place
  }


{-| The current place for the given world.
-}
currentPlaceName : World -> String
currentPlaceName (World world) =
  world.currentPlace


{-| The places contained in the given world.
-}
places : World -> Dict String Place
places (World world) =
  world.places


updatePlaces : World -> Dict String Place -> World
updatePlaces (World world) places =
  World { world | places <- places }

-- TODO: "get" prefix seems redundant.

{-| Retrieves the place with the given name from the given world.
-}
getPlace : String -> World -> Place
getPlace name world =
  case Dict.get name world.places of
    Just place -> place
    Nothing -> Skald.Place.empty


{-| Retrieves the current place from the given world.
-}
getCurrentPlace : World -> Place
getCurrentPlace world =
  getPlace (currentPlaceName world) world


{-| Removes an object with the given name from the current place.
-}
removeObject : String -> World -> World
removeObject name world =
  let
    currentPlace = getCurrentPlace world
    newPlace =
      { currentPlace | contents <- Dict.remove name currentPlace.contents }
  in
    updatePlaces (Dict.insert (currentPlaceName world) newPlace (places world)) world
