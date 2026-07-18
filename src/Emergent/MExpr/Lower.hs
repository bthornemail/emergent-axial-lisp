module Emergent.MExpr.Lower
  ( lowerMExpr
  , parseAndLowerMExpr
  ) where

import Data.Text (Text)
import Emergent.MExpr.Error
import Emergent.MExpr.Parser (parseMExpr)
import Emergent.MExpr.Syntax
import Emergent.Syntax (SExpr, atom, list)

lowerMExpr :: MExpr -> Either MExprLowerError SExpr
lowerMExpr (MAtom name) =
  lowerAtom name
lowerMExpr (MCall operator args) =
  case operator of
    "CONS" -> lowerPrefix operator "2" "cons" 2 args
    "CAR" -> lowerPrefix operator "1" "car" 1 args
    "CDR" -> lowerPrefix operator "1" "cdr" 1 args
    "QUOTE" -> lowerPrefix operator "1" "quote" 1 args
    "LIST" -> do
      lowered <- traverse lowerMExpr args
      tag <- lowerAtom "list"
      Right (list (tag : lowered))
    _ -> Left (MExprUnknownOperator operator)

parseAndLowerMExpr :: Text -> Either MExprError SExpr
parseAndLowerMExpr source =
  case parseMExpr source of
    Left err -> Left (MExprParseFailure err)
    Right expr ->
      case lowerMExpr expr of
        Left err -> Left (MExprLowerFailure err)
        Right lowered -> Right lowered

lowerPrefix :: Text -> Text -> Text -> Int -> [MExpr] -> Either MExprLowerError SExpr
lowerPrefix operator expected canonicalName arity args =
  lowerFixed operator expected arity args $ \lowered -> do
    tag <- lowerAtom canonicalName
    Right (list (tag : lowered))

lowerFixed
  :: Text
  -> Text
  -> Int
  -> [MExpr]
  -> ([SExpr] -> Either MExprLowerError SExpr)
  -> Either MExprLowerError SExpr
lowerFixed operator expected arity args build =
  if length args == arity
    then traverse lowerMExpr args >>= build
    else incorrectArity operator expected (length args)

lowerAtom :: Text -> Either MExprLowerError SExpr
lowerAtom name =
  case atom name of
    Right expr -> Right expr
    Left err -> Left (MExprInvalidCanonicalAtom name err)

incorrectArity :: Text -> Text -> Int -> Either MExprLowerError value
incorrectArity operator expected actual =
  Left
    MExprIncorrectArity
      { mexprOperator = operator
      , mexprExpectedArity = expected
      , mexprActualArity = actual
      }
