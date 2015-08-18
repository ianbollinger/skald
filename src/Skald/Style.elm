module Skald.Style
  ( Styles
  , pageDefault
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

@doc Styles

# Default styles

@docs pageDefault, preambleDefault, titleDefault, byLineDefault, historyDefault
@docs echoDefault, errorDefault, inputDefault, fieldDefault
-}


{-|
-}
type alias Styles = List (String, String)


{-| The default style for a tale's page.
-}
pageDefault : Styles
pageDefault =
  [ ("margin", "0 auto 4em auto")
  , ("width", "60ex")
  ]


{-| The default style for a tale's preamble.
-}
preambleDefault : Styles
preambleDefault =
  [ ("margin-bottom", "3em")
  ]


{-| The default style for a tale's title.
-}
titleDefault : Styles
titleDefault =
  [ ("font-size", "30pt")
  , ("margin-bottom", "0")
  ]


{-| The default style for a tale's by-line.
-}
byLineDefault : Styles
byLineDefault =
  [ ("margin-top", "0")
  ]


{-| The default style for a tale's history.
-}
historyDefault : Styles
historyDefault =
  [ ("font-family", "Raleway, sans-serif") ]


{-| The default style for commands echoed in the tale's history.
-}
echoDefault : Styles
echoDefault =
  [ ("font-style", "italic")
  , ("color", "#060")
  ]


{-| The default style for errors displayed in the tale's history.
-}
errorDefault : Styles
errorDefault =
  [ ("font-style", "italic")
  , ("color", "#600")
  ]


{-| The default style for the area surrounding the input field.
-}
inputDefault : Styles
inputDefault =
  [ ("width", "60ex")
  , ("padding", "10px 0")
  , ("margin", "0 auto 0 auto")
  , ("position", "fixed")
  , ("bottom", "0")
  , ("background", "white")
  ]


{-| The default style for the input field.
-}
fieldDefault : Styles
fieldDefault =
  [ ("width", "100%")
  , ("border", "1px black solid")
  , ("font-family", "Raleway, sans-serif")
  ]
