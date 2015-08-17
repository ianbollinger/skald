module Skald.Tale
  -- TODO: don't expose pattern.
  ( Tale (Tale)
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
  ) where

import Dict exposing (Dict)
import Html exposing (Html, Attribute)

import Skald.Place as Place exposing (Place)
import Skald.Style as Style


type Tale = Tale
  { title : String
  , author : String
  , initialPlace : Place
  , places : Dict String Place
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


tale : String -> Tale
tale title =
  Tale
    { title = title
    , author = ""
    , initialPlace = Place.empty
    , places = Dict.empty
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


--
defaultPreamble : Tale -> Html
defaultPreamble (Tale tale) =
  Html.header [ tale.headerStyle ]
    [ Html.h1 [ tale.titleStyle ] [ Html.text tale.title ]
    , Html.p [ tale.byLineStyle ] [ Html.text ("by " ++ tale.author) ]
    ]


by : String -> Tale -> Tale
by author (Tale tale) =
  Tale { tale | author <- author }


withPreamble : (Tale -> Html) -> Tale -> Tale
withPreamble text (Tale tale) =
  Tale { tale | preamble <- text }


withPageStyle : Attribute -> Tale -> Tale
withPageStyle style (Tale tale) =
  Tale { tale | pageStyle <- style }


withPreambleStyle : Attribute -> Tale -> Tale
withPreambleStyle style (Tale tale) =
  Tale { tale | headerStyle <- style }


withTitleStyle : Attribute -> Tale -> Tale
withTitleStyle style (Tale tale) =
  Tale { tale | titleStyle <- style }


withByLineStyle : Attribute -> Tale -> Tale
withByLineStyle style (Tale tale) =
  Tale { tale | byLineStyle <- style }


withHistoryStyle : Attribute -> Tale -> Tale
withHistoryStyle style (Tale tale) =
  Tale { tale | historyStyle <- style }


withEchoStyle : Attribute -> Tale -> Tale
withEchoStyle style (Tale tale) =
  Tale { tale | echoStyle <- style }


withErrorStyle : Attribute -> Tale -> Tale
withErrorStyle style (Tale tale) =
  Tale { tale | errorStyle <- style }


withInputStyle : Attribute -> Tale -> Tale
withInputStyle style (Tale tale) =
  Tale { tale | inputStyle <- style }


withFieldStyle : Attribute -> Tale -> Tale
withFieldStyle style (Tale tale) =
  Tale { tale | fieldStyle <- style }


thatBeginsIn : Place -> Tale -> Tale
thatBeginsIn place (Tale tale) =
  Tale
    { tale
    | initialPlace <- place
    }
    |> withPlace place


withPlace : Place -> Tale -> Tale
withPlace place (Tale tale) =
  Tale
    { tale
    | places <- Dict.insert place.name place tale.places
    }
