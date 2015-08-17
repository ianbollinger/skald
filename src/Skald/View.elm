module Skald.View
  ( view
  ) where


import Array exposing (Array)
import Html exposing (Html, Attribute, text, toElement, input)
import Html.Attributes exposing (autofocus, style, value)
import Html.Events exposing (on, keyCode, targetValue)
import Json.Decode as Json
import Keyboard.Keys as Keys
import Signal exposing (Address)

import Native.Skald
import Skald.Action exposing (Action (..))
import Skald.Model exposing (Model)
import Skald.Tale exposing (Tale (Tale))


view : Tale -> Address Action -> Model -> Html
view (Tale tale) address model =
  -- TODO: this needs to be moved to where it will work 100% of the time.
  Native.Skald.scrollToBottom <|
    Html.article [ tale.pageStyle ]
      [ tale.preamble (Tale tale)
      , history (Tale tale) model.entries
      , inputField (Tale tale) address model.field
      ]


history : Tale -> Array Html -> Html
history (Tale tale) entries =
  -- TODO: having to convert back to a list seems to negate the benefit of
  -- using an array.
  Html.div [ tale.historyStyle ] (Array.toList entries)


inputField : Tale -> Address Action -> String -> Html
inputField (Tale tale) address string =
  Html.div [ tale.inputStyle ]
    [ input
      [ autofocus True
      , value string
      , on "input" targetValue (Signal.message address << UpdateField)
      , onEnter address SubmitField
      , tale.fieldStyle
      ]
      []
    ]


onEnter : Address a -> a -> Attribute
onEnter address value =
  on "keydown"
    (Json.customDecoder keyCode isEnter)
    (\_ -> Signal.message address value)


isEnter : Int -> Result String ()
isEnter code =
  if code == .keyCode Keys.enter
    then Ok ()
    else Err "Incorrect key code."
