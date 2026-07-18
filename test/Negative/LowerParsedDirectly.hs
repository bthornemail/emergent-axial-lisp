{-# LANGUAGE DataKinds #-}

module LowerParsedDirectly where

import Emergent.Stage
import MetaCons.Axis

bad :: Term 'Parsed -> Term 'Lowered
bad =
  lowerIdentity
