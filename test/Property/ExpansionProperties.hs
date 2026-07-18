{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Property.ExpansionProperties
  ( tests
  ) where

import qualified Data.ByteString as ByteString
import qualified Data.Text as Text
import Emergent.Expand (expandSExpr)
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import Emergent.Stage
import Emergent.Stage.Transition
import Emergent.Syntax (SExpr)
import MetaCons.Axis (StageAxis (Expanded, Parsed), nextStage)
import MetaCons.Serialize (encodeSExpr)
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: expansion determinism" $
      mapM_ assertExpansionDeterministic sampleSources
  , TestCase "property: expansion idempotence" $
      mapM_ assertExpansionIdempotent successfulSampleSources
  , TestCase "property: expansion preserves argument order" $ do
      left <- parse "(f a b)"
      right <- parse "(f b a)"
      expandedLeft <- assertRight "expand left" (expandSExpr left)
      expandedRight <- assertRight "expand right" (expandSExpr right)
      assertBool "ordered applications remain distinct" (expandedLeft /= expandedRight)
      assertEqual "left order" "(f a b)" (printCanonical expandedLeft)
      assertEqual "right order" "(f b a)" (printCanonical expandedRight)
  , TestCase "property: quote opacity" $ do
      quoted <- parse "(quote (if a b))"
      expanded <- assertRight "expand quoted data" (expandSExpr quoted)
      assertEqual "quoted data unchanged" "(quote (if a b))" (printCanonical expanded)
  , TestCase "property: successful expansion preserves canonical serialization deterministically" $
      mapM_ assertExpandedSerializationDeterministic successfulSampleSources
  , TestCase "property: every implemented edge agrees with legal transition graph" $
      mapM_ assertImplementedTransitionAgreesWithNextStage implementedTransitions
  , TestCase "property: exactly two transitions are executable" $
      assertEqual
        "availability counts"
        (2, 4)
        (countAvailability ImplementedTransition, countAvailability PendingTransition)
  , TestCase "property: public API does not manufacture Typed or later custody" $ do
      parsed <- assertRight "parse" (parseSurface (surfaceForm "(f a)"))
      assertEqual "parsed stage before expansion" Parsed (stageOfTerm parsed)
      assertEqual "parsed successor is expanded" (Just Expanded) (nextStage Parsed)
      assertEqual
        "typed successor remains pending metadata"
        PendingTransition
        (transitionAvailability ExpandedToTyped)
  ]

sampleSources :: [Text.Text]
sampleSources =
  successfulSampleSources
    <> [ "(if a)"
       , "(lambda (x x) body)"
       , "(f a . b)"
       , "(define (f x) body)"
       ]

successfulSampleSources :: [Text.Text]
successfulSampleSources =
  [ "a"
  , "(f a b)"
  , "(f (g a) (h b))"
  , "(quote (a . b))"
  , "(quote (if a b))"
  , "(if a b)"
  , "(if a b c)"
  , "(lambda () body)"
  , "(lambda (x y) body)"
  , "(lambda args body)"
  , "(begin)"
  , "(begin a (f b))"
  , "(define x (f a))"
  , "(set! x (g b))"
  ]

assertExpansionDeterministic :: Text.Text -> IO ()
assertExpansionDeterministic source = do
  expr <- parse source
  assertEqual
    ("deterministic " <> Text.unpack source)
    (expandSExpr expr)
    (expandSExpr expr)

assertExpansionIdempotent :: Text.Text -> IO ()
assertExpansionIdempotent source = do
  expr <- parse source
  expanded <- assertRight ("expand " <> Text.unpack source) (expandSExpr expr)
  expandedAgain <- assertRight ("expand again " <> Text.unpack source) (expandSExpr expanded)
  assertEqual ("idempotent " <> Text.unpack source) expanded expandedAgain

assertExpandedSerializationDeterministic :: Text.Text -> IO ()
assertExpandedSerializationDeterministic source = do
  expr <- parse source
  expanded <- assertRight ("expand " <> Text.unpack source) (expandSExpr expr)
  encodedA <- assertRight "encode A" (encodeSExpr expanded)
  encodedB <- assertRight "encode B" (encodeSExpr expanded)
  assertBool "encoded output non-empty" (not (ByteString.null encodedA))
  assertEqual ("serialization deterministic " <> Text.unpack source) encodedA encodedB

implementedTransitions :: [SomeStageTransition]
implementedTransitions =
  [ SomeStageTransition transition
  | StageTransitionStatus transition ImplementedTransition <- allStageTransitionStatuses
  ]

assertImplementedTransitionAgreesWithNextStage :: SomeStageTransition -> IO ()
assertImplementedTransitionAgreesWithNextStage (SomeStageTransition transition) =
  assertEqual
    "implemented transition nextStage"
    (Just (transitionTo transition))
    (nextStage (transitionFrom transition))

countAvailability :: TransitionAvailability -> Int
countAvailability expected =
  length
    [ ()
    | StageTransitionStatus _ actual <- allStageTransitionStatuses
    , actual == expected
    ]

parse :: Text.Text -> IO SExpr
parse source =
  assertRight ("parse " <> Text.unpack source) (parseSExpr source)
