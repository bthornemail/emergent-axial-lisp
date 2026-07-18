module Emergent.Error
  ( AtomError (..)
  , KernelError (..)
  , ParseError (..)
  , ParseErrorKind (..)
  ) where

import Data.Text (Text)
import Emergent.SourceSpan (SourcePosition)

data AtomError
  = EmptyAtom
  | ReservedNilAtom
  | InvalidAtomCharacter Char
  | ReservedDotAtom
  deriving stock (Eq, Show)

data KernelError
  = CarOfNonPair Text
  | CdrOfNonPair Text
  deriving stock (Eq, Show)

data ParseErrorKind
  = EmptyInput
  | UnexpectedEndOfInput
  | UnexpectedCharacter Char
  | ExpectedExpression
  | ExpectedListClose
  | ExpectedDottedTail
  | InvalidDottedList
  | InvalidAtom AtomError
  | AtomTooLong Int
  | NestingLimitExceeded Int
  | TrailingInput
  deriving stock (Eq, Show)

data ParseError = ParseError
  { parseErrorPosition :: SourcePosition
  , parseErrorKind :: ParseErrorKind
  , parseErrorMessage :: Text
  }
  deriving stock (Eq, Show)
