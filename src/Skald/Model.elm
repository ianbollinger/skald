-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.Model
  ( Model
  , empty
  , appendHistory
  , history
  , inputField
  , setInputField
  , clearInputField
  , world
  , setWorld
  ) where

{-|
-}

import Array as Array exposing (Array)
import Dict as Dict
import Html exposing (Html)

import Skald.Command as Command
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
    , world = Command.emptyWorld
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


{-| Sets the contents of the input field.
-}
setInputField : String -> Model -> Model
setInputField string (Model model) =
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


{-| Sets the world in the given model.
-}
setWorld : World -> Model -> Model
setWorld newWorld (Model model) =
  Model { model | world <- newWorld }
