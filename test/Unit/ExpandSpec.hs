{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Unit.ExpandSpec
  ( tests
  ) where

import qualified Data.Text as Text
import Emergent.Expand
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import Emergent.Stage
import Emergent.Stage.Transition
import Emergent.Syntax (SExpr, atom, cons, list)
import MetaCons.Axis (StageAxis (Expanded, Parsed))
import TestHarness

tests :: [TestCase]
tests =
  [ expands "expand ordinary atom" "a" "a"
  , expands "expand ordinary proper application" "(f a b)" "(f a b)"
  , expands "expand nested application" "(f (g a) (h b))" "(f (g a) (h b))"
  , expands "expand quote" "(quote x)" "(quote x)"
  , expands "expand quote preserves improper data" "(quote (a . b))" "(quote (a . b))"
  , expands
      "expand quote prevents recursive special-form interpretation"
      "(quote (if a b))"
      "(quote (if a b))"
  , expands "expand if with 2 operands" "(if test consequent)" "(if test consequent)"
  , expands
      "expand if with 3 operands"
      "(if test consequent alternate)"
      "(if test consequent alternate)"
  , rejects "expand if wrong arity" "(if test)" (matchesArity CoreIf 1)
  , expands "expand lambda empty parameters" "(lambda () body)" "(lambda () body)"
  , expands "expand lambda fixed parameters" "(lambda (x y) body)" "(lambda (x y) body)"
  , expands "expand lambda symbol parameter" "(lambda args body)" "(lambda args body)"
  , rejects "expand lambda duplicate parameter rejection" "(lambda (x x) body)" (matchesDuplicate "x")
  , rejects "expand lambda malformed parameter rejection" "(lambda (x . y) body)" matchesMalformedLambda
  , expands "expand begin empty" "(begin)" "(begin)"
  , expands "expand begin multiple forms" "(begin a b c)" "(begin a b c)"
  , expands "expand define variable" "(define name value)" "(define name value)"
  , rejects "expand define function sugar rejected" "(define (f x) body)" matchesUnsupportedDefine
  , expands "expand set! valid" "(set! name value)" "(set! name value)"
  , rejects "expand set! invalid name" "(set! (name) value)" matchesInvalidBindingName
  , rejects "expand improper application rejected" "(f a . b)" matchesImproperApplication
  , expands "expand unknown application head preserved" "(custom a b)" "(custom a b)"
  , TestCase "expand nesting limit" $ do
      nested <- nestedApplication (maxExpansionNesting + 2)
      case expandSExpr nested of
        Left (ExpansionNestingLimitExceeded observed) ->
          assertBool "observed nesting exceeds declared limit" (observed > maxExpansionNesting)
        other -> fail ("expected nesting limit error, got " <> show other)
  , TestCase "expand Parsed to Expanded custody" $ do
      parsed <- assertRight "parse parsed term" (parseSurface (surfaceForm "(if a b c)"))
      expanded <- assertRight "expand parsed" (expandParsed parsed)
      assertEqual "parsed stage" Parsed (stageOfTerm parsed)
      assertEqual "expanded stage" Expanded (stageOfTerm expanded)
      expected <- parse "(if a b c)"
      assertEqual "expanded syntax" expected (expandedSExpr expanded)
  , TestCase "expand transition availability has two implemented and four pending edges" $ do
      assertEqual "implemented count" 2 (countAvailability ImplementedTransition)
      assertEqual "pending count" 4 (countAvailability PendingTransition)
  ]

expands :: String -> Text.Text -> Text.Text -> TestCase
expands name source expected =
  TestCase name $ do
    input <- parse source
    expectedExpr <- parse expected
    expanded <- assertRight name (expandSExpr input)
    assertEqual name (printCanonical expectedExpr) (printCanonical expanded)

rejects :: String -> Text.Text -> (ExpansionError -> Bool) -> TestCase
rejects name source predicate =
  TestCase name $ do
    input <- parse source
    case expandSExpr input of
      Left err -> assertBool ("unexpected error: " <> show err) (predicate err)
      Right value -> fail ("expected expansion error, got " <> show value)

parse :: Text.Text -> IO SExpr
parse source =
  assertRight ("parse " <> Text.unpack source) (parseSExpr source)

matchesArity :: CoreForm -> Int -> ExpansionError -> Bool
matchesArity expectedForm expectedObserved err =
  case err of
    IncorrectCoreArity form _ observed ->
      form == expectedForm && observed == expectedObserved
    _ -> False

matchesDuplicate :: Text.Text -> ExpansionError -> Bool
matchesDuplicate expected err =
  case err of
    DuplicateLambdaParameter actual -> actual == expected
    _ -> False

matchesMalformedLambda :: ExpansionError -> Bool
matchesMalformedLambda (MalformedLambdaParameters _) = True
matchesMalformedLambda _ = False

matchesUnsupportedDefine :: ExpansionError -> Bool
matchesUnsupportedDefine (UnsupportedDerivedForm CoreDefine _) = True
matchesUnsupportedDefine _ = False

matchesInvalidBindingName :: ExpansionError -> Bool
matchesInvalidBindingName (InvalidBindingName _) = True
matchesInvalidBindingName _ = False

matchesImproperApplication :: ExpansionError -> Bool
matchesImproperApplication (ImproperApplication _) = True
matchesImproperApplication _ = False

nestedApplication :: Int -> IO SExpr
nestedApplication depth = do
  f <- assertRight "atom f" (atom "f")
  x <- assertRight "atom x" (atom "x")
  pure (iterate (\expr -> list [f, expr]) x !! depth)

countAvailability :: TransitionAvailability -> Int
countAvailability expected =
  length
    [ ()
    | StageTransitionStatus _ actual <- allStageTransitionStatuses
    , actual == expected
    ]

_orderedImproper :: SExpr -> SExpr -> SExpr -> SExpr
_orderedImproper f a b =
  cons f (cons a b)
