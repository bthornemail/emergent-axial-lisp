module Emergent.Error
  ( AtomError (..)
  , KernelError (..)
  ) where

import Data.Text (Text)

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
