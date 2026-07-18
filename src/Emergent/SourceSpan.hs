module Emergent.SourceSpan
  ( SourcePosition (..)
  ) where

data SourcePosition = SourcePosition
  { sourceLine :: Int
  , sourceColumn :: Int
  , sourceOffset :: Int
  }
  deriving stock (Eq, Ord, Show)
