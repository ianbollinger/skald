-- Copyright 2015 Ian D. Bollinger
--
-- Licensed under the MIT license <LICENSE or
-- http://opensource.org/licenses/MIT>. This file may not be copied, modified,
-- or distributed except according to those terms.

module Skald.AppAction
  ( AppAction (..)
  ) where

{-|
-}

{-|
-}
type AppAction
  = NoOp
  | SubmitField
  | UpdateField String
