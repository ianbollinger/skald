-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.App
  ( run
  ) where

{-|
-}

import Html exposing (Html)
import StartApp

import Skald.Action as Action
import Skald.Model as Model exposing (Model)
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
    world = Tale.initialWorld tale
    (description, newWorld) =
      Action.enterPlace (World.currentPlace world) world
  in
    Model.setWorld newWorld model
      |> Model.appendHistory description
