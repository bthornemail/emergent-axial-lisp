module Property.ParserRoundTrip
  ( tests
  ) where

import Data.Text (Text)
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import MetaCons.Kernel (SExpr, atom, cons, list, nil)
import TestHarness

tests :: [TestCase]
tests =
  [ TestCase "property: parse(printCanonical(ast)) = ast over samples" $
      mapM_ assertCanonicalRoundTrip sampleExprs
  , TestCase "property: quote shorthand round-trips through expanded canonical print" $
      mapM_ assertShorthandExpansion shorthandSamples
  ]

sampleExprs :: [SExpr]
sampleExprs =
  [ nil
  , a "alpha"
  , cons (a "left") (a "right")
  , list [a "A", a "B", a "C"]
  , cons (a "A") (cons (a "B") (a "C"))
  , list [a "quote", a "form"]
  , list [a "unquote-splicing", list [a "xs"]]
  ]

shorthandSamples :: [(Text, Text)]
shorthandSamples =
  [ ("'form", "(quote form)")
  , ("`form", "(quasiquote form)")
  , (",form", "(unquote form)")
  , (",@form", "(unquote-splicing form)")
  ]

assertCanonicalRoundTrip :: SExpr -> IO ()
assertCanonicalRoundTrip expr =
  assertEqual
    "parse(printCanonical(ast))"
    (Right expr)
    (parseSExpr (printCanonical expr))

assertShorthandExpansion :: (Text, Text) -> IO ()
assertShorthandExpansion (input, expectedPrint) = do
  expr <- assertRight "shorthand parse" (parseSExpr input)
  assertEqual "expanded print" expectedPrint (printCanonical expr)
  assertEqual "expanded round-trip" (Right expr) (parseSExpr (printCanonical expr))

a :: Text -> SExpr
a text =
  case atom text of
    Right expr -> expr
    Left err -> error ("invalid sample atom: " <> show err)
