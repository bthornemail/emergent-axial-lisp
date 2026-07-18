module Main (main) where

import qualified Golden.MExprGolden as MExprGolden
import qualified Golden.ParserGolden as ParserGolden
import qualified Golden.SerializationGolden as SerializationGolden
import qualified Property.AxisProperties as AxisProperties
import qualified Property.KernelProperties as KernelProperties
import qualified Property.MExprProperties as MExprProperties
import qualified Property.ParserRoundTrip as ParserRoundTrip
import qualified Property.SerializationProperties as SerializationProperties
import qualified Property.StageProperties as StageProperties
import TestHarness (runTests)
import qualified Unit.AxisSpec as AxisSpec
import qualified Unit.KernelSpec as KernelSpec
import qualified Unit.MExprSpec as MExprSpec
import qualified Unit.ParserSpec as ParserSpec
import qualified Unit.SerializationSpec as SerializationSpec
import qualified Unit.StageSpec as StageSpec

main :: IO ()
main =
  runTests
    ( KernelSpec.tests
        <> KernelProperties.tests
        <> AxisSpec.tests
        <> AxisProperties.tests
        <> SerializationSpec.tests
        <> SerializationProperties.tests
        <> MExprSpec.tests
        <> MExprProperties.tests
        <> StageSpec.tests
        <> StageProperties.tests
        <> ParserSpec.tests
        <> ParserRoundTrip.tests
        <> MExprGolden.tests
        <> ParserGolden.tests
        <> SerializationGolden.tests
    )
