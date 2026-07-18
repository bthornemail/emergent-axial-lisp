module Emergent.MExpr.Error
  ( MExprError (..)
  , MExprParseError (..)
  , MExprParseErrorKind (..)
  , MExprLowerError (..)
  ) where

import Data.Text (Text)
import Emergent.Error (AtomError)
import Emergent.SourceSpan (SourcePosition)

data MExprError
  = MExprParseFailure MExprParseError
  | MExprLowerFailure MExprLowerError
  deriving stock (Eq, Show)

data MExprParseErrorKind
  = MExprUnexpectedCharacter Char
  | MExprUnexpectedEndOfInput
  | MExprExpectedIdentifier
  | MExprExpectedCommaOrClosingParen
  | MExprEmptyArgument
  | MExprTrailingInput
  | MExprIdentifierExceedsBound Int
  | MExprNestingLimitExceeded Int
  | MExprArgumentLimitExceeded Int
  deriving stock (Eq, Show)

data MExprParseError = MExprParseError
  { mexprParseErrorPosition :: SourcePosition
  , mexprParseErrorKind :: MExprParseErrorKind
  , mexprParseErrorMessage :: Text
  }
  deriving stock (Eq, Show)

data MExprLowerError
  = MExprUnknownOperator Text
  | MExprIncorrectArity
      { mexprOperator :: Text
      , mexprExpectedArity :: Text
      , mexprActualArity :: Int
      }
  | MExprInvalidCanonicalAtom Text AtomError
  deriving stock (Eq, Show)
