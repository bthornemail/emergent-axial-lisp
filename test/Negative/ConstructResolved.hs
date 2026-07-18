{-# LANGUAGE DataKinds #-}

module ConstructResolved where

import Emergent.Stage
import Emergent.Syntax
import MetaCons.Axis

bad :: SExpr -> Term 'Resolved
bad expr =
  ResolvedTerm (ResolvedForm expr)
