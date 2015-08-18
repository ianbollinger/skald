-- TODO: split up module.
module Skald.Update
  ( update
  , enterPlace
  ) where

import Dict exposing (Dict)
import Html exposing (Html)
import Markdown
import String

import Skald.Action exposing (Action (..))
import Skald.Model as Model exposing (Model)
import Skald.Place exposing (Place)
import Skald.Style as Style
import Skald.Tale exposing (Tale)
import Skald.World as World exposing (World)

-- update ----------------------------------------------------------------------

update :  Tale -> Action -> Model -> Model
update tale action model =
  case action of
    NoOp ->
      model

    UpdateField string ->
      { model | field <- string }

    SubmitField ->
      if String.isEmpty model.field
        then model
        else submitField tale model


-- Submits the contents of the input field to the command parser and then clears
-- the field.
submitField : Tale -> Model -> Model
submitField tale model =
  let
    (commandResult, newWorld) = parseCommand model.field model.world
  in
    model
      |> Model.appendHistory (echo tale model :: commandResult)
      |> clearInputField
      |> updateWorld newWorld


-- Clears the input field.
clearInputField : Model -> Model
clearInputField model =
  { model | field <- "" }


-- Updates the world in the tale's model.
updateWorld : World -> Model -> Model
updateWorld newWorld model =
  { model | world <- newWorld }


-- Copies the contents of the input field to the tale's history.
echo : Tale -> Model -> Html
echo (Skald.Tale.Tale tale) model =
  Html.p [ tale.echoStyle ] [ Html.text (model.field) ]


-- command ---------------------------------------------------------------------

type alias CommandMap = Dict String CommandHandler


type alias CommandHandler = List String -> World -> (List Html, World)


(&) : (List Html, World) -> (World -> (List Html, World)) -> (List Html, World)
(&) (html1, world) f =
  let
    (html2, world2) = f world
  in
    (html1 ++ html2, world2)


say : String -> World -> (List Html, World)
say string world =
  ([format string], world)


error : String -> World -> (List Html, World)
error string world =
  ([formatError string], world)


-- TODO: allow customization.
-- TODO: allow multi-word commands.
commandMap : CommandMap
commandMap =
  Dict.empty
    |> Dict.insert "look" look
    |> Dict.insert "examine" look
    |> Dict.insert "go" go
    |> Dict.insert "take" take
    |> Dict.insert "get" take


look : CommandHandler
look args world =
  case args of
    [] ->
      describePlace (World.currentPlaceName world) world

    -- TODO: normalize spaces to allow objects with spaces in their names.
    [ name ] ->
      case Dict.get name ((World.currentPlace world).contents) of
        Just found ->
          -- TODO: algorithmically determine article and allow per-object
          -- customization.
          say found.description world

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "You can't see such a thing." world


go : CommandHandler
go args world =
  case args of
    [ exit ] ->
      case Dict.get exit (World.currentPlace world).exits of
        Just newPlace ->
          enterPlace newPlace world

        Nothing ->
          error "You can't go that way." world

    _ ->
      error "Go where?" world


take : CommandHandler
take args world =
  case args of
    [ name ] ->
      case Dict.get name ((World.currentPlace world).contents) of
        Just found ->
          -- TODO: algorithmically determine article and allow per-object
          -- customization.
          say ("You take the **" ++ name ++ "**.")
            <| World.removeObject name world

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "Take what?" world


parseCommand : String -> World -> (List Html, World)
parseCommand field =
  let
    words = String.words (String.toLower field)
  in
    case words of
      x :: xs ->
        case Dict.get x commandMap of
          Just command ->
            command xs

          Nothing ->
            error "I'm afraid I didn't understand that."

      _ ->
        -- TODO: this is impossible.
        error "I'm afraid I didn't understand that."

-- html ------------------------------------------------------------------------

-- TODO: rename.
format : String -> Html
format string =
  Markdown.toHtml string


formatError : String -> Html
formatError string =
  -- TODO: allow style customization.
  Html.div [ Style.errorDefault ] [ Markdown.toHtml string ]


-- TODO: This creates an invalid HTML DOM tree. (e.g., <p> inside <h2>)
heading : String -> Html
heading string =
  -- TODO: style.
  Html.h2 [] [ Markdown.toHtml string ]

-- place -----------------------------------------------------------------------

enterPlace : String -> World -> (List Html, World)
enterPlace name world =
  World.updateCurrentPlaceName name world
    |> describePlace name


describePlace : String -> World -> (List Html, World)
describePlace name world =
  let
    place = World.getPlace name world
    html =
      [ heading place.name
      , format place.description
      ]
        ++ listExits place
        ++ listContents place
  in
    (html, world)


listExits : Place -> List Html
listExits place =
  let
    formatExit exit =
      format ("From here you can see an exit to the **" ++ exit ++ "**.")
  in
    List.map formatExit (Dict.keys place.exits)


listContents : Place -> List Html
listContents place =
  let
    formatObject name = format ("You see a **" ++ name ++ "** here.")
  in
    List.map formatObject (Dict.keys place.contents)
