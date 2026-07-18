module Emergent.MExpr.Parser
  ( parseMExpr
  , maxMExprIdentifierBytes
  , maxMExprNestingDepth
  , maxMExprArguments
  ) where

import Control.Monad (when)
import Control.Monad.Trans.Class (lift)
import qualified Data.ByteString as ByteString
import Data.Functor (($>))
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8)
import Emergent.MExpr.Error
import Emergent.MExpr.Syntax
import Emergent.SourceSpan (SourcePosition (..))
import Text.Parsec
  ( ParsecT
  , anyChar
  , char
  , eof
  , getInput
  , getPosition
  , getState
  , lookAhead
  , many1
  , noneOf
  , optionMaybe
  , runParserT
  , satisfy
  , skipMany
  , updateState
  , (<?>)
  , (<|>)
  )
import qualified Text.Parsec as Parsec

type Parser = ParsecT Text ParseState (Either MExprParseError)

data ParseState = ParseState
  { parseTotalLength :: Int
  , parseDepth :: Int
  }

maxMExprIdentifierBytes :: Int
maxMExprIdentifierBytes = 256

maxMExprNestingDepth :: Int
maxMExprNestingDepth = 1024

maxMExprArguments :: Int
maxMExprArguments = 256

parseMExpr :: Text -> Either MExprParseError MExpr
parseMExpr input =
  case runParserT parser initialState "<mexpr>" input of
    Left err -> Left err
    Right (Right expr) -> Right expr
    Right (Left err) ->
      Left
        MExprParseError
          { mexprParseErrorPosition =
              SourcePosition
                { sourceLine = Parsec.sourceLine (Parsec.errorPos err)
                , sourceColumn = Parsec.sourceColumn (Parsec.errorPos err)
                , sourceOffset = 0
                }
          , mexprParseErrorKind = MExprExpectedIdentifier
          , mexprParseErrorMessage = Text.pack (show err)
          }
 where
  initialState =
    ParseState
      { parseTotalLength = Text.length input
      , parseDepth = 0
      }

  parser = do
    skipWhitespace
    empty <- atEnd
    if empty
      then parseFailure MExprExpectedIdentifier "expected M-expression"
      else do
        expr <- parseExpr
        skipWhitespace
        trailing <- optionMaybe (lookAhead anyChar)
        case trailing of
          Nothing -> eof $> expr
          Just _ -> parseFailure MExprTrailingInput "trailing input after M-expression"

parseExpr :: Parser MExpr
parseExpr = do
  skipWhitespace
  currentDepth <- parseDepth <$> getState
  if currentDepth > maxMExprNestingDepth
    then
      parseFailure
        (MExprNestingLimitExceeded maxMExprNestingDepth)
        "maximum M-expression nesting depth exceeded"
    else do
      name <- parseIdentifier
      skipWhitespace
      callStart <- optionMaybe (char '(')
      case callStart of
        Nothing -> pure (MAtom name)
        Just _ -> withNestedDepth (MCall name <$> parseArguments)

parseIdentifier :: Parser Text
parseIdentifier = do
  chars <- many1 identifierChar <?> "identifier"
  let text = Text.pack chars
      byteLength = ByteString.length (encodeUtf8 text)
  if byteLength > maxMExprIdentifierBytes
    then
      parseFailure
        (MExprIdentifierExceedsBound maxMExprIdentifierBytes)
        "identifier exceeds maximum byte length"
    else pure text

identifierChar :: Parser Char
identifierChar =
  noneOf (" \t\r\n()," :: String)

parseArguments :: Parser [MExpr]
parseArguments = do
  skipWhitespace
  closed <- optionMaybe (char ')')
  case closed of
    Just _ -> pure []
    Nothing -> parseArgumentItems []

parseArgumentItems :: [MExpr] -> Parser [MExpr]
parseArgumentItems reversedArgs = do
  skipWhitespace
  next <- optionMaybe (lookAhead anyChar)
  case next of
    Nothing -> parseFailure MExprUnexpectedEndOfInput "expected argument or ')'"
    Just ',' -> parseFailure MExprEmptyArgument "empty argument"
    Just ')' -> parseFailure MExprEmptyArgument "empty argument"
    Just _ -> do
      whenArgumentLimit reversedArgs
      arg <- parseExpr
      skipWhitespace
      separator <- optionMaybe (lookAhead anyChar)
      case separator of
        Nothing -> parseFailure MExprUnexpectedEndOfInput "expected ',' or ')'"
        Just ',' -> do
          _ <- char ','
          skipWhitespace
          afterComma <- optionMaybe (lookAhead anyChar)
          case afterComma of
            Nothing -> parseFailure MExprUnexpectedEndOfInput "expected argument after ','"
            Just ')' -> parseFailure MExprEmptyArgument "empty argument"
            Just ',' -> parseFailure MExprEmptyArgument "empty argument"
            Just _ -> parseArgumentItems (arg : reversedArgs)
        Just ')' -> do
          _ <- char ')'
          pure (reverse (arg : reversedArgs))
        Just _ -> parseFailure MExprExpectedCommaOrClosingParen "expected ',' or ')'"

whenArgumentLimit :: [MExpr] -> Parser ()
whenArgumentLimit reversedArgs =
  when (length reversedArgs >= maxMExprArguments) $
    parseFailure
      (MExprArgumentLimitExceeded maxMExprArguments)
      "maximum M-expression argument count exceeded"

skipWhitespace :: Parser ()
skipWhitespace =
  skipMany (satisfy (`elem` (" \t\r\n" :: String)) $> ())

withNestedDepth :: Parser a -> Parser a
withNestedDepth action = do
  updateState (\st -> st{parseDepth = parseDepth st + 1})
  result <- action
  updateState (\st -> st{parseDepth = parseDepth st - 1})
  pure result

parseFailure :: MExprParseErrorKind -> Text -> Parser a
parseFailure kind message = do
  position <- currentPosition
  lift
    ( Left
        MExprParseError
          { mexprParseErrorPosition = position
          , mexprParseErrorKind = kind
          , mexprParseErrorMessage = message
          }
    )

currentPosition :: Parser SourcePosition
currentPosition = do
  pos <- getPosition
  total <- parseTotalLength <$> getState
  remaining <- Text.length <$> getInput
  pure
    SourcePosition
      { sourceLine = Parsec.sourceLine pos
      , sourceColumn = Parsec.sourceColumn pos
      , sourceOffset = total - remaining
      }

atEnd :: Parser Bool
atEnd =
  (lookAhead eof $> True) <|> pure False
