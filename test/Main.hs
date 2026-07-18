module Main (main) where

import qualified Property.KernelProperties as KernelProperties
import TestHarness (runTests)
import qualified Unit.KernelSpec as KernelSpec

main :: IO ()
main =
  runTests (KernelSpec.tests <> KernelProperties.tests)
