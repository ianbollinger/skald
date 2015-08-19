-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.Action
  ( Action (..)
  ) where

{-|
-}

{-|
-}
type Action
  = NoOp
  | SubmitField
  | UpdateField String
