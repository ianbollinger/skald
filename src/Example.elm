-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

import Skald exposing (..)

main =
  tale "Example"
  |> by "Ian D. Bollinger"
  |> thatBeginsIn library
  |> withPlace gallery
  |> withCommand "think(?: about)?(?: (.+))?" think
  |> withCommand "throw(?: (\\.+))?" throw
  |> run

library =
  place "Library"
  |> whenDescribing (\x ->
      (if not (isVisited x)
      then
        "The myriad shelves of the once grand library had been looted decades
        ago."
      else
        "The bookcases were bare.")
      ++
        " An alcove to the east housed a broken bench and the shattered
        remains of a stained glass window.")
  |> withExit "north" "Gallery"
  |> containing [ shelves, stainedGlassWindow, potato ]

shelves =
  scenery "shelves"
    "The shelves were bare and blanketed with dust. Occasionally, a scrap of
    parchment could be seen."

stainedGlassWindow =
  scenery "window"
    "What image once adorned the window one could only guess; its shattered
    remnants let in a damp draft."

potato =
  object "potato" "An irregularly shaped potato."

gallery =
  place "Gallery"
  |> withDescription "The walls were bare."
  |> withExit "south" "Library"

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
