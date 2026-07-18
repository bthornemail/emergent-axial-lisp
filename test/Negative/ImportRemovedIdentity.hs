{-# LANGUAGE DataKinds #-}

module ImportRemovedIdentity where

import Emergent.Stage
  ( Term
  , expandIdentity
  , lowerIdentity
  )
import MetaCons.Axis

bad :: Term 'Parsed -> Term 'Expanded
bad =
  expandIdentity

badLower :: Term 'Resolved -> Term 'Lowered
badLower =
  lowerIdentity
