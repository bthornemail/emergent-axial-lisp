module Emergent.Parser
  ( parseSExpr
  ) where

import Control.Monad.Trans.Class (lift)
import Data.Char (isSpace)
import Data.Functor (($>))
import Data.Text (Text)
import qualified Data.Text as Text
import Emergent.Error
  ( ParseError (..)
  , ParseErrorKind (..)
  )
import Emergent.SourceSpan (SourcePosition (..))
import Emergent.Syntax (SExpr, atom, cons, list, nil)
import Text.Parsec
  ( ParsecT
  , anyChar
  , char
  , eof
  , getInput
  , getPosition
  , getState
  , lookAhead
  , many
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

type Parser = ParsecT Text ParseState (Either ParseError)

data ParseState = ParseState
  { parseTotalLength :: Int
  , parseDepth :: Int
  }

maxAtomLength :: Int
maxAtomLength = 256

maxNestingDepth :: Int
maxNestingDepth = 1024

parseSExpr :: Text -> Either ParseError SExpr
parseSExpr input =
  case runParserT parser initialState "<input>" input of
    Left err -> Left err
    Right (Right expr) -> Right expr
    Right (Left err) ->
      Left
        ParseError
          { parseErrorPosition =
              SourcePosition
                { sourceLine = Parsec.sourceLine (Parsec.errorPos err)
                , sourceColumn = Parsec.sourceColumn (Parsec.errorPos err)
                , sourceOffset = 0
                }
          , parseErrorKind = ExpectedExpression
          , parseErrorMessage = Text.pack (show err)
          }
 where
  initialState =
    ParseState
      { parseTotalLength = Text.length input
      , parseDepth = 0
      }

  parser = do
    skipInsignificant
    empty <- atEnd
    if empty
      then parseFailure EmptyInput "empty input"
      else do
        expr <- parseExpr
        skipInsignificant
        trailing <- optionMaybe (lookAhead anyChar)
        case trailing of
          Nothing -> eof $> expr
          Just _ -> parseFailure TrailingInput "trailing input after expression"

parseExpr :: Parser SExpr
parseExpr = do
  skipInsignificant
  currentDepth <- parseDepth <$> getState
  if currentDepth > maxNestingDepth
    then parseFailure (NestingLimitExceeded maxNestingDepth) "maximum nesting depth exceeded"
    else
      parseQuoted '\''
        "quote"
        <|> parseQuoted '`' "quasiquote"
        <|> parseUnquote
        <|> parseList
        <|> parseAtom
        <?> "expression"

parseQuoted :: Char -> Text -> Parser SExpr
parseQuoted sigil name = do
  _ <- char sigil
  form <- parseRequiredExpr ("expected form after " <> name)
  makeTaggedList name form

parseUnquote :: Parser SExpr
parseUnquote = do
  _ <- char ','
  name <-
    (char '@' $> "unquote-splicing")
      <|> pure "unquote"
  form <- parseRequiredExpr ("expected form after " <> name)
  makeTaggedList name form

parseRequiredExpr :: Text -> Parser SExpr
parseRequiredExpr message = do
  skipInsignificant
  empty <- atEnd
  if empty
    then parseFailure UnexpectedEndOfInput message
    else parseExpr

parseList :: Parser SExpr
parseList = do
  _ <- char '('
  withNestedDepth $ do
    skipInsignificant
    closed <- optionMaybe (char ')')
    case closed of
      Just _ -> pure nil
      Nothing -> parseListItems []

parseListItems :: [SExpr] -> Parser SExpr
parseListItems reversedItems = do
  skipInsignificant
  next <- optionMaybe (lookAhead anyChar)
  case next of
    Nothing -> parseFailure ExpectedListClose "expected ')' before end of input"
    Just ')' -> do
      _ <- char ')'
      pure (list (reverse reversedItems))
    Just _ -> do
      dotted <- nextIsDottedMarker
      if dotted
        then parseDottedTail reversedItems
        else do
          item <- parseExpr
          parseListItems (item : reversedItems)

parseDottedTail :: [SExpr] -> Parser SExpr
parseDottedTail [] =
  parseFailure InvalidDottedList "dotted list requires at least one element before '.'"
parseDottedTail reversedItems = do
  _ <- char '.'
  skipInsignificant
  tailStart <- optionMaybe (lookAhead anyChar)
  case tailStart of
    Nothing -> parseFailure ExpectedDottedTail "expected dotted tail expression"
    Just ')' -> parseFailure ExpectedDottedTail "expected dotted tail expression"
    Just '.' -> parseFailure InvalidDottedList "dotted tail cannot start with '.'"
    Just _ -> do
      tailExpr <- parseExpr
      skipInsignificant
      closed <- optionMaybe (char ')')
      case closed of
        Nothing -> parseFailure ExpectedListClose "expected ')' after dotted tail"
        Just _ -> pure (foldr cons tailExpr (reverse reversedItems))

parseAtom :: Parser SExpr
parseAtom = do
  chars <- many1 atomChar
  let text = Text.pack chars
      len = Text.length text
  if len > maxAtomLength
    then parseFailure (AtomTooLong maxAtomLength) "atom exceeds maximum length"
    else
      if text == "NIL"
        then pure nil
        else case atom text of
          Right expr -> pure expr
          Left err -> parseFailure (InvalidAtom err) "invalid atom"

atomChar :: Parser Char
atomChar =
  noneOf (" \t\r\n()'`,;" :: String)

skipInsignificant :: Parser ()
skipInsignificant =
  skipMany (skipWhitespace <|> skipComment)

skipWhitespace :: Parser ()
skipWhitespace =
  satisfy (`elem` (" \t\r\n" :: String)) $> ()

skipComment :: Parser ()
skipComment = do
  _ <- char ';'
  _ <- many (satisfy (/= '\n'))
  pure ()

withNestedDepth :: Parser a -> Parser a
withNestedDepth action = do
  updateState (\st -> st{parseDepth = parseDepth st + 1})
  result <- action
  updateState (\st -> st{parseDepth = parseDepth st - 1})
  pure result

makeTaggedList :: Text -> SExpr -> Parser SExpr
makeTaggedList name form =
  case atom name of
    Right tag -> pure (list [tag, form])
    Left err -> parseFailure (InvalidAtom err) "invalid internal quote tag"

parseFailure :: ParseErrorKind -> Text -> Parser a
parseFailure kind message = do
  position <- currentPosition
  lift
    ( Left
        ParseError
          { parseErrorPosition = position
          , parseErrorKind = kind
          , parseErrorMessage = message
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

nextIsDottedMarker :: Parser Bool
nextIsDottedMarker = do
  input <- getInput
  pure
    ( case Text.uncons input of
        Just ('.', rest) ->
          case Text.uncons rest of
            Nothing -> True
            Just (charAfterDot, _) -> isAtomDelimiter charAfterDot
        _ -> False
    )

isAtomDelimiter :: Char -> Bool
isAtomDelimiter c =
  isSpace c || c == ')' || c == ';'
