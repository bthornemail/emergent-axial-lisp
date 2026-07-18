module Emergent.MExpr.Syntax
  ( MExpr (..)
  ) where

import Data.Text (Text)

data MExpr
  = MAtom Text
  | MCall Text [MExpr]
  deriving stock (Eq, Ord, Show)
