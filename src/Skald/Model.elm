module Skald.Model
  -- TODO: hide internals.
  ( Model
  , empty
  , appendHistory
  , clearInputField
  , updateWorld
  ) where

import Array as Array exposing (Array)
import Dict as Dict
import Html exposing (Html)

import Skald.World as World exposing (World)


{-|
-}
type alias Model =
  { entries : Array Html
  , field : String
  , world : World
  }


{-|
-}
empty : Model
empty =
  { entries = Array.empty
  , field = ""
  , world = World.empty
  }


{-|
-}
appendHistory : List Html -> Model -> Model
appendHistory entries model =
  { model | entries <- model.entries `Array.append` Array.fromList entries }


{-| Clears the input field.
-}
clearInputField : Model -> Model
clearInputField model =
  { model | field <- "" }


{-| Updates the world in the tale's model.
-}
updateWorld : World -> Model -> Model
updateWorld newWorld model =
  { model | world <- newWorld }
