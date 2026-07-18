module Main (main) where

import qualified Golden.ParserGolden as ParserGolden
import qualified Property.AxisProperties as AxisProperties
import qualified Property.KernelProperties as KernelProperties
import qualified Property.ParserRoundTrip as ParserRoundTrip
import TestHarness (runTests)
import qualified Unit.AxisSpec as AxisSpec
import qualified Unit.KernelSpec as KernelSpec
import qualified Unit.ParserSpec as ParserSpec

main :: IO ()
main =
  runTests
    ( KernelSpec.tests
        <> KernelProperties.tests
        <> AxisSpec.tests
        <> AxisProperties.tests
        <> ParserSpec.tests
        <> ParserRoundTrip.tests
        <> ParserGolden.tests
    )
