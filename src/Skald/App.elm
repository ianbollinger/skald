module Skald.App
  ( run
  ) where

import Html exposing (Html)
import StartApp

import Skald.Tale exposing (Tale (Tale))
import Skald.Model as Model exposing (Model)
import Skald.Place as Place
import Skald.Update exposing (update, enterPlace)
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
startUp (Tale tale) model =
  let
    newModel = copyTaleIntoModel (Tale tale) model
    (description, newWorld) =
      enterPlace (Place.name tale.initialPlace) (Model.world newModel)
  in
    Model.updateWorld newWorld newModel
      |> Model.appendHistory description


{-|
-}
copyTaleIntoModel : Tale -> Model -> Model
copyTaleIntoModel (Tale tale) model =
  Model.updateWorld (World.updatePlaces tale.places (Model.world model)) model
