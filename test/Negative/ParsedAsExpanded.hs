{-# LANGUAGE DataKinds #-}

module ParsedAsExpanded where

import Emergent.Stage
import MetaCons.Axis

requiresExpanded :: Term 'Expanded -> ()
requiresExpanded _ = ()

bad :: Term 'Parsed -> ()
bad =
  requiresExpanded
