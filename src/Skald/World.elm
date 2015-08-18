module Skald.World
  ( World
  , currentPlaceName
  , setCurrentPlaceName
  , setPlaces
  , getPlace
  , currentPlace
  , removeObject
  , empty
  ) where

{-|
-}

import Dict exposing (Dict)

import Skald.Place as Place exposing (Place)


{-| See `Skald.elm` for documentation.
-}
type World =
  World
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


{-| Set the current place (by name) for the given world.
-}
setCurrentPlaceName : String -> World -> World
setCurrentPlaceName placeName (World world) =
  World { world | currentPlace <- placeName }


{-| The places contained in the given world.
-}
places : World -> Dict String Place
places (World world) =
  world.places


{-| Sets the places contained in the given world.
-}
setPlaces : Dict String Place -> World -> World
setPlaces places (World world) =
  World { world | places <- places }


-- TODO: "get" prefix seems redundant.

{-| Retrieves the place with the given name from the given world.
-}
getPlace : String -> World -> Place
getPlace name world =
  case Dict.get name (places world) of
    Just place -> place
    Nothing -> Place.empty


{-| Retrieves the current place from the given world.
-}
currentPlace : World -> Place
currentPlace world =
  getPlace (currentPlaceName world) world


{-| Sets the current place in the given world.
-}
setCurrentPlace : Place -> World -> World
setCurrentPlace place world =
  let
    newPlaces = Dict.insert (currentPlaceName world) place (places world)
  in
    setPlaces newPlaces world


{-|
-}
updateCurrentPlace : (Place -> Place) -> World -> World
updateCurrentPlace f world =
  setCurrentPlace (f (currentPlace world)) world


{-| Removes an object with the given name from the current place.
-}
removeObject : String -> World -> World
removeObject name world =
  updateCurrentPlace (Place.updateContents (Dict.remove name)) world
