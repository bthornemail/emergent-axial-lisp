{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE StandaloneDeriving #-}

module Emergent.Stage
  ( SurfaceForm
  , ParsedForm
  , ExpandedForm
  , TypedForm
  , NormalizedForm
  , ResolvedForm
  , LoweredForm
  , Term
  , SomeTerm (..)
  , surfaceForm
  , surfaceText
  , parsedSExpr
  , expandedSExpr
  , typedSExpr
  , normalizedSExpr
  , resolvedSExpr
  , loweredSExpr
  , termSExpr
  , stageWitness
  , stageOfTerm
  , someTermStage
  , canonicalStagePath
  , parseSurface
  , parseAndLowerMSurface
  , expandParsed
  ) where

import Data.Text (Text)
import Emergent.Error (ParseError)
import Emergent.Expand.Core (expandSExpr)
import Emergent.Expand.Error (ExpansionError)
import Emergent.MExpr.Error (MExprError)
import qualified Emergent.MExpr.Lower as MExpr
import Emergent.Parser (parseSExpr)
import Emergent.Syntax (SExpr)
import MetaCons.Axis (StageAxis (..))
import MetaCons.Singleton (SStageAxis (..), reifyStageAxis)

newtype SurfaceForm = SurfaceForm Text
  deriving stock (Eq, Ord, Show)

newtype ParsedForm = ParsedForm SExpr
  deriving stock (Eq, Ord, Show)

newtype ExpandedForm = ExpandedForm SExpr
  deriving stock (Eq, Ord, Show)

newtype TypedForm = TypedForm SExpr
  deriving stock (Eq, Ord, Show)

newtype NormalizedForm = NormalizedForm SExpr
  deriving stock (Eq, Ord, Show)

newtype ResolvedForm = ResolvedForm SExpr
  deriving stock (Eq, Ord, Show)

newtype LoweredForm = LoweredForm SExpr
  deriving stock (Eq, Ord, Show)

data Term (stage :: StageAxis) where
  SurfaceTerm :: SurfaceForm -> Term 'Surface
  ParsedTerm :: ParsedForm -> Term 'Parsed
  ExpandedTerm :: ExpandedForm -> Term 'Expanded
  TypedTerm :: TypedForm -> Term 'Typed
  NormalizedTerm :: NormalizedForm -> Term 'Normalized
  ResolvedTerm :: ResolvedForm -> Term 'Resolved
  LoweredTerm :: LoweredForm -> Term 'Lowered

deriving instance Eq (Term stage)
deriving instance Show (Term stage)

data SomeTerm where
  SomeTerm :: SStageAxis stage -> Term stage -> SomeTerm

surfaceForm :: Text -> Term 'Surface
surfaceForm = SurfaceTerm . SurfaceForm

surfaceText :: Term 'Surface -> Text
surfaceText (SurfaceTerm (SurfaceForm text)) = text

parsedSExpr :: Term 'Parsed -> SExpr
parsedSExpr (ParsedTerm (ParsedForm expr)) = expr

expandedSExpr :: Term 'Expanded -> SExpr
expandedSExpr (ExpandedTerm (ExpandedForm expr)) = expr

typedSExpr :: Term 'Typed -> SExpr
typedSExpr (TypedTerm (TypedForm expr)) = expr

normalizedSExpr :: Term 'Normalized -> SExpr
normalizedSExpr (NormalizedTerm (NormalizedForm expr)) = expr

resolvedSExpr :: Term 'Resolved -> SExpr
resolvedSExpr (ResolvedTerm (ResolvedForm expr)) = expr

loweredSExpr :: Term 'Lowered -> SExpr
loweredSExpr (LoweredTerm (LoweredForm expr)) = expr

termSExpr :: Term stage -> Maybe SExpr
termSExpr (SurfaceTerm _) = Nothing
termSExpr (ParsedTerm (ParsedForm expr)) = Just expr
termSExpr (ExpandedTerm (ExpandedForm expr)) = Just expr
termSExpr (TypedTerm (TypedForm expr)) = Just expr
termSExpr (NormalizedTerm (NormalizedForm expr)) = Just expr
termSExpr (ResolvedTerm (ResolvedForm expr)) = Just expr
termSExpr (LoweredTerm (LoweredForm expr)) = Just expr

stageWitness :: Term stage -> SStageAxis stage
stageWitness (SurfaceTerm _) = SSurface
stageWitness (ParsedTerm _) = SParsed
stageWitness (ExpandedTerm _) = SExpanded
stageWitness (TypedTerm _) = STyped
stageWitness (NormalizedTerm _) = SNormalized
stageWitness (ResolvedTerm _) = SResolved
stageWitness (LoweredTerm _) = SLowered

stageOfTerm :: Term stage -> StageAxis
stageOfTerm = reifyStageAxis . stageWitness

someTermStage :: SomeTerm -> StageAxis
someTermStage (SomeTerm witness _) = reifyStageAxis witness

canonicalStagePath :: [StageAxis]
canonicalStagePath =
  [ Surface
  , Parsed
  , Expanded
  , Typed
  , Normalized
  , Resolved
  , Lowered
  ]

parseSurface :: Term 'Surface -> Either ParseError (Term 'Parsed)
parseSurface term =
  ParsedTerm . ParsedForm <$> parseSExpr (surfaceText term)

parseAndLowerMSurface :: Term 'Surface -> Either MExprError (Term 'Parsed)
parseAndLowerMSurface term =
  ParsedTerm . ParsedForm <$> MExpr.parseAndLowerMExpr (surfaceText term)

expandParsed :: Term 'Parsed -> Either ExpansionError (Term 'Expanded)
expandParsed term =
  ExpandedTerm . ExpandedForm <$> expandSExpr (parsedSExpr term)
