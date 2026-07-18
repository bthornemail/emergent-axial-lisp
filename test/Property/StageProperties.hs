{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Property.StageProperties
  ( tests
  ) where

import Emergent.Stage
import Emergent.Stage.Transition
import MetaCons.Axis
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: stage witness reification matches independently specified stages" $ do
      terms <- sampleTerms
      assertEqual "expected observed stages" [Surface, Parsed] (map someTermStage terms)
  , TestCase "property: canonical path agrees with runtime nextStage" $
      assertEqual "path nextStage" expectedPathSuccessors (map nextStage canonicalStagePath)
  , TestCase "property: every legal transition agrees with NextStage" $
      mapM_ assertTransitionAgreesWithNextStage allStageTransitions
  , TestCase "property: transition availability has two implemented and four pending edges" $
      assertEqual
        "availability counts"
        (2, 4)
        ( countAvailability ImplementedTransition
        , countAvailability PendingTransition
        )
  , TestCase "property: no transition originates at Lowered" $
      assertBool "no lowered transition" (not (any originatesAtLowered allStageTransitions))
  , TestCase "property: existential package preserves observed stage" $ do
      terms <- sampleTerms
      assertEqual "some stages" [Surface, Parsed] (map someTermStage terms)
  ]

sampleTerms :: IO [SomeTerm]
sampleTerms = do
  let surface = surfaceForm "(a b)"
  parsed <- assertRight "parse" (parseSurface surface)
  pure
    [ SomeTerm (stageWitness surface) surface
    , SomeTerm (stageWitness parsed) parsed
    ]

expectedPathSuccessors :: [Maybe StageAxis]
expectedPathSuccessors =
  [ Just Parsed
  , Just Expanded
  , Just Typed
  , Just Normalized
  , Just Resolved
  , Just Lowered
  , Nothing
  ]

assertTransitionAgreesWithNextStage :: SomeStageTransition -> IO ()
assertTransitionAgreesWithNextStage (SomeStageTransition transition) =
  assertEqual
    "transition nextStage"
    (Just (transitionTo transition))
    (nextStage (transitionFrom transition))

originatesAtLowered :: SomeStageTransition -> Bool
originatesAtLowered (SomeStageTransition transition) =
  transitionFrom transition == Lowered

countAvailability :: TransitionAvailability -> Int
countAvailability expected =
  length
    [ ()
    | StageTransitionStatus _ actual <- allStageTransitionStatuses
    , actual == expected
    ]
