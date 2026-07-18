module Property.KernelProperties
  ( tests
  ) where

import Data.Text (Text)
import MetaCons.Kernel
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: CAR(CONS(a,b)) = a over sample atoms" $
      mapM_ assertCarLaw samplePairs
  , TestCase "property: CDR(CONS(a,b)) = b over sample atoms" $
      mapM_ assertCdrLaw samplePairs
  , TestCase "property: proper lists inspect to their inputs" $
      mapM_ assertProperListLaw sampleLists
  , TestCase "property: canonical printing is deterministic over samples" $
      mapM_ assertPrintDeterminism sampleExprs
  , TestCase "property: pair order affects structural equality" $
      mapM_ assertPairOrder samplePairs
  ]

sampleNames :: [Text]
sampleNames = ["A", "B", "alpha", "beta-1", "+", "cons"]

sampleAtoms :: [SExpr]
sampleAtoms = either (error . show) id . atom <$> sampleNames

samplePairs :: [(SExpr, SExpr)]
samplePairs = [(left, right) | left <- sampleAtoms, right <- sampleAtoms]

sampleLists :: [[SExpr]]
sampleLists =
  [ []
  , take 1 sampleAtoms
  , take 2 sampleAtoms
  , take 3 sampleAtoms
  , sampleAtoms
  ]

sampleExprs :: [SExpr]
sampleExprs =
  [ nil
  , list (take 3 sampleAtoms)
  , cons (sampleAtoms !! 0) (sampleAtoms !! 1)
  , cons (sampleAtoms !! 0) (cons (sampleAtoms !! 1) (sampleAtoms !! 2))
  ]

assertCarLaw :: (SExpr, SExpr) -> IO ()
assertCarLaw (left, right) =
  assertEqual "CAR law" (Right left) (car (cons left right))

assertCdrLaw :: (SExpr, SExpr) -> IO ()
assertCdrLaw (left, right) =
  assertEqual "CDR law" (Right right) (cdr (cons left right))

assertProperListLaw :: [SExpr] -> IO ()
assertProperListLaw exprs =
  assertEqual "proper list law" (Just exprs) (toProperList (list exprs))

assertPrintDeterminism :: SExpr -> IO ()
assertPrintDeterminism expr =
  assertEqual "print determinism" (printCanonical expr) (printCanonical expr)

assertPairOrder :: (SExpr, SExpr) -> IO ()
assertPairOrder (left, right) =
  if left == right
    then pure ()
    else assertBool "ordered pairs must differ" (cons left right /= cons right left)
