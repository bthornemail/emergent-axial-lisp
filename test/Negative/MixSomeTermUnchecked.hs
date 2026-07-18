{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

module MixSomeTermUnchecked where

import Emergent.Stage
import MetaCons.Axis

requiresParsed :: Term 'Parsed -> ()
requiresParsed _ = ()

bad :: SomeTerm -> ()
bad (SomeTerm _ term) =
  requiresParsed term
