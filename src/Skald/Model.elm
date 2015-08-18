module Skald.Model
  -- TODO: hide internals.
  ( Model
  , empty
  , appendHistory
  ) where

import Array as Array exposing (Array)
import Dict as Dict
import Html exposing (Html)

import Skald.World as World exposing (World)


type alias Model =
  { entries : Array Html
  , field : String
  , world : World
  }


empty : Model
empty =
  { entries = Array.empty
  , field = ""
  , world = World.empty
  }


appendHistory : List Html -> Model -> Model
appendHistory entries model =
  { model | entries <- model.entries `Array.append` Array.fromList entries }
