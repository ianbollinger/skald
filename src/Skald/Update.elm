module Skald.Update
  ( update
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import String

import Skald.Action exposing (Action (..))
import Skald.Command as Command
import Skald.Model as Model exposing (Model)
import Skald.Object as Object
import Skald.Place as Place exposing (Place)
import Skald.Style as Style
import Skald.Tale as Tale exposing (Tale)
import Skald.World as World exposing (World)

-- update ----------------------------------------------------------------------

update :  Tale -> Action -> Model -> Model
update tale action model =
  case action of
    NoOp ->
      model

    UpdateField string ->
      Model.setInputField string model

    SubmitField ->
      if String.isEmpty (Model.inputField model)
        then model
        else submitField tale model


{-| Submits the contents of the input field to the command parser and the
clears the field.
-}
submitField : Tale -> Model -> Model
submitField tale model =
  let
    (commandResult, newWorld) =
      Command.parse (Model.inputField model) (Model.world model)
  in
    model
      |> Model.appendHistory (echo tale model :: commandResult)
      |> Model.clearInputField
      |> Model.setWorld newWorld


{-| Copies the contents of the input field to the tale's history.
-}
echo : Tale -> Model -> Html
echo tale model =
  Html.p [ Tale.echoStyle tale ] [ Html.text (Model.inputField model) ]
