{-# LANGUAGE OverloadedStrings #-}

module Property.MExprProperties
  ( tests
  ) where

import Data.Text (Text)
import Emergent.MExpr
import Emergent.Parser (parseSExpr)
import MetaCons.Serialize (encodeSExpr)
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: MExpr lowering is deterministic" $
      mapM_ assertLoweringDeterministic samples
  , TestCase "property: MExpr argument order is preserved" $ do
      left <- assertRight "left" (parseAndLowerMExpr "CONS(a,b)")
      right <- assertRight "right" (parseAndLowerMExpr "CONS(b,a)")
      assertBool "ordered lowering" (left /= right)
  , TestCase "property: nested MExpr lowering is deterministic" $
      assertLoweringDeterministic "CONS(CAR(x), CDR(y))"
  , TestCase "property: MExpr lowering corresponds to canonical parser" $
      mapM_ assertCorrespondence correspondenceSamples
  , TestCase "property: serialization of lowered MExpr is deterministic" $
      mapM_ assertSerializationStable samples
  ]

assertLoweringDeterministic :: Text -> IO ()
assertLoweringDeterministic source = do
  parsed <- assertRight "parse MExpr" (parseMExpr source)
  assertEqual "lower deterministic" (lowerMExpr parsed) (lowerMExpr parsed)

assertCorrespondence :: (Text, Text) -> IO ()
assertCorrespondence (source, expectedCanonical) = do
  lowered <- assertRight "parse and lower" (parseAndLowerMExpr source)
  expected <- assertRight "canonical parse" (parseSExpr expectedCanonical)
  assertEqual "MExpr/canonical parser correspondence" expected lowered

assertSerializationStable :: Text -> IO ()
assertSerializationStable source = do
  lowered <- assertRight "parse and lower" (parseAndLowerMExpr source)
  assertEqual "serialization stable" (encodeSExpr lowered) (encodeSExpr lowered)

samples :: [Text]
samples =
  [ "a"
  , "CONS(a,b)"
  , "CAR(CONS(a,b))"
  , "LIST(a,b,c)"
  , "QUOTE(CAR(x))"
  , "CONS(CAR(x),CDR(y))"
  ]

correspondenceSamples :: [(Text, Text)]
correspondenceSamples =
  [ ("a", "a")
  , ("CONS(a,b)", "(cons a b)")
  , ("CAR(x)", "(car x)")
  , ("CDR(x)", "(cdr x)")
  , ("LIST()", "(list)")
  , ("LIST(a,b,c)", "(list a b c)")
  , ("QUOTE(x)", "(quote x)")
  , ("CAR(CONS(a,b))", "(car (cons a b))")
  , ("CONS(CAR(x),CDR(y))", "(cons (car x) (cdr y))")
  ]
