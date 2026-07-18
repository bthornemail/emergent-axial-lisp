{-# LANGUAGE OverloadedStrings #-}

module Unit.SerializationSpec
  ( tests
  ) where

import Data.ByteString (ByteString)
import qualified Data.ByteString as ByteString
import qualified Data.Text as Text
import Emergent.Syntax (SExpr, atom, cons, list, nil)
import MetaCons.Axis
import MetaCons.Bounded
import MetaCons.Serialize
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "serialization NIL encoding" $
      assertRoundTrip (CanonicalSExpr nil)
  , TestCase "serialization atom encoding" $
      assertRoundTrip (CanonicalSExpr atomA)
  , TestCase "serialization pair encoding" $
      assertRoundTrip (CanonicalSExpr (cons atomA atomB))
  , TestCase "serialization nested pair encoding" $
      assertRoundTrip (CanonicalSExpr (cons atomA (cons atomB atomC)))
  , TestCase "serialization proper list encoding" $
      assertRoundTrip (CanonicalSExpr (list [atomA, atomB]))
  , TestCase "serialization improper list encoding" $
      assertRoundTrip (CanonicalSExpr (cons atomA atomB))
  , TestCase "serialization quote-expanded list encoding" $
      assertRoundTrip (CanonicalSExpr (list [atomQuote, atomForm]))
  , TestCase "serialization proper and improper lists differ" $
      assertNotEqualBytes
        "proper/improper"
        (encodeOk (CanonicalSExpr (list [atomA, atomB])))
        (encodeOk (CanonicalSExpr (cons atomA atomB)))
  , TestCase "serialization all closed axis values" $ do
      mapM_ (assertRoundTrip . CanonicalScope) allScopeAxes
      mapM_ (assertRoundTrip . CanonicalStructural) allStructuralAxes
      mapM_ (assertRoundTrip . CanonicalBinding) allBindingAxes
      mapM_ (assertRoundTrip . CanonicalEval) allEvalAxes
      mapM_ (assertRoundTrip . CanonicalStage) allStageAxes
      mapM_ (assertRoundTrip . CanonicalTime) allTimeAxes
      mapM_ (assertRoundTrip . CanonicalIntegrity) allIntegrityAxes
      mapM_ (assertRoundTrip . CanonicalCarrier) allCarrierAxes
      mapM_ (assertRoundTrip . CanonicalProjection) allProjectionAxes
      mapM_ (assertRoundTrip . CanonicalCapability) allCapabilities
  , TestCase "serialization ByteCoord boundaries" $ do
      assertRoundTrip (CanonicalByteCoord (byteCoord 0x00))
      assertRoundTrip (CanonicalByteCoord (byteCoord 0xff))
  , TestCase "serialization Car32 boundaries" $ do
      assertRoundTrip (CanonicalCar32 (mkCar32 0x00000000))
      assertRoundTrip (CanonicalCar32 (mkCar32 0xffffffff))
  , TestCase "serialization Cdr32 boundaries" $ do
      assertRoundTrip (CanonicalCdr32 (mkCdr32 0x00000000))
      assertRoundTrip (CanonicalCdr32 (mkCdr32 0xffffffff))
  , TestCase "serialization OriginId" $
      assertRoundTrip (CanonicalOriginId originRules)
  , TestCase "serialization ResolverProfileId" $
      assertRoundTrip (CanonicalResolverProfileId resolverProfile0)
  , TestCase "serialization invalid magic rejected" $
      assertErrorKind
        InvalidMagic
        (decodeCanonicalValue (ByteString.pack [0x42, 0x41, 0x44, 0x21, 0x01, 0x10, 0x00]))
  , TestCase "serialization unsupported version rejected" $
      assertErrorKind
        (UnsupportedVersion 2)
        (decodeCanonicalValue (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x02, 0x10, 0x00]))
  , TestCase "serialization unknown value tag rejected" $
      assertErrorKind
        (UnknownTag 255)
        (decodeCanonicalValue (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x01, 0xff]))
  , TestCase "serialization truncated payload rejected" $
      assertLeft
        "truncated"
        (decodeCanonicalValue (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x01, 0x10, 0x01, 0x00, 0x02, 0x61]))
  , TestCase "serialization invalid UTF-8 rejected" $
      assertErrorKind
        InvalidUtf8
        (decodeCanonicalValue (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x01, 0x10, 0x01, 0x00, 0x01, 0xff]))
  , TestCase "serialization oversized atom rejected" $
      assertLeft "oversized atom" (encodeCanonicalValue (CanonicalSExpr oversizedAtom))
  , TestCase "serialization oversized identity rejected" $
      assertLeft "oversized identity" (encodeCanonicalValue (CanonicalOriginId oversizedOrigin))
  , TestCase "serialization trailing bytes rejected" $
      assertErrorKind
        (TrailingBytes 1)
        (decodeCanonicalValue (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x01, 0x10, 0x00, 0xff]))
  , TestCase "serialization excessive nesting rejected" $
      assertErrorKind
        (NestingLimitExceeded maxSerializedNesting)
        ( decodeCanonicalValue
            (ByteString.pack [0x45, 0x41, 0x4c, 0x53, 0x01, 0x10] <> ByteString.replicate 1025 0x02)
        )
  ]

assertRoundTrip :: CanonicalValue -> IO ()
assertRoundTrip value = do
  encoded <- assertRight "encode" (encodeCanonicalValue value)
  assertEqual "round-trip" (Right value) (decodeCanonicalValue encoded)

assertErrorKind :: SerializeErrorKind -> Either SerializeError value -> IO ()
assertErrorKind expected result =
  case result of
    Left SerializeError{serializeErrorKind} -> assertEqual "error kind" expected serializeErrorKind
    Right _ -> fail "expected serialization error"

assertNotEqualBytes :: String -> ByteString -> ByteString -> IO ()
assertNotEqualBytes label left right =
  assertBool label (left /= right)

encodeOk :: CanonicalValue -> ByteString
encodeOk value =
  case encodeCanonicalValue value of
    Right bytes -> bytes
    Left err -> error (show err)

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

oversizedAtom :: SExpr
oversizedAtom = atomOk (Text.replicate 257 "a")

originRules :: OriginId
originRules = originOk "RULES.o"

resolverProfile0 :: ResolverProfileId
resolverProfile0 = resolverOk "profile0"

oversizedOrigin :: OriginId
oversizedOrigin = originOk (Text.replicate 257 "o")

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
