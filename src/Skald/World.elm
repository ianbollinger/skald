module Skald.World
  ( World
  , currentPlaceName
  , updateCurrentPlaceName
  , updatePlaces
  , getPlace
  , currentPlace
  , removeObject
  , empty
  ) where

import Dict exposing (Dict)

import Skald.Place exposing (Place)


{-| See `Skald.elm` for documentation.
-}
type World = World
  { currentPlace : String
  , places : Dict String Place
  }


{-| An empty world.
-}
empty : World
empty =
  World
    { currentPlace = ""
    , places = Dict.empty
    }


{-| The current place for the given world.
-}
currentPlaceName : World -> String
currentPlaceName (World world) =
  world.currentPlace


{-| Update the current place (by name) for the given world.
-}
updateCurrentPlaceName : String -> World -> World
updateCurrentPlaceName placeName (World world) =
  World { world | currentPlace <- placeName }


{-| The places contained in the given world.
-}
places : World -> Dict String Place
places (World world) =
  world.places


{-| Update the places contained in the given world.
-}
updatePlaces : Dict String Place -> World -> World
updatePlaces places (World world) =
  World { world | places <- places }


-- TODO: "get" prefix seems redundant.

{-| Retrieves the place with the given name from the given world.
-}
getPlace : String -> World -> Place
getPlace name world =
  case Dict.get name (places world) of
    Just place -> place
    Nothing -> Skald.Place.empty


{-| Retrieves the current place from the given world.
-}
currentPlace : World -> Place
currentPlace world =
  getPlace (currentPlaceName world) world


{-| Removes an object with the given name from the current place.
-}
removeObject : String -> World -> World
removeObject name world =
  let
    currentPlace' = currentPlace world
    newPlace =
      { currentPlace' | contents <- Dict.remove name currentPlace'.contents }
  in
    updateCurrentPlace newPlace world


{-| Updates the current place in the given world.
-}
updateCurrentPlace : Place -> World -> World
updateCurrentPlace place world =
  let
    newPlaces = Dict.insert (currentPlaceName world) place (places world)
  in
    updatePlaces newPlaces world
