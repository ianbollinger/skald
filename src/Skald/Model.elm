module Skald.Model
  ( Model
  , empty
  , appendHistory
  , history
  , inputField
  , updateInputField
  , clearInputField
  , world
  , updateWorld
  ) where

import Array as Array exposing (Array)
import Dict as Dict
import Html exposing (Html)

import Skald.World as World exposing (World)


{-| Contains the entirety of a Skald application's state.
-}
type Model =
  Model
    { history : Array Html
    , field : String
    , world : World
    }


{-| An empty model.
-}
empty : Model
empty =
  Model
    { history = Array.empty
    , field = ""
    , world = World.empty
    }


{-| The given model's history.
-}
history : Model -> Array Html
history (Model model) =
  model.history


{-| Appends the given entries to the model's history.
-}
appendHistory : List Html -> Model -> Model
appendHistory entries (Model model) =
  let
    newEntries = model.history `Array.append` Array.fromList entries
  in
    Model { model | history <- newEntries }


{-| The contents of the input field.
-}
inputField : Model -> String
inputField (Model model) =
  model.field


{-| Updates the contents of the input field.
-}
updateInputField : String -> Model -> Model
updateInputField string (Model model) =
  Model { model | field <- string }


{-| Clears the input field.
-}
clearInputField : Model -> Model
clearInputField (Model model) =
  Model { model | field <- "" }


{-| The world contained in the given model.
-}
world : Model -> World
world (Model model) =
  model.world


{-| Updates the world in the given model.
-}
updateWorld : World -> Model -> Model
updateWorld newWorld (Model model) =
  Model { model | world <- newWorld }
