-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.View
  ( view
  ) where

{-|
-}

import Array exposing (Array)
import Html exposing (Html, Attribute, text, toElement, input)
import Html.Attributes exposing (autofocus, style, value)
import Html.Events exposing (on, keyCode, targetValue)
import Json.Decode as Json
import Keyboard.Keys as Keys
import Signal exposing (Address)

import Native.Skald
import Skald.AppAction exposing (AppAction (..))
import Skald.Model as Model exposing (Model)
import Skald.Tale as Tale exposing (Tale)


view : Tale -> Address AppAction -> Model -> Html
view tale address model =
  -- TODO: this needs to be moved to where it will work 100% of the time.
  Native.Skald.scrollToBottom <|
    Html.article [ style (Tale.pageStyle tale) ]
      [ Tale.preamble tale tale
      , history tale (Model.history model)
      , inputField tale address (Model.inputField model)
      ]


history : Tale -> Array Html -> Html
history tale entries =
  -- TODO: having to convert back to a list seems to negate the benefit of
  -- using an array.
  Html.div [ style (Tale.historyStyle tale) ] (Array.toList entries)


inputField : Tale -> Address AppAction -> String -> Html
inputField tale address string =
  Html.div [ style (Tale.inputStyle tale) ]
    [ input
      [ autofocus True
      , value string
      , on "input" targetValue (Signal.message address << UpdateField)
      , onEnter address SubmitField
      , style (Tale.fieldStyle tale)
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
