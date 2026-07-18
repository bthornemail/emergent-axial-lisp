module Emergent.Stage.Error
  ( StageError (..)
  ) where

import Data.Text (Text)
import MetaCons.Axis (StageAxis)

data StageError
  = UnexpectedSourceGrammar Text
  | TransitionImplementationFailure Text
  | StageWitnessMismatch
      { expectedStage :: StageAxis
      , actualStage :: StageAxis
      }
  | UnsupportedProvisionalTransition Text
  deriving stock (Eq, Show)
