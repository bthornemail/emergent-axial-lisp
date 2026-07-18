{-# LANGUAGE OverloadedStrings #-}

module Golden.MExprGolden
  ( tests
  ) where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Emergent.MExpr (parseAndLowerMExpr)
import Emergent.Printer (printCanonical)
import TestHarness

tests :: [TestCase]
tests =
  [ golden "MExpr atom golden" "atom"
  , golden "MExpr CONS golden" "cons"
  , golden "MExpr CAR golden" "car"
  , golden "MExpr CDR golden" "cdr"
  , golden "MExpr empty LIST golden" "list-empty"
  , golden "MExpr three-element LIST golden" "list-three"
  , golden "MExpr QUOTE golden" "quote"
  , golden "MExpr nested CAR/CONS golden" "nested-car-cons"
  , golden "MExpr nested CONS/CAR/CDR golden" "nested-cons-car-cdr"
  , golden "MExpr whitespace golden" "whitespace"
  ]

golden :: String -> FilePath -> TestCase
golden name stem =
  TestCase name $ do
    source <- Text.strip <$> Text.readFile ("test/golden/mexpr/" <> stem <> ".mexpr")
    expected <- Text.strip <$> Text.readFile ("test/golden/mexpr/" <> stem <> ".sexpr")
    lowered <- assertRight name (parseAndLowerMExpr source)
    assertEqual name expected (printCanonical lowered)
