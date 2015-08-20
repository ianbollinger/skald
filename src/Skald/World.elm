-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.World
  ( World
  , toString
  , CommandHandler
  , CommandMap
  , empty
  , setPlaces
  , updatePlaces
  , place
  , currentPlace
  , setCurrentPlace
  , removeObject
  , addObject
  , commands
  , setCommands
  , updateCommands
  , inventory
  , item
  , updateInventory
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Regex exposing (Regex)

import Skald.Object as Object exposing (Object)
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


toString : World -> String
toString (World world) =
  let
    placesToString =
      -- TODO: commas.
      "Dict.fromList \n        [ "
      ++ Dict.foldr (\x y z -> "(\"" ++ x ++ "\", " ++ Place.toString y ++ ")\n        " ++ z) "" world.places
      ++ "]"
  in
    "    World
      { currentPlace = \"" ++ world.currentPlace ++ "\"
      , places = " ++ placesToString ++ "
      , commands = " ++ "<???>" ++ "
      , inventory = " ++ "<???>" ++ "
      }"

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


{-| See `Skald.elm` for documentation.
-}
place : String -> World -> Place
place name world =
  case Dict.get name (places world) of
    Just place -> place
    Nothing -> Place.empty


{-| See `Skald.elm` for documentation.
-}
currentPlace : World -> Place
currentPlace (World world) =
  place world.currentPlace (World world)


{-| Sets the current place in the given world.
-}
setCurrentPlace : Place -> World -> World
setCurrentPlace place (World world) =
  World
    { world
    | places <- Dict.insert (Place.name place) place (places (World world))
    , currentPlace <- Place.name place
    }

{-|
-}
updateCurrentPlace : (Place -> Place) -> World -> World
updateCurrentPlace f world =
  setCurrentPlace (f (currentPlace world)) world


{-| Removes the object from the current place.
-}
removeObject : Object -> World -> World
removeObject =
    updateCurrentPlace << Place.updateObjects << Dict.remove << Object.name


{-| Adds an object to the current place.
-}
addObject : Object -> World -> World
addObject object =
  let
    update = Place.updateObjects (Dict.insert (Object.name object) object)
  in
    updateCurrentPlace update


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


{-| See `Skald.elm` for documentation.
-}
item : String -> World -> Maybe Object
item name (World world) =
  Dict.get name world.inventory


{-|
-}
updateInventory : (Inventory -> Inventory) -> World -> World
updateInventory f (World world) =
  World { world | inventory <- f world.inventory }
