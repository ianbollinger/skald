-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald
  ( run

  , Tale
  , tale

  , title
  , author
  , initialWorld
  , preamble
  , pageStyle
  , preambleStyle
  , titleStyle
  , byLineStyle
  , historyStyle
  , echoStyle
  , errorStyle
  , inputStyle
  , fieldStyle

  , by
  , withPreamble
  , withPageStyle
  , withPreambleStyle
  , withTitleStyle
  , withByLineStyle
  , withHistoryStyle
  , withEchoStyle
  , withErrorStyle
  , withInputStyle
  , withFieldStyle
  , thatBeginsIn
  , withPlace
  , withCommand

  , World
  , getCurrentPlace
  , getItem
  , getPlace

  , Place
  , place
  , withDescription
  , whenDescribing
  , withExit
  , withObject
  , getExitName
  , getObject
  , isVisited

  , Object
  , object

  , Action
  , andThen
  , say
  , error
  , doNothing
  , describeObject
  , describePlace
  , removeFromInventory
  , createObject
  ) where


{-|
@docs run

# Tales

@docs Tale
@docs tale
@docs title, author, initialWorld, preamble
@docs by, withPreamble, thatBeginsIn, withPlace, withCommand

## Tale styles

@docs pageStyle, preambleStyle, titleStyle, byLineStyle, historyStyle,
      echoStyle, errorStyle, inputStyle, fieldStyle

@docs withPageStyle, withPreambleStyle, withTitleStyle, withByLineStyle,
      withHistoryStyle, withEchoStyle, withErrorStyle, withInputStyle,
      withFieldStyle

# Worlds

@docs World
@docs getCurrentPlace, getPlace, getItem

# Places
@docs Place, place

## Descriptions
@docs withDescription, whenDescribing

## Exits
@docs withExit, getExitName

## Child objects
@docs withObject, getObject

## Miscellaneous
@docs isVisited

# Objects

@docs Object
@docs object

# Commands

@docs Action
@docs andThen, say, error, doNothing, describeObject, describePlace,
      removeFromInventory, createObject

-}

import Html exposing (Html)

import Skald.Action
import Skald.App
import Skald.Object
import Skald.Place
import Skald.Style exposing (Styles)
import Skald.Tale
import Skald.World

-- main ------------------------------------------------------------------------

{-|
-}
run : Tale -> Signal Html
run =
  Skald.App.run


-- tale ------------------------------------------------------------------------

{-|
-}
type alias Tale = Skald.Tale.Tale


{-| Creates an empty tale with the given title.
-}
tale : String -> Tale
tale =
  Skald.Tale.tale


{-| The title of the given tale.
-}
title : Tale -> String
title =
   Skald.Tale.title


{-| The author name of the given tale.
-}
author : Tale -> String
author =
   Skald.Tale.author


{-| The style attribute for the preamble.
-}
initialWorld : Tale -> World
initialWorld =
   Skald.Tale.initialWorld


{-| The function to be called when the tale begins.

The default behavior is to display the tale title and author by-line.
-}
preamble : Tale -> (Tale -> Html)
preamble =
   Skald.Tale.preamble


{-| The style attribute for the entire page.
-}
pageStyle : Tale -> Styles
pageStyle =
   Skald.Tale.pageStyle


{-|
-}
preambleStyle : Tale -> Styles
preambleStyle =
   Skald.Tale.preambleStyle


{-| The style attribute for the default preamble's title.
-}
titleStyle : Tale -> Styles
titleStyle =
   Skald.Tale.titleStyle


{-| The style attribute for the default preamble's by-line.
-}
byLineStyle : Tale -> Styles
byLineStyle =
   Skald.Tale.byLineStyle


{-| The style attribute for the tale's history.
-}
historyStyle : Tale -> Styles
historyStyle =
   Skald.Tale.historyStyle


{-| The style attribute for echoed input.
-}
echoStyle : Tale -> Styles
echoStyle =
   Skald.Tale.echoStyle


{-| The style attribute for error messages.
-}
errorStyle : Tale -> Styles
errorStyle =
   Skald.Tale.errorStyle


{-| The style attribute for the input area.
-}
inputStyle : Tale -> Styles
inputStyle =
   Skald.Tale.inputStyle


{-| The style attribute for the input field.
-}
fieldStyle : Tale -> Styles
fieldStyle =
   Skald.Tale.fieldStyle


{-| Sets the author's name for the given tale.

The author's name is displayed by default in the tale's by-line.
-}
by : String -> Tale -> Tale
by =
  Skald.Tale.by


{-| Sets the function to be called when the tale begins.

The default behavior is to display the tale title and author by-line.
-}
withPreamble : (Skald.Tale.Tale -> Html) -> Tale -> Tale
withPreamble =
  Skald.Tale.withPreamble


