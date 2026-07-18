{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Property.AxisProperties
  ( tests
  ) where

import Data.Maybe (isJust)
import Data.Proxy (Proxy (..))
import MetaCons.Axis
import MetaCons.Bounded
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: runtime mirror is involutive for all carriers" $
      mapM_ assertMirrorInvolution allCarrierAxes
  , TestCase "property: Mirror(Mirror c) type family is involutive for all carriers" $ do
      assertTypeEqual "LowControl" (mirrorLowControl Proxy) (Proxy @'LowControl)
      assertTypeEqual "LowAffine" (mirrorLowAffine Proxy) (Proxy @'LowAffine)
      assertTypeEqual "HighControl" (mirrorHighControl Proxy) (Proxy @'HighControl)
      assertTypeEqual "HighProjective" (mirrorHighProjective Proxy) (Proxy @'HighProjective)
  , TestCase "property: EvalPolicy maps ordinary functions to Eager" $ do
      assertTypeEqual "Subr -> Eager" (Proxy @(EvalPolicy 'Subr)) (Proxy @'Eager)
      assertTypeEqual "Expr -> Eager" (Proxy @(EvalPolicy 'Expr)) (Proxy @'Eager)
  , TestCase "property: EvalPolicy maps special forms to Special" $ do
      assertTypeEqual "FSubr -> Special" (Proxy @(EvalPolicy 'FSubr)) (Proxy @'Special)
      assertTypeEqual "FExpr -> Special" (Proxy @(EvalPolicy 'FExpr)) (Proxy @'Special)
  , TestCase "property: NextStage covers lawful transitions and Lowered has no successor" $ do
      assertTypeEqual "Surface -> Parsed" (Proxy @(NextStage 'Surface)) (Proxy @('Just 'Parsed))
      assertTypeEqual "Parsed -> Expanded" (Proxy @(NextStage 'Parsed)) (Proxy @('Just 'Expanded))
      assertTypeEqual "Expanded -> Typed" (Proxy @(NextStage 'Expanded)) (Proxy @('Just 'Typed))
      assertTypeEqual "Typed -> Normalized" (Proxy @(NextStage 'Typed)) (Proxy @('Just 'Normalized))
      assertTypeEqual "Normalized -> Resolved" (Proxy @(NextStage 'Normalized)) (Proxy @('Just 'Resolved))
      assertTypeEqual "Resolved -> Lowered" (Proxy @(NextStage 'Resolved)) (Proxy @('Just 'Lowered))
      assertTypeEqual "Lowered -> Nothing" (Proxy @(NextStage 'Lowered)) (Proxy @'Nothing)
  , TestCase "property: ByteCoord accepts exactly sampled byte domain" $
      mapM_ assertByteSample [-1, 0, 1, 127, 255, 256]
  ]

assertMirrorInvolution :: CarrierAxis -> IO ()
assertMirrorInvolution carrier =
  assertEqual "runtime mirror involution" carrier (mirrorCarrier (mirrorCarrier carrier))

assertByteSample :: Integer -> IO ()
assertByteSample n
  | n >= 0 && n <= 255 = assertBool "valid byte" (isJust (mkByteCoord n))
  | otherwise = assertEqual "invalid byte" Nothing (mkByteCoord n)

mirrorLowControl
  :: Proxy (Mirror (Mirror 'LowControl))
  -> Proxy 'LowControl
mirrorLowControl = id

mirrorLowAffine
  :: Proxy (Mirror (Mirror 'LowAffine))
  -> Proxy 'LowAffine
mirrorLowAffine = id

mirrorHighControl
  :: Proxy (Mirror (Mirror 'HighControl))
  -> Proxy 'HighControl
mirrorHighControl = id

mirrorHighProjective
  :: Proxy (Mirror (Mirror 'HighProjective))
  -> Proxy 'HighProjective
mirrorHighProjective = id

assertTypeEqual :: String -> Proxy (a :: k) -> Proxy a -> IO ()
assertTypeEqual _ _ _ = pure ()
