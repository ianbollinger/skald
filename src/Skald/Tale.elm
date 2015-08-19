-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.Tale
  ( Tale
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
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Regex exposing (regex)

import Skald.Command as Command exposing (emptyWorld)
import Skald.Place as Place exposing (Place)
import Skald.Style as Style exposing (Styles)
import Skald.World as World exposing (World, CommandHandler, CommandMap)


{-| See `Skald.elm` for documentation.
-}
type Tale =
  Tale
    { title : String
    , author : String
    , initialWorld : World
    , preamble : Tale -> Html
    , pageStyle : Styles
    , preambleStyle : Styles
    , titleStyle : Styles
    , byLineStyle : Styles
    , historyStyle : Styles
    , echoStyle : Styles
    , errorStyle : Styles
    , inputStyle : Styles
    , fieldStyle : Styles
    }


{-| See `Skald.elm` for documentation.
-}
tale : String -> Tale
tale title =
  Tale
    { title = title
    , author = ""
    , initialWorld = emptyWorld
    , preamble = defaultPreamble
    , pageStyle = Style.pageDefault
    , preambleStyle = Style.preambleDefault
    , titleStyle = Style.titleDefault
    , byLineStyle = Style.byLineDefault
    , historyStyle = Style.historyDefault
    , echoStyle = Style.echoDefault
    , errorStyle = Style.errorDefault
    , inputStyle = Style.inputDefault
    , fieldStyle = Style.fieldDefault
    }


{-| See `Skald.elm` for documentation.
-}
title : Tale -> String
title (Tale tale) =
   tale.title


{-| See `Skald.elm` for documentation.
-}
author : Tale -> String
author (Tale tale) =
   tale.author


{-| See `Skald.elm` for documentation.
-}
initialWorld : Tale -> World
initialWorld (Tale tale) =
   tale.initialWorld


{-| See `Skald.elm` for documentation.
-}
preamble : Tale -> (Tale -> Html)
preamble (Tale tale) =
   tale.preamble


{-| See `Skald.elm` for documentation.
-}
pageStyle : Tale -> Styles
pageStyle (Tale tale) =
   tale.pageStyle


{-| See `Skald.elm` for documentation.
-}
preambleStyle : Tale -> Styles
preambleStyle (Tale tale) =
   tale.preambleStyle


{-| See `Skald.elm` for documentation.
-}
titleStyle : Tale -> Styles
titleStyle (Tale tale) =
   tale.titleStyle


{-| See `Skald.elm` for documentation.
-}
byLineStyle : Tale -> Styles
byLineStyle (Tale tale) =
   tale.byLineStyle


{-| See `Skald.elm` for documentation.
-}
historyStyle : Tale -> Styles
historyStyle (Tale tale) =
   tale.historyStyle


{-| See `Skald.elm` for documentation.
-}
echoStyle : Tale -> Styles
echoStyle (Tale tale) =
   tale.echoStyle


{-| See `Skald.elm` for documentation.
-}
errorStyle : Tale -> Styles
errorStyle (Tale tale) =
   tale.errorStyle


{-| See `Skald.elm` for documentation.
-}
inputStyle : Tale -> Styles
inputStyle (Tale tale) =
   tale.inputStyle


{-| See `Skald.elm` for documentation.
-}
fieldStyle : Tale -> Styles
fieldStyle (Tale tale) =
   tale.fieldStyle


{-| The default HTML displayed before the tale's history.
-}
defaultPreamble : Tale -> Html
defaultPreamble (Tale tale) =
  Html.header [ style tale.preambleStyle ]
    [ Html.h1 [ style tale.titleStyle ] [ Html.text tale.title ]
    , Html.p [ style tale.byLineStyle ] [ Html.text ("by " ++ tale.author) ]
    ]


{-| See `Skald.elm` for documentation.
-}
by : String -> Tale -> Tale
by author (Tale tale) =
  Tale { tale | author <- author }


{-| See `Skald.elm` for documentation.
-}
withPreamble : (Tale -> Html) -> Tale -> Tale
withPreamble text (Tale tale) =
  Tale { tale | preamble <- text }


{-| See `Skald.elm` for documentation.
-}
withPageStyle : Styles -> Tale -> Tale
withPageStyle style (Tale tale) =
  Tale { tale | pageStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withPreambleStyle : Styles -> Tale -> Tale
withPreambleStyle style (Tale tale) =
  Tale { tale | preambleStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withTitleStyle : Styles -> Tale -> Tale
withTitleStyle style (Tale tale) =
  Tale { tale | titleStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withByLineStyle : Styles -> Tale -> Tale
withByLineStyle style (Tale tale) =
  Tale { tale | byLineStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withHistoryStyle : Styles -> Tale -> Tale
withHistoryStyle style (Tale tale) =
  Tale { tale | historyStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withEchoStyle : Styles -> Tale -> Tale
withEchoStyle style (Tale tale) =
  Tale { tale | echoStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withErrorStyle : Styles -> Tale -> Tale
withErrorStyle style (Tale tale) =
  Tale { tale | errorStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withInputStyle : Styles -> Tale -> Tale
withInputStyle style (Tale tale) =
  Tale { tale | inputStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withFieldStyle : Styles -> Tale -> Tale
withFieldStyle style (Tale tale) =
  Tale { tale | fieldStyle <- style }


{-| See `Skald.elm` for documentation.
-}
thatBeginsIn : Place -> Tale -> Tale
thatBeginsIn place (Tale tale) =
  Tale
    { tale
    | initialWorld <- World.setCurrentPlace place tale.initialWorld
    }
    |> withPlace place


{-| See `Skald.elm` for documentation.
-}
withPlace : Place -> Tale -> Tale
withPlace place (Tale tale) =
  let
    update = Dict.insert (Place.name place) place
    newWorld = World.updatePlaces update tale.initialWorld
  in
    Tale { tale | initialWorld <- newWorld }


{-| See `Skald.elm` for documentation.
-}
withCommand : String -> CommandHandler -> Tale -> Tale
withCommand pattern handler (Tale tale) =
  let
    update = Command.insert pattern handler
    newWorld = World.updateCommands update tale.initialWorld
  in
    Tale { tale | initialWorld <- newWorld }
