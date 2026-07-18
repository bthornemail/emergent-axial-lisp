{-# LANGUAGE OverloadedStrings #-}

module Golden.ExpansionGolden
  ( tests
  ) where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Emergent.Expand (expandSExpr)
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import TestHarness

tests :: [TestCase]
tests =
  [ golden "expansion atom golden" "atom"
  , golden "expansion ordinary application golden" "ordinary-application"
  , golden "expansion quote golden" "quote"
  , golden "expansion quoted improper pair golden" "quoted-improper"
  , golden "expansion if two operands golden" "if-two"
  , golden "expansion if three operands golden" "if-three"
  , golden "expansion lambda golden" "lambda"
  , golden "expansion begin golden" "begin"
  , golden "expansion define golden" "define"
  , golden "expansion set! golden" "set"
  , golden "expansion nested application golden" "nested-application"
  ]

golden :: String -> FilePath -> TestCase
golden name stem =
  TestCase name $ do
    source <- Text.strip <$> Text.readFile ("test/golden/expand/" <> stem <> ".source.sexpr")
    expected <- Text.strip <$> Text.readFile ("test/golden/expand/" <> stem <> ".expanded.sexpr")
    parsed <- assertRight ("parse source " <> name) (parseSExpr source)
    expanded <- assertRight ("expand " <> name) (expandSExpr parsed)
    assertEqual name expected (printCanonical expanded)