{-| Sets the style attribute for the page.
-}
withPageStyle : Styles -> Tale -> Tale
withPageStyle =
  Skald.Tale.withPageStyle


{-| Sets the style attribute for the preamble.
-}
withPreambleStyle : Styles -> Tale -> Tale
withPreambleStyle =
  Skald.Tale.withPreambleStyle


{-| Sets the style attribute for the default preamble's title.
-}
withTitleStyle : Styles -> Tale -> Tale
withTitleStyle =
  Skald.Tale.withTitleStyle


{-| Sets the style attribute for the default preamble's by-line.
-}
withByLineStyle : Styles -> Tale -> Tale
withByLineStyle =
  Skald.Tale.withByLineStyle


{-| Sets the style attribute for the tale's history.
-}
withHistoryStyle : Styles -> Tale -> Tale
withHistoryStyle  =
  Skald.Tale.withHistoryStyle


{-| Sets the style attribute for echoed input.
-}
withEchoStyle : Styles -> Tale -> Tale
withEchoStyle =
  Skald.Tale.withEchoStyle


{-| Sets the style attribute for error messages.
-}
withErrorStyle : Styles -> Tale -> Tale
withErrorStyle =
  Skald.Tale.withErrorStyle


{-| Sets the style attribute for the input area.
-}
withInputStyle : Styles -> Tale -> Tale
withInputStyle =
  Skald.Tale.withInputStyle


{-| Sets the style attribute for the input field.
-}
withFieldStyle : Styles -> Tale -> Tale
withFieldStyle =
  Skald.Tale.withFieldStyle


{-| Sets the place where the tale begins.
-}
thatBeginsIn : Place -> Tale -> Tale
thatBeginsIn =
  Skald.Tale.thatBeginsIn


{-| Adds the given place to the tale.
-}
withPlace : Place -> Tale -> Tale
withPlace =
  Skald.Tale.withPlace


{-| `withCommand pattern handler tale`
-}
withCommand : String -> Skald.Action.Handler -> Tale -> Tale
withCommand =
  Skald.Tale.withCommand


{-|
-}
isVisited : Place -> Bool
isVisited =
  Skald.Place.visited

-- world -----------------------------------------------------------------------

{-|
-}
type alias World = Skald.World.World


{-| The current place of the player in the given world.
-}
getCurrentPlace : World -> Place
getCurrentPlace =
  Skald.World.currentPlace

{-| Retrieves the place with the given name from the given world.
-}
getPlace : String -> World -> Place
getPlace =
  Skald.World.place


{-| The item with the given name from the player's inventory, if it exists.
-}
getItem : String -> World -> Maybe Object
getItem =
  Skald.World.item

-- place -----------------------------------------------------------------------

{-|
-}
type alias Place = Skald.Place.Place


{-| Creates a new place with the given name.
-}
place : String -> Place
place =
  Skald.Place.place


{-|
-}
withDescription : String -> Place -> Place
withDescription =
  Skald.Place.withDescription


{-|
-}
whenDescribing : (Place -> String) -> Place -> Place
whenDescribing =
  Skald.Place.whenDescribing


{-| `withExit direction exitName place`
-}
withExit : String -> String -> Place -> Place
withExit =
  Skald.Place.withExit


{-| Adds the given object to the given place.
-}
withObject : Object -> Place -> Place
withObject =
  Skald.Place.withObject


{-| `exitName direction place`
-}
getExitName : String -> Place -> Maybe String
getExitName =
  Skald.Place.exitName


{-|
-}
getObject : String -> Place -> Maybe Object
getObject =
  Skald.Place.object

-- object ----------------------------------------------------------------------

{-|
-}
type alias Object = Skald.Object.Object


{-| Creates a new object with the given name and description.
-}
object : String -> String -> Object
object =
  Skald.Object.object

-- action ----------------------------------------------------------------------

{-|
-}
type alias Action = Skald.Action.Action


{-| Sequences two actions.
-}
andThen : (List Html, World) -> Action -> (List Html, World)
andThen =
  Skald.Action.andThen


{-| A command that does nothing.
-}
doNothing : Action
doNothing =
  Skald.Action.doNothing


{-| Writes a Markdown-styled string to the history.
-}
say : String -> Action
say =
  Skald.Action.say


{-| Writes a Markdown-styled string to the history using the error style.
-}
error : String -> Action
error =
  Skald.Action.error


{-| Writes the place's title, description, exits, and contents to the history.
-}
describePlace : Place -> Action
describePlace =
  Skald.Action.describePlace


{-| Writes the object's description to the history.
-}
describeObject : Object -> Action
describeObject =
  Skald.Action.describeObject


{-| Removes an object from the player's inventory.
-}
removeFromInventory : Object -> Action
removeFromInventory =
  Skald.Action.removeFromInventory


{-| Inserts an object into the current place.
-}
createObject : Object -> Action
createObject =
  Skald.Action.createObject
