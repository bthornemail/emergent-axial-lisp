module MetaCons.Kernel
  ( Atom
  , SExpr
  , AtomError (..)
  , KernelError (..)
  , atomText
  , mkAtom
  , nil
  , atom
  , cons
  , car
  , cdr
  , isNil
  , isAtom
  , isPair
  , list
  , toProperList
  , printCanonical
  ) where

import Emergent.Error (AtomError (..), KernelError (..))
import Emergent.Printer (printCanonical)
import Emergent.Syntax
  ( Atom
  , SExpr (..)
  , atom
  , atomText
  , cons
  , isAtom
  , isNil
  , isPair
  , list
  , mkAtom
  , nil
  , toProperList
  )

car :: SExpr -> Either KernelError SExpr
car (Pair carExpr _) = Right carExpr
car expr = Left (CarOfNonPair (printCanonical expr))

cdr :: SExpr -> Either KernelError SExpr
cdr (Pair _ cdrExpr) = Right cdrExpr
cdr expr = Left (CdrOfNonPair (printCanonical expr))
