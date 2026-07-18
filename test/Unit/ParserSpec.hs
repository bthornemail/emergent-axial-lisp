module Unit.ParserSpec
  ( tests
  ) where

import Data.Text (Text)
import qualified Data.Text as Text
import Emergent.Error (AtomError (..), ParseError (..), ParseErrorKind (..))
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import Emergent.SourceSpan (SourcePosition (..))
import MetaCons.Kernel (SExpr, atom, cons)
import TestHarness

tests :: [TestCase]
tests =
  [ parsesToPrint "NIL parses" "NIL" "NIL"
  , parsesToPrint "atom parses" "alpha" "alpha"
  , parsesToPrint "dotted pair parses" "(a . b)" "(a . b)"
  , parsesToPrint "proper list parses" "(a b c)" "(a b c)"
  , parsesToPrint "improper list parses" "(a b . c)" "(a b . c)"
  , parsesToPrint "quote expands" "'form" "(quote form)"
  , parsesToPrint "quasiquote expands" "`form" "(quasiquote form)"
  , parsesToPrint "unquote expands" ",form" "(unquote form)"
  , parsesToPrint "unquote-splicing expands" ",@form" "(unquote-splicing form)"
  , parsesToPrint "comments are skipped" " ; leading\n(a ; mid\n b)" "(a b)"
  , parsesToPrint "nested lists parse" "(a (b . c) NIL)" "(a (b . c) NIL)"
  , TestCase "parser emits kernel structure" $ do
      expected <- pair "a" "b"
      expr <- assertRight "parser emits kernel structure" (parseSExpr "(a . b)")
      assertEqual "parser emits kernel structure" expected expr
  , failsWith "empty input fails" "" EmptyInput
  , failsWith "trailing input fails" "a b" TrailingInput
  , failsWith "bare dot fails" "." (InvalidAtom ReservedDotAtom)
  , failsWith "double dot fails" "(a . . b)" InvalidDottedList
  , failsWith "missing close paren fails" "(a b" ExpectedListClose
  , failsWith "dotted list without tail fails" "(a .)" ExpectedDottedTail
  , failsWith "unquote-splicing without form fails" ",@" UnexpectedEndOfInput
  , TestCase "overlong atom fails" $
      assertParseKind
        (AtomTooLong 256)
        (parseSExpr (Text.replicate 257 "a"))
  , TestCase "excessive nesting fails" $
      assertParseKind
        (NestingLimitExceeded 1024)
        (parseSExpr (Text.replicate 1025 "(" <> "a" <> Text.replicate 1025 ")"))
  , TestCase "parse errors include source position" $
      case parseSExpr "a\nb" of
        Left err ->
          assertEqual "trailing position" 2 (sourceLineOf err)
        Right expr ->
          fail ("expected parse error, got " <> show expr)
  ]

parsesToPrint :: String -> Text -> Text -> TestCase
parsesToPrint name input expected =
  TestCase name $ do
    expr <- assertRight name (parseSExpr input)
    assertEqual name expected (printCanonical expr)

failsWith :: String -> Text -> ParseErrorKind -> TestCase
failsWith name input expected =
  TestCase name $
    assertParseKind expected (parseSExpr input)

assertParseKind :: ParseErrorKind -> Either ParseError SExpr -> IO ()
assertParseKind expected result =
  case result of
    Left err -> assertEqual "parse error kind" expected (parseErrorKind err)
    Right expr -> fail ("expected parse failure, got " <> show expr)

pair :: Text -> Text -> IO SExpr
pair left right = do
  leftExpr <- mustAtom left
  rightExpr <- mustAtom right
  pure (cons leftExpr rightExpr)

mustAtom :: Text -> IO SExpr
mustAtom text =
  case atom text of
    Right expr -> pure expr
    Left err -> fail ("invalid test atom: " <> show err)

sourceLineOf :: ParseError -> Int
sourceLineOf ParseError{parseErrorPosition} =
  sourceLine parseErrorPosition
