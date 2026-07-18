module Emergent.Expand.Error
  ( CoreForm (..)
  , ExpansionError (..)
  , maxExpansionNesting
  ) where

import Data.Text (Text)
import Emergent.Syntax (SExpr)

data CoreForm
  = CoreQuote
  | CoreIf
  | CoreLambda
  | CoreBegin
  | CoreDefine
  | CoreSet
  deriving stock (Eq, Ord, Show)

data ExpansionError
  = ImproperApplication SExpr
  | IncorrectCoreArity
      { expansionForm :: CoreForm
      , expectedArity :: Text
      , observedArity :: Int
      }
  | MalformedLambdaParameters SExpr
  | DuplicateLambdaParameter Text
  | InvalidBindingName SExpr
  | UnsupportedDerivedForm CoreForm SExpr
  | ExpansionNestingLimitExceeded Int
  deriving stock (Eq, Show)

maxExpansionNesting :: Int
maxExpansionNesting = 1024
