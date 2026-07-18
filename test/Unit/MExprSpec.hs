{-# LANGUAGE OverloadedStrings #-}

module Unit.MExprSpec
  ( tests
  ) where

import Data.Text (Text)
import qualified Data.Text as Text
import Emergent.MExpr
import Emergent.Parser (parseSExpr)
import Emergent.Printer (printCanonical)
import TestHarness

tests :: [TestCase]
tests =
  [ lowerCase "MExpr atom" "a" "a"
  , lowerCase "MExpr CONS" "CONS(a, b)" "(cons a b)"
  , lowerCase "MExpr CAR" "CAR(x)" "(car x)"
  , lowerCase "MExpr CDR" "CDR(x)" "(cdr x)"
  , lowerCase "MExpr empty LIST" "LIST()" "(list)"
  , lowerCase "MExpr multiple LIST" "LIST(a, b, c)" "(list a b c)"
  , lowerCase "MExpr QUOTE" "QUOTE(x)" "(quote x)"
  , lowerCase "MExpr nested calls" "CAR(CONS(a, b))" "(car (cons a b))"
  , lowerCase "MExpr whitespace" "  CONS ( a ,  b ) " "(cons a b)"
  , lowerCase "MExpr ordered arguments" "CONS(CAR(x), CDR(y))" "(cons (car x) (cdr y))"
  , lowerError "MExpr incorrect CONS arity" "CONS(a)" (MExprIncorrectArity "CONS" "2" 1)
  , lowerError "MExpr incorrect CAR arity" "CAR(a, b)" (MExprIncorrectArity "CAR" "1" 2)
  , lowerError "MExpr incorrect CDR arity" "CDR()" (MExprIncorrectArity "CDR" "1" 0)
  , lowerError "MExpr incorrect QUOTE arity" "QUOTE(a, b)" (MExprIncorrectArity "QUOTE" "1" 2)
  , parseError "MExpr missing comma" "CONS(a b)" MExprExpectedCommaOrClosingParen
  , parseError "MExpr missing closing parenthesis" "CONS(a, b" MExprUnexpectedEndOfInput
  , parseError "MExpr empty argument" "CONS(a,)" MExprEmptyArgument
  , parseError "MExpr trailing input" "a b" MExprTrailingInput
  , lowerError "MExpr unknown operator is typed" "Cons(a,b)" (MExprUnknownOperator "Cons")
  , parseError
      "MExpr oversized identifier"
      (Text.replicate 257 "a")
      (MExprIdentifierExceedsBound maxMExprIdentifierBytes)
  , parseError
      "MExpr excessive nesting"
      excessiveNesting
      (MExprNestingLimitExceeded maxMExprNestingDepth)
  , parseError
      "MExpr excessive argument count"
      excessiveArguments
      (MExprArgumentLimitExceeded maxMExprArguments)
  ]

lowerCase :: String -> Text -> Text -> TestCase
lowerCase name source expectedCanonical =
  TestCase name $ do
    lowered <- assertRight name (parseAndLowerMExpr source)
    expected <- assertRight (name <> " canonical") (parseSExpr expectedCanonical)
    assertEqual name expected lowered
    assertEqual (name <> " print") expectedCanonical (printCanonical lowered)

lowerError :: String -> Text -> MExprLowerError -> TestCase
lowerError name source expected =
  TestCase name $
    case parseAndLowerMExpr source of
      Left (MExprLowerFailure actual) -> assertEqual name expected actual
      other -> fail ("expected lowering error, got " <> show other)

parseError :: String -> Text -> MExprParseErrorKind -> TestCase
parseError name source expected =
  TestCase name $
    case parseMExpr source of
      Left MExprParseError{mexprParseErrorKind} -> assertEqual name expected mexprParseErrorKind
      other -> fail ("expected parse error, got " <> show other)

excessiveNesting :: Text
excessiveNesting =
  Text.replicate 1025 "CAR(" <> "x" <> Text.replicate 1025 ")"

excessiveArguments :: Text
excessiveArguments =
  "LIST(" <> Text.intercalate "," (replicate 257 "a") <> ")"
