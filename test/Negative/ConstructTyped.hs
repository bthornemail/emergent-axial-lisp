{-# LANGUAGE DataKinds #-}

module ConstructTyped where

import Emergent.Stage
import Emergent.Syntax
import MetaCons.Axis

bad :: SExpr -> Term 'Typed
bad expr =
  TypedTerm (TypedForm expr)
