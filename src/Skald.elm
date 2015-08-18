module Skald
  ( run

  , Tale
  , tale
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

  , Place
  , place
  , withExit
  , withObject

  , Object
  , object

  , Command
  , say
  , error
  , doNothing
  , describeObject
  , describePlace
  ) where


{-|
@docs run

# Tales

@docs Tale
@docs tale
@docs by, withPreamble, thatBeginsIn, withPlace, withCommand
@docs withPageStyle, withPreambleStyle, withTitleStyle, withByLineStyle,
      withHistoryStyle, withEchoStyle, withErrorStyle, withInputStyle,
      withFieldStyle

# Worlds

@docs World
@docs currentPlace

# Places

@docs Place
@docs place
@docs withExit, withObject

# Objects

@docs Object
@docs object

# Commands

@docs Command
@docs say, error, doNothing, describeObject, describePlace
-}

import Html exposing (Attribute, Html)

import Skald.App
import Skald.Command
import Skald.Object
import Skald.Place
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
withPageStyle : Attribute -> Tale -> Tale
withPageStyle =
  Skald.Tale.withPageStyle


{-| Sets the style attribute for the preamble.
-}
withPreambleStyle : Attribute -> Tale -> Tale
withPreambleStyle =
  Skald.Tale.withPreambleStyle


{-| Sets the style attribute for the default preamble's title.
-}
withTitleStyle : Attribute -> Tale -> Tale
withTitleStyle =
  Skald.Tale.withTitleStyle


{-| Sets the style attribute for the default preamble's by-line.
-}
withByLineStyle : Attribute -> Tale -> Tale
withByLineStyle =
  Skald.Tale.withByLineStyle


{-| Sets the style attribute for the tale's history.
-}
withHistoryStyle : Attribute -> Tale -> Tale
withHistoryStyle  =
  Skald.Tale.withHistoryStyle


{-| Sets the style attribute for echoed input.
-}
withEchoStyle : Attribute -> Tale -> Tale
withEchoStyle =
  Skald.Tale.withEchoStyle


{-| Sets the style attribute for error messages.
-}
withErrorStyle : Attribute -> Tale -> Tale
withErrorStyle =
  Skald.Tale.withErrorStyle


{-| Sets the style attribute for the input area.
-}
withInputStyle : Attribute -> Tale -> Tale
withInputStyle =
  Skald.Tale.withInputStyle


{-| Sets the style attribute for the input field.
-}
withFieldStyle : Attribute -> Tale -> Tale
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


{-|
-}
withCommand : String -> Skald.Command.Handler -> Tale -> Tale
withCommand =
  Skald.Tale.withCommand

-- world -----------------------------------------------------------------------

{-|
-}
type alias World = Skald.World.World

{-| Retrieves the current place from the given world.
-}
currentPlace : World -> Place
currentPlace =
  Skald.World.currentPlace

-- place -----------------------------------------------------------------------

{-|
-}
type alias Place = Skald.Place.Place


{-| Creates a new place with the given name and description
-}
place : String -> String -> Place
place =
  Skald.Place.place


{-|
-}
withExit : String -> String -> Place -> Place
withExit =
  Skald.Place.withExit


{-| Adds the given object to the given place.
-}
withObject : Object -> Place -> Place
withObject =
  Skald.Place.withObject


{-|
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

{-|
-}
type alias Command = Skald.Command.Command

{-|
-}
doNothing : Command
doNothing =
  Skald.Command.doNothing


{-|
-}
say : String -> Command
say =
  Skald.Command.say


{-|
-}
error : String -> Command
error =
  Skald.Command.error


{-|
-}
describePlace : Place -> Command
describePlace =
  Skald.Command.describePlace


{-|
-}
describeObject : Object -> Command
describeObject =
  Skald.Command.describeObject
