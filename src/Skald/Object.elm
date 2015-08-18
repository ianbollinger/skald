module Skald.Object
  ( Object
  , object
  , name
  , description
  ) where


{-| See `Skald.elm` for documentation.
-}
type Object =
  Object
    { name : String
    , description : String
    }


{-| See `Skald.elm` for documentation.
-}
object : String -> String -> Object
object name description =
  Object
    { name = name
    , description = description
    }


{-| The name of the given object.
-}
name : Object -> String
name (Object object) =
  object.name


{-| The description of the given object.
-}
description : Object -> String
description (Object object) =
  object.description
