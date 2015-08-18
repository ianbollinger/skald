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
    newModel = copyTaleIntoModel tale model
    place = Place.name (Tale.initialPlace tale)
    (description, newWorld) = Command.enterPlace place (Model.world newModel)
  in
    Model.setWorld newWorld newModel
      |> Model.appendHistory description


{-|
-}
copyTaleIntoModel : Tale -> Model -> Model
copyTaleIntoModel tale model =
  let
    newPlaces = World.setPlaces (Tale.places tale) (Model.world model)
  in
    Model.setWorld newPlaces model
