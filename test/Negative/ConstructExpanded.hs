{-# LANGUAGE DataKinds #-}

module ConstructExpanded where

import Emergent.Stage
import Emergent.Syntax
import MetaCons.Axis

bad :: SExpr -> Term 'Expanded
bad expr =
  ExpandedTerm (ExpandedForm expr)
