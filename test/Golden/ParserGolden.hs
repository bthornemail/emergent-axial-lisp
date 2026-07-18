module Golden.ParserGolden
  ( tests
  ) where

import Data.Text (Text)
import qualified Data.Text.IO as Text
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import TestHarness

tests :: [TestCase]
tests =
  [ golden "parser proper list golden" "test/Golden/Parser/proper-list.sexpr" "(a b c)"
  , golden "parser improper list golden" "test/Golden/Parser/improper-list.sexpr" "(a b . c)"
  , golden "parser quote golden" "test/Golden/Parser/quote.sexpr" "(quote form)"
  , golden
      "parser unquote-splicing golden"
      "test/Golden/Parser/unquote-splicing.sexpr"
      "(unquote-splicing form)"
  ]

golden :: String -> FilePath -> Text -> TestCase
golden name path expected =
  TestCase name $ do
    input <- Text.readFile path
    expr <- assertRight name (parseSExpr input)
    assertEqual name expected (printCanonical expr)
