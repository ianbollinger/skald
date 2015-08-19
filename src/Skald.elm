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
  , currentPlace
  , item

  , Place
  , place
  , withExit
  , withObject

  , Object
  , object

  , Command
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
@docs currentPlace
@docs item

# Places

@docs Place
@docs place
@docs withExit, withObject

# Objects

@docs Object
@docs object

# Commands

@docs Command
@docs andThen, say, error, doNothing, describeObject, describePlace,
      removeFromInventory, createObject

-}

import Html exposing (Html)

import Skald.App
import Skald.Command
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
withCommand : String -> Skald.Command.Handler -> Tale -> Tale
withCommand =
  Skald.Tale.withCommand

-- world -----------------------------------------------------------------------

{-|
-}
type alias World = Skald.World.World


{-| The current place of the player in the given world.
-}
currentPlace : World -> Place
currentPlace =
  Skald.World.currentPlace


{-| The item with the given name from the player's inventory, if it exists.
-}
item : String -> World -> Maybe Object
item =
  Skald.World.item

-- place -----------------------------------------------------------------------

{-|
-}
type alias Place = Skald.Place.Place


{-| Creates a new place with the given name and description
-}
place : String -> String -> Place
place =
  Skald.Place.place


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
exitName : String -> Place -> Maybe String
exitName =
  Skald.Place.exitName

-- object ----------------------------------------------------------------------

{-|
-}
type alias Object = Skald.Object.Object


{-| Creates a new object with the given name and description.
-}
object : String -> String -> Object
object =
  Skald.Object.object

-- command ---------------------------------------------------------------------

-- TODO: this name is confusing. Name it Action or Reaction?
{-|
-}
type alias Command = Skald.Command.Command


{-| Sequences two commands.
-}
andThen : (List Html, World) -> Command -> (List Html, World)
andThen =
  Skald.Command.andThen


{-| A command that does nothing.
-}
doNothing : Command
doNothing =
  Skald.Command.doNothing


{-| Writes a Markdown-styled string to the history.
-}
say : String -> Command
say =
  Skald.Command.say


{-| Writes a Markdown-styled string to the history using the error style.
-}
error : String -> Command
error =
  Skald.Command.error


{-| Writes the place's title, description, exits, and contents to the history.
-}
describePlace : Place -> Command
describePlace =
  Skald.Command.describePlace


{-| Writes the object's description to the history.
-}
describeObject : Object -> Command
describeObject =
  Skald.Command.describeObject


{-| Removes an object from the player's inventory.
-}
removeFromInventory : Object -> Command
removeFromInventory =
  Skald.Command.removeFromInventory


{-| Inserts an object into the current place.
-}
createObject : Object -> Command
createObject =
  Skald.Command.createObject
