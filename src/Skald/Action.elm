module Skald.Action
  -- TODO: hide patterns
  ( Action (..)
  ) where

type Action
  = NoOp
  | SubmitField
  | UpdateField String
