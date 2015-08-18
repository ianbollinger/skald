module Skald.Tale
  ( Tale
  , tale
  , title
  , author
  , initialWorld
  , preamble
  , pageStyle
  , headerStyle
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
import Html exposing (Html, Attribute)
import Regex exposing (regex)

import Skald.Command as Command exposing (emptyWorld)
import Skald.Place as Place exposing (Place)
import Skald.Style as Style
import Skald.World as World exposing (World, CommandHandler, CommandMap)


{-| See `Skald.elm` for documentation.
-}
type Tale =
  Tale
    { title : String
    , author : String
    , initialWorld : World
    , preamble : Tale -> Html
    , pageStyle : Attribute
    , headerStyle : Attribute
    , titleStyle : Attribute
    , byLineStyle : Attribute
    , historyStyle : Attribute
    , echoStyle : Attribute
    , errorStyle : Attribute
    , inputStyle : Attribute
    , fieldStyle : Attribute
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
    , headerStyle = Style.preambleDefault
    , titleStyle = Style.titleDefault
    , byLineStyle = Style.byLineDefault
    , historyStyle = Style.historyDefault
    , echoStyle = Style.echoDefault
    , errorStyle = Style.errorDefault
    , inputStyle = Style.inputDefault
    , fieldStyle = Style.fieldDefault
    }


{-|
-}
title : Tale -> String
title (Tale tale) = tale.title


{-|
-}
author : Tale -> String
author (Tale tale) = tale.author


{-|
-}
initialWorld : Tale -> World
initialWorld (Tale tale) = tale.initialWorld


{-|
-}
preamble : Tale -> (Tale -> Html)
preamble (Tale tale) = tale.preamble


{-|
-}
pageStyle : Tale -> Attribute
pageStyle (Tale tale) = tale.pageStyle


{-|
-}
headerStyle : Tale -> Attribute
headerStyle (Tale tale) = tale.headerStyle


{-|
-}
titleStyle : Tale -> Attribute
titleStyle (Tale tale) = tale.titleStyle


{-|
-}
byLineStyle : Tale -> Attribute
byLineStyle (Tale tale) = tale.byLineStyle


{-|
-}
historyStyle : Tale -> Attribute
historyStyle (Tale tale) = tale.historyStyle


{-|
-}
echoStyle : Tale -> Attribute
echoStyle (Tale tale) = tale.echoStyle


{-|
-}
errorStyle : Tale -> Attribute
errorStyle (Tale tale) = tale.errorStyle


{-|
-}
inputStyle : Tale -> Attribute
inputStyle (Tale tale) = tale.inputStyle


{-|
-}
fieldStyle : Tale -> Attribute
fieldStyle (Tale tale) = tale.fieldStyle


{-|
-}
defaultPreamble : Tale -> Html
defaultPreamble (Tale tale) =
  Html.header [ tale.headerStyle ]
    [ Html.h1 [ tale.titleStyle ] [ Html.text tale.title ]
    , Html.p [ tale.byLineStyle ] [ Html.text ("by " ++ tale.author) ]
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
withPageStyle : Attribute -> Tale -> Tale
withPageStyle style (Tale tale) =
  Tale { tale | pageStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withPreambleStyle : Attribute -> Tale -> Tale
withPreambleStyle style (Tale tale) =
  Tale { tale | headerStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withTitleStyle : Attribute -> Tale -> Tale
withTitleStyle style (Tale tale) =
  Tale { tale | titleStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withByLineStyle : Attribute -> Tale -> Tale
withByLineStyle style (Tale tale) =
  Tale { tale | byLineStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withHistoryStyle : Attribute -> Tale -> Tale
withHistoryStyle style (Tale tale) =
  Tale { tale | historyStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withEchoStyle : Attribute -> Tale -> Tale
withEchoStyle style (Tale tale) =
  Tale { tale | echoStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withErrorStyle : Attribute -> Tale -> Tale
withErrorStyle style (Tale tale) =
  Tale { tale | errorStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withInputStyle : Attribute -> Tale -> Tale
withInputStyle style (Tale tale) =
  Tale { tale | inputStyle <- style }


{-| See `Skald.elm` for documentation.
-}
withFieldStyle : Attribute -> Tale -> Tale
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
