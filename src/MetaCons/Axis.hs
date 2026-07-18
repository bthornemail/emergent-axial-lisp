{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}

module MetaCons.Axis
  ( ScopeAxis (..)
  , StructuralAxis (..)
  , BindingAxis (..)
  , EvalAxis (..)
  , StageAxis (..)
  , TimeAxis (..)
  , IntegrityAxis (..)
  , CarrierAxis (..)
  , ProjectionAxis (..)
  , Capability (..)
  , EvalPolicy
  , NextStage
  , Mirror
  , allScopeAxes
  , allStructuralAxes
  , allBindingAxes
  , allEvalAxes
  , allStageAxes
  , allTimeAxes
  , allIntegrityAxes
  , allCarrierAxes
  , allProjectionAxes
  , allCapabilities
  , diagnosticText
  , nextStage
  , mirrorCarrier
  ) where

import Data.Text (Text)
import qualified Data.Text as Text

data ScopeAxis = FS | GS | RS | US
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data StructuralAxis = Car | Cdr | Cons
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data BindingAxis = BCar | BCdr | APVal | APVal1 | Subr | FSubr | Expr | FExpr
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data EvalAxis = Eager | Lazy | Special | Macro | Reflective | Quoted
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data StageAxis = Surface | Parsed | Expanded | Typed | Normalized | Resolved | Lowered
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data TimeAxis = LL | MM | NN
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data IntegrityAxis = Logos | Nomos | Pathos
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data CarrierAxis = LowControl | LowAffine | HighControl | HighProjective
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data ProjectionAxis
  = NoProjection
  | CharacterProjection
  | BitboardProjection
  | CanvasProjection
  | PortProjection
  | AzimuthProjection
  deriving stock (Eq, Ord, Show, Enum, Bounded)

data Capability
  = PureCapability
  | MemoryCapability
  | StorageCapability
  | NetworkCapability
  | ClockCapability
  | ForeignCapability
  | ProjectionCapability
  deriving stock (Eq, Ord, Show, Enum, Bounded)

type family EvalPolicy (binding :: BindingAxis) :: EvalAxis where
  EvalPolicy 'Subr = 'Eager
  EvalPolicy 'Expr = 'Eager
  EvalPolicy 'FSubr = 'Special
  EvalPolicy 'FExpr = 'Special

type family NextStage (stage :: StageAxis) :: Maybe StageAxis where
  NextStage 'Surface = 'Just 'Parsed
  NextStage 'Parsed = 'Just 'Expanded
  NextStage 'Expanded = 'Just 'Typed
  NextStage 'Typed = 'Just 'Normalized
  NextStage 'Normalized = 'Just 'Resolved
  NextStage 'Resolved = 'Just 'Lowered
  NextStage 'Lowered = 'Nothing

type family Mirror (carrier :: CarrierAxis) :: CarrierAxis where
  Mirror 'LowControl = 'HighControl
  Mirror 'HighControl = 'LowControl
  Mirror 'LowAffine = 'HighProjective
  Mirror 'HighProjective = 'LowAffine

allScopeAxes :: [ScopeAxis]
allScopeAxes = [minBound .. maxBound]

allStructuralAxes :: [StructuralAxis]
allStructuralAxes = [minBound .. maxBound]

allBindingAxes :: [BindingAxis]
allBindingAxes = [minBound .. maxBound]

allEvalAxes :: [EvalAxis]
allEvalAxes = [minBound .. maxBound]

allStageAxes :: [StageAxis]
allStageAxes = [minBound .. maxBound]

allTimeAxes :: [TimeAxis]
allTimeAxes = [minBound .. maxBound]

allIntegrityAxes :: [IntegrityAxis]
allIntegrityAxes = [minBound .. maxBound]

allCarrierAxes :: [CarrierAxis]
allCarrierAxes = [minBound .. maxBound]

allProjectionAxes :: [ProjectionAxis]
allProjectionAxes = [minBound .. maxBound]

allCapabilities :: [Capability]
allCapabilities = [minBound .. maxBound]

diagnosticText :: Show axis => axis -> Text
diagnosticText = Text.pack . show

nextStage :: StageAxis -> Maybe StageAxis
nextStage Surface = Just Parsed
nextStage Parsed = Just Expanded
nextStage Expanded = Just Typed
nextStage Typed = Just Normalized
nextStage Normalized = Just Resolved
nextStage Resolved = Just Lowered
nextStage Lowered = Nothing

mirrorCarrier :: CarrierAxis -> CarrierAxis
mirrorCarrier LowControl = HighControl
mirrorCarrier HighControl = LowControl
mirrorCarrier LowAffine = HighProjective
mirrorCarrier HighProjective = LowAffine
