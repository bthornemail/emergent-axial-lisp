{-# LANGUAGE DataKinds #-}

module CallRemovedIdentity where

import Emergent.Stage
import MetaCons.Axis

bad :: Term 'Parsed -> Term 'Expanded
bad =
  expandIdentity
