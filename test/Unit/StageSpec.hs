{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Unit.StageSpec
  ( tests
  ) where

import Data.List (isInfixOf)
import qualified Data.Text as Text
import Emergent.Parser (parseSExpr)
import Emergent.Stage
import Emergent.Stage.Transition
import MetaCons.Axis
import MetaCons.Singleton (reifyStageAxis)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "stage Surface witness reifies to Surface" $
      assertEqual "surface" Surface (stageOfTerm (surfaceForm "a"))
  , TestCase "stage Parsed witness reifies to Parsed" $ do
      parsed <- parsedTerm
      assertEqual "parsed" Parsed (stageOfTerm parsed)
  , TestCase "stage public constructors establish only Surface and Parsed" $ do
      let surface = surfaceForm "(a b)"
      parsed <- assertRight "parse" (parseSurface surface)
      assertEqual "public stages" [Surface, Parsed] [stageOfTerm surface, stageOfTerm parsed]
  , TestCase "stage canonical path has seven values in exact order" $
      assertEqual
        "path"
        [Surface, Parsed, Expanded, Typed, Normalized, Resolved, Lowered]
        canonicalStagePath
  , TestCase "stage Surface parses only to Parsed" $ do
      parsed <- assertRight "parse surface" (parseSurface (surfaceForm "(a b)"))
      assertEqual "parsed stage" Parsed (stageOfTerm parsed)
  , TestCase "stage M-expression surface parses and lowers to Parsed" $ do
      parsed <- assertRight "parse M surface" (parseAndLowerMSurface (surfaceForm "CONS(a,b)"))
      expected <- assertRight "canonical" (parseSExpr "(cons a b)")
      assertEqual "M surface" expected (parsedSExpr parsed)
  , TestCase "stage transition witnesses cover exactly six edges" $
      assertEqual
        "edges"
        [ (Surface, Parsed)
        , (Parsed, Expanded)
        , (Expanded, Typed)
        , (Typed, Normalized)
        , (Normalized, Resolved)
        , (Resolved, Lowered)
        ]
        transitionEdges
  , TestCase "stage transition availability has two implemented edges and four pending edges" $ do
      assertEqual
        "implemented count"
        2
        (length (filter (== ImplementedTransition) transitionAvailabilities))
      assertEqual "pending count" 4 (length (filter (== PendingTransition) transitionAvailabilities))
      assertEqual "implemented edge" [SurfaceToParsedEdge, ParsedToExpandedEdge] implementedEdges
  , TestCase "stage Lowered has no outgoing transition" $
      assertEqual "lowered outgoing" 0 (length (outgoingTransitionsFrom Lowered))
  , TestCase "stage SomeTerm preserves its stage witness" $ do
      terms <- publicCustodyTerms
      assertEqual "some stages" [Surface, Parsed] (map someTermStage terms)
  , TestCase "stage parsed custody preserves canonical syntax structure" $ do
      parsed <- parsedTerm
      expected <- assertRight "expected" (parseSExpr "(a b)")
      assertEqual "wrapped syntax" expected (parsedSExpr parsed)
  , TestCase "stage negative compile-fail fixtures fail for expected reasons" $
      mapM_ assertCompileFail negativeFixtures
  ]

parsedTerm :: IO (Term 'Parsed)
parsedTerm =
  assertRight "parse" (parseSurface (surfaceForm "(a b)"))

publicCustodyTerms :: IO [SomeTerm]
publicCustodyTerms = do
  let surface = surfaceForm "(a b)"
  parsed <- assertRight "parse" (parseSurface surface)
  pure
    [ SomeTerm (stageWitness surface) surface
    , SomeTerm (stageWitness parsed) parsed
    ]

transitionEdges :: [(StageAxis, StageAxis)]
transitionEdges =
  map
    (\(SomeStageTransition transition) -> (transitionFrom transition, transitionTo transition))
    allStageTransitions

transitionAvailabilities :: [TransitionAvailability]
transitionAvailabilities =
  map
    (\(StageTransitionStatus _ availability) -> availability)
    allStageTransitionStatuses

data EdgeName
  = SurfaceToParsedEdge
  | ParsedToExpandedEdge
  deriving stock (Eq, Show)

implementedEdges :: [EdgeName]
implementedEdges =
  [ edgeName
  | StageTransitionStatus transition ImplementedTransition <- allStageTransitionStatuses
  , edgeName <- implementedEdgeName transition
  ]

implementedEdgeName :: StageTransition from to -> [EdgeName]
implementedEdgeName transition
  | transitionFrom transition == Surface && transitionTo transition == Parsed = [SurfaceToParsedEdge]
  | transitionFrom transition == Parsed && transitionTo transition == Expanded =
      [ParsedToExpandedEdge]
  | otherwise = []

negativeFixtures :: [(FilePath, [String])]
negativeFixtures =
  [ ("test/Negative/ParsedAsTyped.hs", ["Couldn't match type", "Parsed", "Typed"])
  , ("test/Negative/LowerParsedDirectly.hs", ["Variable not in scope", "lowerIdentity"])
  , ("test/Negative/ResolveSurface.hs", ["Variable not in scope", "resolveIdentity"])
  , ("test/Negative/ConstructResolved.hs", ["Data constructor not in scope", "ResolvedTerm"])
  , ("test/Negative/ConstructExpanded.hs", ["Data constructor not in scope", "ExpandedTerm"])
  , ("test/Negative/ConstructTyped.hs", ["Data constructor not in scope", "TypedTerm"])
  , ("test/Negative/LoweredSuccessor.hs", ["Couldn't match type", "Lowered"])
  , ("test/Negative/MixSomeTermUnchecked.hs", ["Couldn't match type", "stage", "Parsed"])
  , ("test/Negative/ImportRemovedIdentity.hs", ["Module", "does not export", "expandIdentity"])
  , ("test/Negative/CallRemovedIdentity.hs", ["Variable not in scope", "expandIdentity"])
  , ("test/Negative/AdvanceExpandedToTyped.hs", ["Variable not in scope", "elaborateIdentity"])
  , ("test/Negative/CallRemovedElaborateIdentity.hs", ["Variable not in scope", "elaborateIdentity"])
  , ("test/Negative/ParsedAsExpanded.hs", ["Couldn't match type", "Parsed", "Expanded"])
  ]

assertCompileFail :: (FilePath, [String]) -> IO ()
assertCompileFail (fixture, expectedFragments) = do
  (exitCode, _stdout, stderr) <-
    readProcessWithExitCode
      "ghc"
      [ "-fno-code"
      , "-v0"
      , "-isrc"
      , "-XDerivingStrategies"
      , "-XNamedFieldPuns"
      , "-XOverloadedStrings"
      , "-package"
      , "bytestring"
      , "-package"
      , "parsec"
      , "-package"
      , "text"
      , fixture
      ]
      ""
  assertEqual ("expected compile failure for " <> fixture) (ExitFailure 1) exitCode
  mapM_
    ( \fragment -> assertBool ("expected compiler output fragment " <> show fragment) (fragment `isInfixOf` stderr)
    )
    expectedFragments

_stageWitnessReifier :: Term stage -> StageAxis
_stageWitnessReifier = reifyStageAxis . stageWitness

_textWitness :: Text.Text
_textWitness = ""
