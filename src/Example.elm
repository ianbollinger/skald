import Skald exposing (..)

main =
  tale "Example"
    |> by "Ian D. Bollinger"
    |> thatBeginsIn theRoom
    |> withPlace otherRoom
    |> withCommand "^\\s*think(?:\\s+about)?(?:\\s+(\\S+))?\\s*$" think
    |> run

think args =
  case args.submatches of
    [ Just x ] ->
      error "Thinking about that yields no new insight."
    [ Nothing ] ->
      error "When has that solved anything?"

theRoom =
  place "The Room" "A nondescript room."
    |> withExit "north" "The Other Room"
    |> withObject potato

potato =
  object "potato" "An irregularly shaped potato."

otherRoom =
  place "The Other Room" "Not very creative, is it?"
    |> withExit "south" "The Room"
