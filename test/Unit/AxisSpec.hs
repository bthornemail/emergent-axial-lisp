{-# LANGUAGE OverloadedStrings #-}

module Unit.AxisSpec
  ( tests
  ) where

import Data.Text (Text)
import MetaCons.Axis
import MetaCons.Bounded
import MetaCons.Singleton
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "scope singleton reification" $
      assertEqual "scope singletons" allScopeAxes (map reifySomeScope allScopeSingletons)
  , TestCase "structural singleton reification" $
      assertEqual
        "structural singletons"
        allStructuralAxes
        (map reifySomeStructural allStructuralSingletons)
  , TestCase "binding singleton reification" $
      assertEqual "binding singletons" allBindingAxes (map reifySomeBinding allBindingSingletons)
  , TestCase "eval singleton reification" $
      assertEqual "eval singletons" allEvalAxes (map reifySomeEval allEvalSingletons)
  , TestCase "stage singleton reification" $
      assertEqual "stage singletons" allStageAxes (map reifySomeStage allStageSingletons)
  , TestCase "time singleton reification" $
      assertEqual "time singletons" allTimeAxes (map reifySomeTime allTimeSingletons)
  , TestCase "integrity singleton reification" $
      assertEqual "integrity singletons" allIntegrityAxes (map reifySomeIntegrity allIntegritySingletons)
  , TestCase "carrier singleton reification" $
      assertEqual "carrier singletons" allCarrierAxes (map reifySomeCarrier allCarrierSingletons)
  , TestCase "projection singleton reification" $
      assertEqual
        "projection singletons"
        allProjectionAxes
        (map reifySomeProjection allProjectionSingletons)
  , TestCase "capability singleton reification" $
      assertEqual
        "capability singletons"
        allCapabilities
        (map reifySomeCapability allCapabilitySingletons)
  , TestCase "diagnostic text is deterministic" $
      assertEqual "diagnostics" expectedDiagnostics actualDiagnostics
  , TestCase "runtime stage transitions cover Lowered absence" $
      assertEqual
        "stage transitions"
        [Just Parsed, Just Expanded, Just Typed, Just Normalized, Just Resolved, Just Lowered, Nothing]
        (map nextStage allStageAxes)
  , TestCase "runtime carrier mirror is involutive" $
      mapM_
        (\carrier -> assertEqual "mirror involution" carrier (mirrorCarrier (mirrorCarrier carrier)))
        allCarrierAxes
  , TestCase "ByteCoord accepts boundaries" $ do
      assertEqual "0x00" (Just 0) (byteCoordToInteger <$> mkByteCoord 0)
      assertEqual "0xFF" (Just 255) (byteCoordToInteger <$> mkByteCoord 255)
  , TestCase "ByteCoord rejects outside byte range" $ do
      assertEqual "negative byte" Nothing (mkByteCoord (-1))
      assertEqual "too-large byte" Nothing (mkByteCoord 256)
  , TestCase "Car32 and Cdr32 preserve nominal separation" $ do
      let car = mkCar32 7
          cdr = mkCdr32 7
      assertEqual "car value" 7 (car32ToWord32 car)
      assertEqual "cdr value" 7 (cdr32ToWord32 cdr)
  , TestCase "identity smart constructors reject empty text" $ do
      assertEqual "empty origin" Nothing (mkOriginId "")
      assertEqual "empty resolver" Nothing (mkResolverProfileId "")
  , TestCase "identity smart constructors preserve text" $ do
      assertEqual "origin text" (Just "RULES.o") (originIdText <$> mkOriginId "RULES.o")
      assertEqual
        "resolver text"
        (Just "profile0")
        (resolverProfileIdText <$> mkResolverProfileId "profile0")
  ]

expectedDiagnostics :: [Text]
expectedDiagnostics =
  [ "FS"
  , "GS"
  , "RS"
  , "US"
  , "Car"
  , "Cdr"
  , "Cons"
  , "BCar"
  , "BCdr"
  , "APVal"
  , "APVal1"
  , "Subr"
  , "FSubr"
  , "Expr"
  , "FExpr"
  , "Eager"
  , "Lazy"
  , "Special"
  , "Macro"
  , "Reflective"
  , "Quoted"
  , "Surface"
  , "Parsed"
  , "Expanded"
  , "Typed"
  , "Normalized"
  , "Resolved"
  , "Lowered"
  , "LL"
  , "MM"
  , "NN"
  , "Logos"
  , "Nomos"
  , "Pathos"
  , "LowControl"
  , "LowAffine"
  , "HighControl"
  , "HighProjective"
  , "NoProjection"
  , "CharacterProjection"
  , "BitboardProjection"
  , "CanvasProjection"
  , "PortProjection"
  , "AzimuthProjection"
  , "PureCapability"
  , "MemoryCapability"
  , "StorageCapability"
  , "NetworkCapability"
  , "ClockCapability"
  , "ForeignCapability"
  , "ProjectionCapability"
  ]

actualDiagnostics :: [Text]
actualDiagnostics =
  fmap diagnosticText allScopeAxes
    <> fmap diagnosticText allStructuralAxes
    <> fmap diagnosticText allBindingAxes
    <> fmap diagnosticText allEvalAxes
    <> fmap diagnosticText allStageAxes
    <> fmap diagnosticText allTimeAxes
    <> fmap diagnosticText allIntegrityAxes
    <> fmap diagnosticText allCarrierAxes
    <> fmap diagnosticText allProjectionAxes
    <> fmap diagnosticText allCapabilities

reifySomeScope :: SomeScopeAxis -> ScopeAxis
reifySomeScope (SomeScopeAxis singleton) = reifyScopeAxis singleton

reifySomeStructural :: SomeStructuralAxis -> StructuralAxis
reifySomeStructural (SomeStructuralAxis singleton) = reifyStructuralAxis singleton

reifySomeBinding :: SomeBindingAxis -> BindingAxis
reifySomeBinding (SomeBindingAxis singleton) = reifyBindingAxis singleton

reifySomeEval :: SomeEvalAxis -> EvalAxis
reifySomeEval (SomeEvalAxis singleton) = reifyEvalAxis singleton

reifySomeStage :: SomeStageAxis -> StageAxis
reifySomeStage (SomeStageAxis singleton) = reifyStageAxis singleton

reifySomeTime :: SomeTimeAxis -> TimeAxis
reifySomeTime (SomeTimeAxis singleton) = reifyTimeAxis singleton

reifySomeIntegrity :: SomeIntegrityAxis -> IntegrityAxis
reifySomeIntegrity (SomeIntegrityAxis singleton) = reifyIntegrityAxis singleton

reifySomeCarrier :: SomeCarrierAxis -> CarrierAxis
reifySomeCarrier (SomeCarrierAxis singleton) = reifyCarrierAxis singleton

reifySomeProjection :: SomeProjectionAxis -> ProjectionAxis
reifySomeProjection (SomeProjectionAxis singleton) = reifyProjectionAxis singleton

reifySomeCapability :: SomeCapability -> Capability
reifySomeCapability (SomeCapability singleton) = reifyCapability singleton
