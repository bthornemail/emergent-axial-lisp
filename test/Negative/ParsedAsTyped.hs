{-# LANGUAGE DataKinds #-}

module ParsedAsTyped where

import Emergent.Stage
import MetaCons.Axis

requiresTyped :: Term 'Typed -> ()
requiresTyped _ = ()

bad :: Term 'Parsed -> ()
bad =
  requiresTyped
