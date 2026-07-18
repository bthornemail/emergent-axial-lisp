module MetaCons.Serialize.Error
  ( SerializeError (..)
  , SerializeErrorKind (..)
  ) where

import Data.Text (Text)
import Emergent.Error (AtomError)

data SerializeErrorKind
  = InvalidMagic
  | UnsupportedVersion Int
  | UnexpectedEndOfInput
  | UnknownTag Int
  | InvalidLength Int
  | LengthExceedsBound Int Int
  | InvalidUtf8
  | InvalidAtom AtomError
  | TrailingBytes Int
  | NonCanonicalEncoding Text
  | NestingLimitExceeded Int
  deriving stock (Eq, Show)

data SerializeError = SerializeError
  { serializeErrorOffset :: Int
  , serializeErrorKind :: SerializeErrorKind
  }
  deriving stock (Eq, Show)
