module Unit.KernelSpec
  ( tests
  ) where

import Data.Text (Text)
import MetaCons.Kernel
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "NIL prints canonically" $
      assertEqual "NIL print" "NIL" (printCanonical nil)
  , TestCase "atom prints canonically" $ do
      expr <- mustAtom "alpha"
      assertEqual "atom print" "alpha" (printCanonical expr)
  , TestCase "pair prints canonically" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertEqual "pair print" "(A . B)" (printCanonical (cons a b))
  , TestCase "nested pair prints canonically" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      c <- mustAtom "C"
      assertEqual "nested print" "(A B . C)" (printCanonical (cons a (cons b c)))
  , TestCase "proper list prints canonically" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      c <- mustAtom "C"
      assertEqual "proper list print" "(A B C)" (printCanonical (list [a, b, c]))
  , TestCase "improper list prints canonically" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      c <- mustAtom "C"
      assertEqual "improper list print" "(A B . C)" (printCanonical (cons a (cons b c)))
  , TestCase "empty list is NIL" $
      assertEqual "empty list" nil (list [])
  , TestCase "CAR recovers left" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertEqual "car" (Right a) (car (cons a b))
  , TestCase "CDR recovers right" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertEqual "cdr" (Right b) (cdr (cons a b))
  , TestCase "CAR failure on atom" $ do
      a <- mustAtom "A"
      assertLeft "car atom" (car a)
  , TestCase "CDR failure on NIL" $
      assertLeft "cdr nil" (cdr nil)
  , TestCase "canonical print is deterministic" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      let expr = cons a b
      assertEqual "deterministic print" (printCanonical expr) (printCanonical expr)
  , TestCase "canonical AST equality is structural" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertBool "same structure equals" (cons a b == cons a b)
      assertBool "ordered pair differs" (cons a b /= cons b a)
  , TestCase "proper-list inspection succeeds" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertEqual "toProperList" (Just [a, b]) (toProperList (list [a, b]))
  , TestCase "improper-list inspection fails" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertEqual "toProperList improper" Nothing (toProperList (cons a b))
  , TestCase "predicates identify constructors" $ do
      a <- mustAtom "A"
      b <- mustAtom "B"
      assertBool "nil predicate" (isNil nil)
      assertBool "atom predicate" (isAtom a)
      assertBool "pair predicate" (isPair (cons a b))
  ]

mustAtom :: Text -> IO SExpr
mustAtom text =
  case atom text of
    Right expr -> pure expr
    Left err -> fail ("invalid test atom: " <> show err)
