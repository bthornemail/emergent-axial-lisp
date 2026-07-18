module Emergent.Syntax
  ( Atom
  , SExpr (Nil, AtomExpr, Pair)
  , atomText
  , mkAtom
  , nil
  , atom
  , cons
  , list
  , toProperList
  , isNil
  , isAtom
  , isPair
  ) where

import Data.Char (isSpace)
import Data.Text (Text)
import qualified Data.Text as Text
import Emergent.Error (AtomError (..))

newtype Atom = Atom {atomText :: Text}
  deriving stock (Eq, Ord, Show)

data SExpr
  = Nil
  | AtomExpr Atom
  | Pair SExpr SExpr
  deriving stock (Eq, Ord, Show)

mkAtom :: Text -> Either AtomError Atom
mkAtom text
  | Text.null text = Left EmptyAtom
  | text == "NIL" = Left ReservedNilAtom
  | text == "." = Left ReservedDotAtom
  | otherwise =
      case Text.find invalidAtomChar text of
        Just char -> Left (InvalidAtomCharacter char)
        Nothing -> Right (Atom text)

nil :: SExpr
nil = Nil

atom :: Text -> Either AtomError SExpr
atom text = AtomExpr <$> mkAtom text

cons :: SExpr -> SExpr -> SExpr
cons = Pair

list :: [SExpr] -> SExpr
list = foldr cons nil

toProperList :: SExpr -> Maybe [SExpr]
toProperList Nil = Just []
toProperList (AtomExpr _) = Nothing
toProperList (Pair carExpr cdrExpr) = (carExpr :) <$> toProperList cdrExpr

isNil :: SExpr -> Bool
isNil Nil = True
isNil _ = False

isAtom :: SExpr -> Bool
isAtom (AtomExpr _) = True
isAtom _ = False

isPair :: SExpr -> Bool
isPair (Pair _ _) = True
isPair _ = False

invalidAtomChar :: Char -> Bool
invalidAtomChar char =
  isSpace char || char `elem` ['(', ')', '\'', '`', ',', ';']
