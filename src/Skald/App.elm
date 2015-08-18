module Skald.App
  ( run
  ) where


import Html exposing (Html)
import StartApp

import Skald.Tale exposing (Tale (Tale))
import Skald.Model as Model exposing (Model, appendHistory)
import Skald.Update exposing (update, enterPlace)
import Skald.View exposing (view)
import Skald.World as World


run : Tale -> Signal Html
run tale =
  StartApp.start
    { model = startUp tale Model.empty
    , view = view tale
    , update = update tale
    }


startUp : Tale -> Model -> Model
startUp (Tale tale) model =
  let
    newModel = copyTaleIntoModel (Tale tale) model
    (description, newWorld) = enterPlace tale.initialPlace.name newModel.world
  in
    appendHistory description { newModel | world <- newWorld }


copyTaleIntoModel : Tale -> Model -> Model
copyTaleIntoModel (Tale tale) model =
  let
    oldWorld = model.world
  in
    { model
    | world <- World.updatePlaces tale.places oldWorld
    }
