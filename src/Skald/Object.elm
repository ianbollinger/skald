module Skald.Object
  ( Object
  , object
  ) where


type alias Object =
  { name : String
  , description : String
  }


object : String -> String -> Object
object name description =
  { name = name
  , description = description
  }
