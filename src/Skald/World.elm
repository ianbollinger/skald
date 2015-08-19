module Skald.World
  ( World
  , toString
  , CommandHandler
  , CommandMap
  , empty
  , setPlaces
  , updatePlaces
  , getPlace
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
removeObject object world =
  let
    update = Place.updateContents (Dict.remove (Object.name object))
  in
    updateCurrentPlace update world


{-| Adds an object to the current place.
-}
addObject : Object -> World -> World
addObject object world =
  let
    update = Place.updateContents (Dict.insert (Object.name object) object)
  in
    updateCurrentPlace update world


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
