module Emergent.Printer
  ( printCanonical
  ) where

import Data.Text (Text)
import Emergent.Syntax (SExpr (..), atomText)

printCanonical :: SExpr -> Text
printCanonical Nil = "NIL"
printCanonical (AtomExpr atom) = atomText atom
printCanonical pair@(Pair _ _) = "(" <> printPair pair <> ")"

printPair :: SExpr -> Text
printPair (Pair carExpr cdrExpr) =
  printCanonical carExpr <> printTail cdrExpr
printPair expr = printCanonical expr

printTail :: SExpr -> Text
printTail Nil = ""
printTail (Pair carExpr cdrExpr) =
  " " <> printCanonical carExpr <> printTail cdrExpr
printTail expr =
  " . " <> printCanonical expr
