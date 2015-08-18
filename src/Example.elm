import Skald exposing (..)

main =
  tale "Example"
    |> by "Ian D. Bollinger"
    |> thatBeginsIn theRoom
    |> withPlace otherRoom
    |> withCommand "think(?:\\s+about)?(?:\\s+(\\S+))?" think
    |> withCommand "throw(?:\\s+(\\S+))?" throw
    |> run

theRoom =
  place "The Room" "A nondescript room."
    |> withExit "north" "The Other Room"
    |> withObject potato

potato =
  object "potato" "An irregularly shaped potato."

otherRoom =
  place "The Other Room" "Not very creative, is it?"
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
      case item name world of
        Just object ->
          say ("You throw the **" ++ name ++ "** at nothing in particular.") world
            `andThen` removeFromInventory object
            `andThen` createObject object

        Nothing ->
          error "You don't have such a thing." world

    _ ->
      error "Throw what?" world
