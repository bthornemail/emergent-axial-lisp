{-# LANGUAGE DataKinds #-}

module AdvanceExpandedToTyped where

import Emergent.Stage
import MetaCons.Axis

bad :: Term 'Expanded -> Term 'Typed
bad =
  elaborateIdentity
