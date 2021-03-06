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
    field' = String.join " " (String.words (String.toLower field))
    matcher (regex, command) =
      (Regex.find (Regex.AtMost 1) regex field', command)
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
  (regex ("^(?:" ++ string ++ ")$"), handler) :: map


{-|
-}
defaultMap : Map
defaultMap =
  -- TODO: split up look and look [object].
  insert "(?:describe|examine|look(?: at)?|l|x|check|watch)(?: (.+))?" look []
    |> insert "search(?: (.+))?" search
    |> insert "(north(?:east|west)?|east|south(?:east|west)?|west|up|down|[neswud]|ne|nw|se|sw)|go(?: to)?(?: (.+))?" go
    |> insert "(?:take|get)(?: (.+))?" take
    |> insert "(?:take )?inventory|i|inv" inventory
    |> insert "drop(?: (.+))?" drop
    |> insert "wait|z" wait
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
        case Place.object name currentPlace of
          Just found ->
            describeObject found world

          Nothing ->
            case World.item name world of
              Just found ->
                describeObject found world

              Nothing ->
                error "You can't see such a thing." world


{-|
-}
search : Handler
search args world =
  case args of
    [] ->
      let
        place = World.currentPlace world
        formatObject names = "You find " ++ list names ++ " here."
      in
        say (formatObject (Dict.keys (Place.objects place))) world

    [ _ ] ->
      say "You find nothing." world


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
    [ "n" ] ->
      go ["north"] world

    [ "ne" ] ->
      go ["northeast"] world

    [ "e" ] ->
      go ["east"] world

    [ "se" ] ->
      go ["southeast"] world

    [ "s" ] ->
      go ["south"] world

    [ "sw" ] ->
      go ["southwest"] world

    [ "w" ] ->
      go ["west"] world

    [ "nw" ] ->
      go ["northwest"] world

    [ "u" ] ->
      go ["up"] world

    [ "d" ] ->
      go ["down"] world

    [ direction ] ->
      case Place.exitName direction (World.currentPlace world) of
        Just newPlace ->
          enterPlace (World.place newPlace world) world

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
      case Place.object name (World.currentPlace world) of
        Just found ->
          if Object.fixedInPlace found
            then
              error "You can't take that." world
            else
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


inventory : Handler
inventory args world =
  let
    message =
      if Dict.isEmpty (World.inventory world)
      then format "You have nothing."
      else format "You have:"
  in
    (message :: listInventory world, world)


wait : Handler
wait args =
  say "Time passes."


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
toAction f world =
  ([], f world)


{-|
-}
destroyObject : Object -> Action
destroyObject =
  toAction << World.removeObject


{-|
-}
createObject : Object -> Action
createObject =
  toAction << World.addObject


{-|
-}
addToInventory : Object -> Action
addToInventory object =
  toAction (World.updateInventory (Dict.insert (Object.name object) object))


{-|
-}
removeFromInventory : Object -> Action
removeFromInventory =
  toAction << World.updateInventory << Dict.remove << Object.name


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
  setCurrentPlace place world
    `andThen` describePlace place
    `andThen` setCurrentPlace (Place.setVisited True place)


setCurrentPlace : Place -> Action
setCurrentPlace place =
  toAction (World.setCurrentPlace place)


{-| See `Skald.elm` for documentation.
-}
describePlace : Place -> Action
describePlace place world =
  let
    html =
      [ heading (Place.name place)
      , format (Place.description place)
      ]
  in
    (html, world)


{-|
-}
listExits : Place -> List Html
listExits =
  let
    formatExit exit =
      format ("From here you can see an exit to the **" ++ exit ++ "**.")
  in
    List.map formatExit << Dict.keys << Place.exits


{-|
-}
listInventory : World -> List Html
listInventory =
  -- TODO: display proper article; punctuate list properly.
  List.map (\x -> format ("* a " ++ x)) << Dict.keys << World.inventory

-- html ------------------------------------------------------------------------


list : List String -> String
list strings =
  case strings of
    [] ->
      ""

    [ x ] ->
      x

    x :: [ y ] ->
      x ++ ", and " ++ y

    x :: xs ->
      x ++ ", " ++ list xs


-- TODO: rename.
{-|
-}
format : String -> Html
format =
  Markdown.toHtml


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
