module Skald.World
  ( World
  , CommandHandler
  , CommandMap
  , empty
  , setPlaces
  , updatePlaces
  , getPlace
  , currentPlace
  , setCurrentPlace
  , removeObject
  , commands
  , setCommands
  , updateCommands
  , inventory
  , updateInventory
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Regex exposing (Regex)

import Skald.Object exposing (Object)
import Skald.Place as Place exposing (Place)


{-|
-}
type alias CommandHandler = List String -> World -> (List Html, World)


{-|
-}
type alias CommandMap = List (Regex, CommandHandler)



{-| See `Skald.elm` for documentation.
-}
type World =
  World
    { currentPlace : String
    , places : Dict String Place
    , commands : CommandMap
    , inventory : Inventory
    }


{-|
-}
type alias Inventory = Dict String Object


{-| An empty world.
-}
empty : World
empty =
  World
    { currentPlace = ""
    , places = Dict.empty
    , commands = []
    , inventory = Dict.empty
    }


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


{-|
-}
updatePlaces : (Dict String Place -> Dict String Place) -> World -> World
updatePlaces f (World world) =
  World { world | places <- f world.places }


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
currentPlace (World world) =
  getPlace world.currentPlace (World world)


{-| Sets the current place in the given world.
-}
setCurrentPlace : Place -> World -> World
setCurrentPlace place (World world) =
  let
    newPlaces = Dict.insert world.currentPlace place (places (World world))
  in
    setPlaces newPlaces (World world)


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


{-|
-}
commands : World -> CommandMap
commands (World world) =
  world.commands


{-|
-}
setCommands : CommandMap -> World -> World
setCommands newCommands (World world) =
  World { world | commands <- newCommands }


{-|
-}
updateCommands : (CommandMap -> CommandMap) -> World -> World
updateCommands f (World world) =
  World { world | commands <- f world.commands }


{-|
-}
inventory : World -> Inventory
inventory (World world) =
  world.inventory


{-|
-}
updateInventory : (Inventory -> Inventory) -> World -> World
updateInventory f (World world) =
  World { world | inventory <- f world.inventory }
