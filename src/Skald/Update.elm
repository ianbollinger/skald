-- TODO: split up module.
module Skald.Update
  ( update
  , enterPlace
  ) where

{-|
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Markdown
import String

import Skald.Action exposing (Action (..))
import Skald.Model as Model exposing (Model)
import Skald.Object as Object
import Skald.Place as Place exposing (Place)
import Skald.Style as Style
import Skald.Tale as Tale exposing (Tale)
import Skald.World as World exposing (World)

-- update ----------------------------------------------------------------------

update :  Tale -> Action -> Model -> Model
update tale action model =
  case action of
    NoOp ->
      model

    UpdateField string ->
      Model.setInputField string model

    SubmitField ->
      if String.isEmpty (Model.inputField model)
        then model
        else submitField tale model


{-| Submits the contents of the input field to the command parser and the
clears the field.
-}
submitField : Tale -> Model -> Model
submitField tale model =
  let
    (commandResult, newWorld) =
      parseCommand (Model.inputField model) (Model.world model)
  in
    model
      |> Model.appendHistory (echo tale model :: commandResult)
      |> Model.clearInputField
      |> Model.setWorld newWorld


{-| Copies the contents of the input field to the tale's history.
-}
echo : Tale -> Model -> Html
echo tale model =
  Html.p [ Tale.echoStyle tale ] [ Html.text (Model.inputField model) ]


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

    [ name ] ->
      case Dict.get name (Place.contents (World.currentPlace world)) of
        Just found ->
          say (Object.description found) world

        Nothing ->
          error "You can't see such a thing." world

    _ ->
      error "You can't see such a thing." world


go : CommandHandler
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


take : CommandHandler
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


heading : String -> Html
heading string =
  -- TODO: style.
  Html.h2 [] [ Markdown.toHtml string ]

-- place -----------------------------------------------------------------------

enterPlace : String -> World -> (List Html, World)
enterPlace name world =
  World.setCurrentPlaceName name world
    |> describePlace name


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


listExits : Place -> List Html
listExits place =
  let
    formatExit exit =
      format ("From here you can see an exit to the **" ++ exit ++ "**.")
  in
    List.map formatExit (Dict.keys (Place.exits place))


listContents : Place -> List Html
listContents place =
  let
    formatObject name = format ("You see a **" ++ name ++ "** here.")
  in
    List.map formatObject (Dict.keys (Place.contents place))
