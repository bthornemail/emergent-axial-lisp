module Main (main) where

import qualified Property.KernelProperties as KernelProperties
import qualified Property.ParserRoundTrip as ParserRoundTrip
import qualified Golden.ParserGolden as ParserGolden
import TestHarness (runTests)
import qualified Unit.KernelSpec as KernelSpec
import qualified Unit.ParserSpec as ParserSpec

main :: IO ()
main =
  runTests
    ( KernelSpec.tests
        <> KernelProperties.tests
        <> ParserSpec.tests
        <> ParserRoundTrip.tests
        <> ParserGolden.tests
    )
