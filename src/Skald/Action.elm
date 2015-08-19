-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.Action
  ( Handler
  , Action
  , andThen
  , parse
  , enterPlace
  , doNothing
  , say
  , error
  , emptyWorld
  , insert
  , describePlace
  , describeObject
  , removeFromInventory
  , createObject
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes exposing (style)
import List
import Markdown
import Regex exposing (regex)
import String

import Skald.Object as Object exposing (Object)
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
type alias Result = (List Html, World)


{-|
-}
type alias Action = World -> Result


{-|
-}
parse : String -> Action
parse field world =
  let
    matcher (regex, command) =
      (Regex.find (Regex.AtMost 1) regex field, command)
    predicate (x, _) = not (List.isEmpty x)
  in
    case mapFirst matcher predicate (World.commands world) of
      Just (match, command) ->
        case List.head match of
          Just match' ->
            command (List.filterMap (\x -> x) match'.submatches) world

          Nothing ->
            error "I'm afraid I didn't understand that." world

      Nothing ->
        error "I'm afraid I didn't understand that." world


{-| Applies operation only to the first element in the given list that satisfies
the predicate; returns Nothing if no element suffices.
-}
mapFirst : (a -> b) -> (b -> Bool) -> List a -> Maybe b
mapFirst operation predicate list =
  case list of
    [] ->
      Nothing

    x :: xs ->
      let
        y = operation x
      in
        if predicate y
          then Just y
          else mapFirst operation predicate xs


{-| Inserts a command handler into the given command map.
-}
insert : String -> Handler -> Map -> Map
insert string handler map =
  (Regex.caseInsensitive (regex ("^\\s*" ++ string ++ "\\s*$")), handler) :: map


{-|
-}
defaultMap : Map
defaultMap =
  insert "(?:examine|look(?:\\s+at)?|x)(?:\\s+(\\S*))?" look []
    |> insert "go(?:\\s+to)?(?:\\s+(\\S*))?" go
    |> insert "(?:take|get)(?:\\s+(\\S*))?" take
    |> insert "drop(?:\\s+(\\S*))?" drop
--    |> insert "debug" debug

{-|
-}
debug : Handler
debug args world =
  say (World.toString world) world

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
  let
    currentPlace = World.currentPlace world
  in
    case args of
      [] ->
        describePlace currentPlace world

      [ name ] ->
        case Dict.get name (Place.contents currentPlace) of
          Just found ->
            describeObject found world

          Nothing ->
            case World.item name world of
              Just found ->
                describeObject found world

              Nothing ->
                error "You can't see such a thing." world


{-| See `Skald.elm` for documentation.
-}
describeObject : Object -> Action
describeObject object =
  say (Object.description object)


{-|
-}
go : Handler
go args world =
  case args of
    [ direction ] ->
      case Place.exitName direction (World.currentPlace world) of
        Just newPlace ->
          enterPlace (World.getPlace newPlace world) world

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
          addToInventory found world
            `andThen` destroyObject found
            `andThen` say ("You take the **" ++ name ++ "**.")

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "Take what?" world


{-|
-}
drop : Handler
drop args world =
  case args of
    [ name ] ->
      case World.item name world of
        Just found ->
          removeFromInventory found world
            `andThen` createObject found
            `andThen` say ("You drop the **" ++ name ++ "**.")

        Nothing ->
          error "You don't have such a thing." world

    _ ->
      error "Drop what?" world


{-| See `Skald.elm` for documentation.
-}
andThen : Result -> Action -> Result
andThen (html1, world) f =
  let
    (html2, world2) = f world
  in
    (html1 ++ html2, world2)


{-| Converts a function over worlds into a command.
-}
toAction : (World -> World) -> Action
toAction f world = ([], f world)


{-|
-}
destroyObject : Object -> Action
destroyObject object =
  toAction (World.removeObject object)


{-|
-}
createObject : Object -> Action
createObject object =
  toAction (World.addObject object)


{-|
-}
addToInventory : Object -> Action
addToInventory object =
  toAction (World.updateInventory (Dict.insert (Object.name object) object))


{-|
-}
removeFromInventory : Object -> Action
removeFromInventory object =
  toAction (World.updateInventory (Dict.remove (Object.name object)))


{-|
-}
doNothing : Action
doNothing world =
  ([], world)


{-| See `Skald.elm` for documentation.
-}
say : String -> Action
say string world =
  ([format string], world)


{-| See `Skald.elm` for documentation.
-}
error : String -> Action
error string world =
  ([formatError string], world)

-- place -----------------------------------------------------------------------

{-|
-}
enterPlace : Place -> Action
enterPlace place world =
  World.setCurrentPlace place world
    |> describePlace place


{-| See `Skald.elm` for documentation.
-}
describePlace : Place -> Action
describePlace place world =
  let
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
  Html.div [ style Style.errorDefault ] [ Markdown.toHtml string ]


{-|
-}
heading : String -> Html
heading string =
  -- TODO: style.
  Html.h2 [] [ Markdown.toHtml string ]
