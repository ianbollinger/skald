module Skald.App
  ( run
  ) where

{-|
-}

import Html exposing (Html)
import StartApp

import Skald.Command as Command
import Skald.Model as Model exposing (Model)
import Skald.Place as Place
import Skald.Tale as Tale exposing (Tale)
import Skald.Update exposing (update)
import Skald.View exposing (view)
import Skald.World as World


{-| See `Skald.elm` for documentation.
-}
run : Tale -> Signal Html
run tale =
  StartApp.start
    { model = startUp tale Model.empty
    , view = view tale
    , update = update tale
    }


{-|
-}
startUp : Tale -> Model -> Model
startUp tale model =
  let
    newModel = Model.setWorld (Tale.initialWorld tale) model
    world = Model.world newModel
    (description, newWorld) =
      Command.enterPlace (World.currentPlace world) world
  in
    Model.setWorld newWorld newModel
      |> Model.appendHistory description
