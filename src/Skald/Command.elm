module Skald.Command
  ( Handler
  , parse
  , enterPlace
  , say
  , error
  , emptyWorld
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Markdown
import String

import Skald.Object as Object
import Skald.Place as Place exposing (Place)
import Skald.Style as Style
import Skald.World as World exposing (World, CommandMap, CommandHandler)


{-|
-}
type alias Map = CommandMap


{-|
-}
type alias Handler = CommandHandler


{-|
-}
parse : String -> World -> (List Html, World)
parse field world =
  let
    words = String.words (String.toLower field)
  in
    case words of
      x :: xs ->
        case Dict.get x (World.commands world) of
          Just command ->
            command xs world

          Nothing ->
            error "I'm afraid I didn't understand that." world

      _ ->
        -- TODO: this is impossible.
        error "I'm afraid I didn't understand that." world


{-|
-}
defaultMap : Map
defaultMap =
  Dict.empty
    |> Dict.insert "look" look
    |> Dict.insert "examine" look
    |> Dict.insert "go" go
    |> Dict.insert "take" take
    |> Dict.insert "get" take


-- TODO: rename
{-|
-}
emptyWorld : World
emptyWorld =
  World.setCommands defaultMap World.empty


{-|
-}
look : Handler
look args world =
  case args of
    [] ->
      describePlace (World.currentPlaceName world) world

    [ name ] ->
      case Dict.get name (Place.contents (World.currentPlace world)) of
        Just found ->
          say (Object.description found) world

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "You can't see such a thing." world


{-|
-}
go : Handler
go args world =
  case args of
    [ exit ] ->
      case Dict.get exit (Place.exits (World.currentPlace world)) of
        Just newPlace ->
          enterPlace newPlace world

        Nothing ->
          error "You can't go that way." world

    _ ->
      error "Go where?" world


{-|
-}
take : Handler
take args world =
  case args of
    [ name ] ->
      case Dict.get name (Place.contents (World.currentPlace world)) of
        Just found ->
          say ("You take the **" ++ name ++ "**.")
            <| World.removeObject name world

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "Take what?" world


{-|
-}
(&) : (List Html, World) -> (World -> (List Html, World)) -> (List Html, World)
(&) (html1, world) f =
  let
    (html2, world2) = f world
  in
    (html1 ++ html2, world2)


{-| See `Skald.elm` for documentation.
-}
say : String -> World -> (List Html, World)
say string world =
  ([format string], world)


{-| See `Skald.elm` for documentation.
-}
error : String -> World -> (List Html, World)
error string world =
  ([formatError string], world)

-- place -----------------------------------------------------------------------

{-|
-}
enterPlace : String -> World -> (List Html, World)
enterPlace name world =
  World.setCurrentPlaceName name world
    |> describePlace name


{-|
-}
describePlace : String -> World -> (List Html, World)
describePlace name world =
  let
    place = World.getPlace name world
    html =
      [ heading (Place.name place)
      , format (Place.description place)
      ]
        ++ listExits place
        ++ listContents place
  in
    (html, world)


{-|
-}
listExits : Place -> List Html
listExits place =
  let
    formatExit exit =
      format ("From here you can see an exit to the **" ++ exit ++ "**.")
  in
    List.map formatExit (Dict.keys (Place.exits place))


{-|
-}
listContents : Place -> List Html
listContents place =
  let
    formatObject name = format ("You see a **" ++ name ++ "** here.")
  in
    List.map formatObject (Dict.keys (Place.contents place))

-- html ------------------------------------------------------------------------

-- TODO: rename.
{-|
-}
format : String -> Html
format string =
  Markdown.toHtml string


{-|
-}
formatError : String -> Html
formatError string =
  -- TODO: allow style customization.
  Html.div [ Style.errorDefault ] [ Markdown.toHtml string ]


{-|
-}
heading : String -> Html
heading string =
  -- TODO: style.
  Html.h2 [] [ Markdown.toHtml string ]
