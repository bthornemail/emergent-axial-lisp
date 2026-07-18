{-# LANGUAGE OverloadedStrings #-}

module Golden.SerializationGolden
  ( tests
  ) where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Emergent.Syntax (SExpr, atom, cons, list)
import MetaCons.Axis
import MetaCons.Bounded
import MetaCons.Serialize
import TestHarness

tests :: [TestCase]
tests =
  [ golden "serialization NIL golden" "test/golden/serialization/nil.hex" (CanonicalSExpr nilExpr)
  , golden "serialization atom golden" "test/golden/serialization/atom-a.hex" (CanonicalSExpr atomA)
  , golden
      "serialization proper list golden"
      "test/golden/serialization/proper-list.hex"
      (CanonicalSExpr (list [atomA, atomB]))
  , golden
      "serialization improper list golden"
      "test/golden/serialization/improper-list.hex"
      (CanonicalSExpr (cons atomA atomB))
  , golden
      "serialization scope axis golden"
      "test/golden/serialization/scope-fs.hex"
      (CanonicalScope FS)
  , golden
      "serialization structural axis golden"
      "test/golden/serialization/structural-car.hex"
      (CanonicalStructural Car)
  , golden
      "serialization binding axis golden"
      "test/golden/serialization/binding-subr.hex"
      (CanonicalBinding Subr)
  , golden
      "serialization eval axis golden"
      "test/golden/serialization/eval-special.hex"
      (CanonicalEval Special)
  , golden
      "serialization stage axis golden"
      "test/golden/serialization/stage-resolved.hex"
      (CanonicalStage Resolved)
  , golden "serialization time axis golden" "test/golden/serialization/time-nn.hex" (CanonicalTime NN)
  , golden
      "serialization integrity axis golden"
      "test/golden/serialization/integrity-pathos.hex"
      (CanonicalIntegrity Pathos)
  , golden
      "serialization carrier axis golden"
      "test/golden/serialization/carrier-high-projective.hex"
      (CanonicalCarrier HighProjective)
  , golden
      "serialization projection axis golden"
      "test/golden/serialization/projection-azimuth.hex"
      (CanonicalProjection AzimuthProjection)
  , golden
      "serialization capability golden"
      "test/golden/serialization/capability-projection.hex"
      (CanonicalCapability ProjectionCapability)
  , golden
      "serialization ByteCoord 0x00 golden"
      "test/golden/serialization/byte-00.hex"
      (CanonicalByteCoord (byteCoord 0x00))
  , golden
      "serialization ByteCoord 0xFF golden"
      "test/golden/serialization/byte-ff.hex"
      (CanonicalByteCoord (byteCoord 0xff))
  , golden
      "serialization Car32 golden"
      "test/golden/serialization/car32-12345678.hex"
      (CanonicalCar32 (mkCar32 0x12345678))
  , golden
      "serialization Cdr32 golden"
      "test/golden/serialization/cdr32-12345678.hex"
      (CanonicalCdr32 (mkCdr32 0x12345678))
  , golden
      "serialization OriginId golden"
      "test/golden/serialization/origin-rules.hex"
      (CanonicalOriginId (originOk "RULES.o"))
  , golden
      "serialization ResolverProfileId golden"
      "test/golden/serialization/resolver-profile0.hex"
      (CanonicalResolverProfileId (resolverOk "profile0"))
  ]

golden :: String -> FilePath -> CanonicalValue -> TestCase
golden name path value =
  TestCase name $ do
    expected <- Text.strip <$> Text.readFile path
    bytes <- assertRight "encode golden" (encodeCanonicalValue value)
    assertEqual name expected (bytesToHex bytes)

nilExpr :: SExpr
nilExpr = list []

atomA :: SExpr
atomA = atomOk "a"

atomB :: SExpr
atomB = atomOk "b"

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
