module Emergent.Expand
  ( CoreForm (..)
  , ExpansionError (..)
  , maxExpansionNesting
  , expandSExpr
  ) where

import Emergent.Expand.Core (expandSExpr)
import Emergent.Expand.Error
  ( CoreForm (..)
  , ExpansionError (..)
  , maxExpansionNesting
  )
