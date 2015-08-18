module Skald.Action
  ( Action (..)
  ) where

{-|
-}

type Action
  = NoOp
  | SubmitField
  | UpdateField String
