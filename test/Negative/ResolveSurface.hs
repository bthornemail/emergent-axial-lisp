{-# LANGUAGE DataKinds #-}

module ResolveSurface where

import Emergent.Stage
import MetaCons.Axis

bad :: Term 'Surface -> Term 'Resolved
bad =
  resolveIdentity
