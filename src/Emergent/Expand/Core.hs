module Emergent.Expand.Core
  ( expandSExpr
  ) where

import Data.Text (Text)
import Emergent.Expand.Error
  ( CoreForm (..)
  , ExpansionError (..)
  , maxExpansionNesting
  )
import Emergent.Syntax
  ( SExpr (..)
  , atomText
  , list
  , toProperList
  )

expandSExpr :: SExpr -> Either ExpansionError SExpr
expandSExpr = expandAtDepth 0

expandAtDepth :: Int -> SExpr -> Either ExpansionError SExpr
expandAtDepth depth expr
  | depth > maxExpansionNesting = Left (ExpansionNestingLimitExceeded depth)
  | otherwise =
      case expr of
        Nil -> Right Nil
        AtomExpr _ -> Right expr
        Pair _ _ -> expandListLike depth expr

expandListLike :: Int -> SExpr -> Either ExpansionError SExpr
expandListLike depth expr =
  case toProperList expr of
    Nothing -> Left (ImproperApplication expr)
    Just [] -> Right Nil
    Just (headExpr : operands) ->
      case recognizedCoreForm headExpr of
        Just CoreQuote -> expandQuote headExpr operands
        Just CoreIf -> expandIf depth headExpr operands
        Just CoreLambda -> expandLambda depth headExpr operands
        Just CoreBegin -> expandBegin depth headExpr operands
        Just CoreDefine -> expandDefine depth headExpr operands
        Just CoreSet -> expandSet depth headExpr operands
        Nothing -> list <$> traverse (expandAtDepth (depth + 1)) (headExpr : operands)

expandQuote :: SExpr -> [SExpr] -> Either ExpansionError SExpr
expandQuote headExpr operands =
  case operands of
    [payload] -> Right (list [headExpr, payload])
    _ -> Left (IncorrectCoreArity CoreQuote "exactly 1" (length operands))

expandIf :: Int -> SExpr -> [SExpr] -> Either ExpansionError SExpr
expandIf depth headExpr operands
  | operandCount == 2 || operandCount == 3 =
      list . (headExpr :) <$> traverse (expandAtDepth (depth + 1)) operands
  | otherwise = Left (IncorrectCoreArity CoreIf "exactly 2 or 3" operandCount)
 where
  operandCount = length operands

expandLambda :: Int -> SExpr -> [SExpr] -> Either ExpansionError SExpr
expandLambda depth headExpr operands =
  case operands of
    [parameters, body] -> do
      validateLambdaParameters parameters
      expandedBody <- expandAtDepth (depth + 1) body
      pure (list [headExpr, parameters, expandedBody])
    _ -> Left (IncorrectCoreArity CoreLambda "exactly 2" (length operands))

expandBegin :: Int -> SExpr -> [SExpr] -> Either ExpansionError SExpr
expandBegin depth headExpr operands =
  list . (headExpr :) <$> traverse (expandAtDepth (depth + 1)) operands

expandDefine :: Int -> SExpr -> [SExpr] -> Either ExpansionError SExpr
expandDefine depth headExpr operands =
  case operands of
    [name, value] -> do
      validateDefinitionName name
      expandedValue <- expandAtDepth (depth + 1) value
      pure (list [headExpr, name, expandedValue])
    _ -> Left (IncorrectCoreArity CoreDefine "exactly 2" (length operands))

expandSet :: Int -> SExpr -> [SExpr] -> Either ExpansionError SExpr
expandSet depth headExpr operands =
  case operands of
    [name, value] -> do
      validateBindingName name
      expandedValue <- expandAtDepth (depth + 1) value
      pure (list [headExpr, name, expandedValue])
    _ -> Left (IncorrectCoreArity CoreSet "exactly 2" (length operands))

validateDefinitionName :: SExpr -> Either ExpansionError ()
validateDefinitionName name =
  case name of
    AtomExpr _ -> Right ()
    Pair _ _ -> Left (UnsupportedDerivedForm CoreDefine name)
    Nil -> Left (InvalidBindingName name)

validateBindingName :: SExpr -> Either ExpansionError ()
validateBindingName name =
  case name of
    AtomExpr _ -> Right ()
    _ -> Left (InvalidBindingName name)

validateLambdaParameters :: SExpr -> Either ExpansionError ()
validateLambdaParameters parameters =
  case parameters of
    Nil -> Right ()
    AtomExpr _ -> Right ()
    Pair _ _ ->
      case toProperList parameters of
        Nothing -> Left (MalformedLambdaParameters parameters)
        Just parameterList -> validateUniqueParameterList parameters parameterList

validateUniqueParameterList :: SExpr -> [SExpr] -> Either ExpansionError ()
validateUniqueParameterList original =
  collect []
 where
  collect :: [Text] -> [SExpr] -> Either ExpansionError ()
  collect _ [] = Right ()
  collect seen (parameter : rest) =
    case parameter of
      AtomExpr atom
        | atomText atom `elem` seen -> Left (DuplicateLambdaParameter (atomText atom))
        | otherwise -> collect (atomText atom : seen) rest
      _ -> Left (MalformedLambdaParameters original)

recognizedCoreForm :: SExpr -> Maybe CoreForm
recognizedCoreForm (AtomExpr atom) =
  case atomText atom of
    "quote" -> Just CoreQuote
    "if" -> Just CoreIf
    "lambda" -> Just CoreLambda
    "begin" -> Just CoreBegin
    "define" -> Just CoreDefine
    "set!" -> Just CoreSet
    _ -> Nothing
recognizedCoreForm _ = Nothing
