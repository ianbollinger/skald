module Skald.Style
  ( pageDefault
  , preambleDefault
  , titleDefault
  , byLineDefault
  , historyDefault
  , echoDefault
  , errorDefault
  , inputDefault
  , fieldDefault
  ) where

{-|

@docs pageDefault, preambleDefault, titleDefault, byLineDefault, historyDefault
@docs echoDefault, errorDefault, inputDefault, fieldDefault
-}

import Html exposing (Attribute)
import Html.Attributes exposing (style)


{-| The default style for a tale's page.
-}
pageDefault : Attribute
pageDefault =
  style
    [ ("margin", "0 auto 4em auto")
    , ("width", "60ex")
    ]


{-| The default style for a tale's preamble.
-}
preambleDefault : Attribute
preambleDefault =
  style
    [ ("margin-bottom", "3em")
    ]


{-| The default style for a tale's title.
-}
titleDefault : Attribute
titleDefault =
  style
    [ ("font-size", "30pt")
    , ("margin-bottom", "0")
    ]


{-| The default style for a tale's by-line.
-}
byLineDefault : Attribute
byLineDefault =
  style
    [ ("margin-top", "0")
    ]


{-| The default style for a tale's history.
-}
historyDefault : Attribute
historyDefault =
  style
    [ ("font-family", "Raleway, sans-serif") ]


{-| The default style for commands echoed in the tale's history.
-}
echoDefault : Attribute
echoDefault =
  style
    [ ("font-style", "italic")
    , ("color", "#060")
    ]


{-| The default style for errors displayed in the tale's history.
-}
errorDefault : Attribute
errorDefault =
  style
    [ ("font-style", "italic")
    , ("color", "#600")
    ]


{-| The default style for the area surrounding the input field.
-}
inputDefault : Attribute
inputDefault =
  style
    [ ("width", "60ex")
    , ("padding", "10px 0")
    , ("margin", "0 auto 0 auto")
    , ("position", "fixed")
    , ("bottom", "0")
    , ("background", "white")
    ]


{-| The default style for the input field.
-}
fieldDefault : Attribute
fieldDefault =
  style
    [ ("width", "100%")
    , ("border", "1px black solid")
    , ("font-family", "Raleway, sans-serif")
    ]
