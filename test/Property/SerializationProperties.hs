{-# LANGUAGE OverloadedStrings #-}

module Property.SerializationProperties
  ( tests
  ) where

import qualified Data.Text as Text
import Emergent.Syntax (SExpr, atom, cons, list, nil)
import MetaCons.Axis
import MetaCons.Bounded
import MetaCons.Serialize
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: decode(encode(expr)) = expr over serialization samples" $
      mapM_ (assertRoundTrip . CanonicalSExpr) sampleExprs
  , TestCase "property: every closed axis value round-trips" $
      mapM_ assertRoundTrip allAxisValues
  , TestCase "property: bounded coordinate samples round-trip" $
      mapM_ assertRoundTrip boundedValues
  , TestCase "property: serialization is deterministic over samples" $
      mapM_ assertDeterministic (fmap CanonicalSExpr sampleExprs <> allAxisValues <> boundedValues)
  , TestCase "property: pair order changes encoding for distinct operands" $
      assertPairOrder atomA atomB
  ]

assertRoundTrip :: CanonicalValue -> IO ()
assertRoundTrip value = do
  bytes <- assertRight "encode" (encodeCanonicalValue value)
  assertEqual "decode . encode" (Right value) (decodeCanonicalValue bytes)

assertDeterministic :: CanonicalValue -> IO ()
assertDeterministic value =
  assertEqual "deterministic" (encodeCanonicalValue value) (encodeCanonicalValue value)

assertPairOrder :: SExpr -> SExpr -> IO ()
assertPairOrder left right = do
  leftRight <- assertRight "left-right" (encodeCanonicalValue (CanonicalSExpr (cons left right)))
  rightLeft <- assertRight "right-left" (encodeCanonicalValue (CanonicalSExpr (cons right left)))
  assertBool "pair order" (leftRight /= rightLeft)

sampleExprs :: [SExpr]
sampleExprs =
  [ nil
  , atomA
  , atomB
  , cons atomA atomB
  , cons atomA (cons atomB atomC)
  , list [atomA, atomB, atomC]
  , cons atomA (list [atomB, atomC])
  , list [atomQuote, atomForm]
  ]

allAxisValues :: [CanonicalValue]
allAxisValues =
  fmap CanonicalScope allScopeAxes
    <> fmap CanonicalStructural allStructuralAxes
    <> fmap CanonicalBinding allBindingAxes
    <> fmap CanonicalEval allEvalAxes
    <> fmap CanonicalStage allStageAxes
    <> fmap CanonicalTime allTimeAxes
    <> fmap CanonicalIntegrity allIntegrityAxes
    <> fmap CanonicalCarrier allCarrierAxes
    <> fmap CanonicalProjection allProjectionAxes
    <> fmap CanonicalCapability allCapabilities

boundedValues :: [CanonicalValue]
boundedValues =
  [ CanonicalByteCoord (byteCoord 0x00)
  , CanonicalByteCoord (byteCoord 0x7f)
  , CanonicalByteCoord (byteCoord 0xff)
  , CanonicalCar32 (mkCar32 0x00000000)
  , CanonicalCar32 (mkCar32 0x12345678)
  , CanonicalCar32 (mkCar32 0xffffffff)
  , CanonicalCdr32 (mkCdr32 0x00000000)
  , CanonicalCdr32 (mkCdr32 0x12345678)
  , CanonicalCdr32 (mkCdr32 0xffffffff)
  , CanonicalOriginId (originOk "RULES.o")
  , CanonicalOriginId (originOk "FACTS.o")
  , CanonicalResolverProfileId (resolverOk "profile0")
  , CanonicalResolverProfileId (resolverOk "profile-alpha")
  ]

atomA :: SExpr
atomA = atomOk "a"

atomB :: SExpr
atomB = atomOk "b"

atomC :: SExpr
atomC = atomOk "c"

atomQuote :: SExpr
atomQuote = atomOk "quote"

atomForm :: SExpr
atomForm = atomOk "form"

atomOk :: Text.Text -> SExpr
atomOk text =
  case atom text of
    Right expr -> expr
    Left err -> error (show err)

byteCoord :: Integer -> ByteCoord
byteCoord value =
  case mkByteCoord value of
    Just coord -> coord
    Nothing -> error ("invalid byte coordinate " <> show value)

originOk :: Text.Text -> OriginId
originOk text =
  case mkOriginId text of
    Just origin -> origin
    Nothing -> error "invalid origin id"

resolverOk :: Text.Text -> ResolverProfileId
resolverOk text =
  case mkResolverProfileId text of
    Just profile -> profile
    Nothing -> error "invalid resolver profile id"
