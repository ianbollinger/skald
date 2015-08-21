-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

import Skald exposing (..)

main =
  tale "Example"
  |> by "Ian D. Bollinger"
  |> thatBeginsIn theRoom
  |> withPlace otherRoom
  |> withCommand "think(?: about)?(?: (\\S+))?" think
  |> withCommand "throw(?: (\\S+))?" throw
  |> run

theRoom =
  place "The Room"
  |> withDescription "A nondescript room."
  |> withExit "north" "The Other Room"
  |> withObject potato

potato =
  object "potato" "An irregularly shaped potato."

otherRoom =
  place "The Other Room"
  |> withDescription "Not very creative, is it?"
  |> withExit "south" "The Room"

think args =
  case args of
    [ _ ] ->
      error "Thinking about that yields no new insight."
    _ ->
      error "When has that solved anything?"

throw args world =
  case args of
    [ name ] ->
      case getItem name world of
        Just object ->
          say ("You throw the **" ++ name ++ "** at nothing in particular.") world
            `andThen` removeFromInventory object
            `andThen` createObject object
        Nothing ->
          error "You don't have such a thing." world
    _ ->
      error "Throw what?" world
