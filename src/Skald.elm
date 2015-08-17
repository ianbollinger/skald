module Skald
  ( run
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
  , place
  , withExit
  , withObject
  , object
  ) where


{-|
@docs run

@docs tale
@docs by, withPreamble, thatBeginsIn, withPlace
@docs withPageStyle, withPreambleStyle, withTitleStyle, withByLineStyle,
      withHistoryStyle, withEchoStyle, withErrorStyle, withInputStyle,
      withFieldStyle

@docs place
@docs withExit, withObject

@docs object
-}

import Html exposing (Attribute, Html)

import Skald.App
import Skald.Object
import Skald.Place
import Skald.Tale
import Skald.World

-- TODO: allow markdown for everything.
-- TODO: we need to automatically scroll.
-- TODO: support for hyperlinks.
-- TODO: make exits first-class objects.
-- TODO: handle missing Dict keys sensibly.
-- TODO: being in the input field breaks scrolling.

-- main ------------------------------------------------------------------------

{-|
-}
run : Tale -> Signal Html
run =
  Skald.App.run


-- tale ------------------------------------------------------------------------

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


{-|
-}
withHistoryStyle : Attribute -> Tale -> Tale
withHistoryStyle  =
  Skald.Tale.withHistoryStyle


{-|
-}
withEchoStyle : Attribute -> Tale -> Tale
withEchoStyle =
  Skald.Tale.withEchoStyle


{-|
-}
withErrorStyle : Attribute -> Tale -> Tale
withErrorStyle =
  Skald.Tale.withErrorStyle


{-|
-}
withInputStyle : Attribute -> Tale -> Tale
withInputStyle =
  Skald.Tale.withInputStyle


{-|
-}
withFieldStyle : Attribute -> Tale -> Tale
withFieldStyle =
  Skald.Tale.withFieldStyle


{-|
-}
thatBeginsIn : Place -> Tale -> Tale
thatBeginsIn =
  Skald.Tale.thatBeginsIn


{-|
-}
withPlace : Place -> Tale -> Tale
withPlace =
  Skald.Tale.withPlace

-- world -----------------------------------------------------------------------

{-|
-}
type alias World = Skald.World.World

-- place -----------------------------------------------------------------------

{-|
-}
type alias Place = Skald.Place.Place


{-|
-}
place : String -> String -> Place
place =
  Skald.Place.place


{-|
-}
withExit : String -> String -> Place -> Place
withExit =
  Skald.Place.withExit


{-|
-}
withObject : Object -> Place -> Place
withObject =
  Skald.Place.withObject


-- object ----------------------------------------------------------------------

type alias Object = Skald.Object.Object


{-| Creates a new object with the given name and description.
-}
object : String -> String -> Object
object =
  Skald.Object.object
