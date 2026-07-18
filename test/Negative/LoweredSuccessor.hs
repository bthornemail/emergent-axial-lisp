{-# LANGUAGE DataKinds #-}

module LoweredSuccessor where

import Emergent.Stage.Transition
import MetaCons.Axis

bad :: StageTransition 'Lowered 'Surface
bad =
  SurfaceToParsed
