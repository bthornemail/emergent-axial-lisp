{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}

module Emergent.Stage.Transition
  ( StageTransition (..)
  , TransitionAvailability (..)
  , SomeStageTransition (..)
  , StageTransitionStatus (..)
  , transitionFrom
  , transitionTo
  , transitionAvailability
  , allStageTransitions
  , allStageTransitionStatuses
  , outgoingTransitionsFrom
  ) where

import MetaCons.Axis (StageAxis (..))

data StageTransition (from :: StageAxis) (to :: StageAxis) where
  SurfaceToParsed :: StageTransition 'Surface 'Parsed
  ParsedToExpanded :: StageTransition 'Parsed 'Expanded
  ExpandedToTyped :: StageTransition 'Expanded 'Typed
  TypedToNormalized :: StageTransition 'Typed 'Normalized
  NormalizedToResolved :: StageTransition 'Normalized 'Resolved
  ResolvedToLowered :: StageTransition 'Resolved 'Lowered

data TransitionAvailability
  = ImplementedTransition
  | PendingTransition
  deriving stock (Eq, Ord, Show)

data SomeStageTransition where
  SomeStageTransition :: StageTransition from to -> SomeStageTransition

data StageTransitionStatus where
  StageTransitionStatus
    :: StageTransition from to
    -> TransitionAvailability
    -> StageTransitionStatus

transitionFrom :: StageTransition from to -> StageAxis
transitionFrom transition =
  case transition of
    SurfaceToParsed -> Surface
    ParsedToExpanded -> Parsed
    ExpandedToTyped -> Expanded
    TypedToNormalized -> Typed
    NormalizedToResolved -> Normalized
    ResolvedToLowered -> Resolved

transitionTo :: StageTransition from to -> StageAxis
transitionTo transition =
  case transition of
    SurfaceToParsed -> Parsed
    ParsedToExpanded -> Expanded
    ExpandedToTyped -> Typed
    TypedToNormalized -> Normalized
    NormalizedToResolved -> Resolved
    ResolvedToLowered -> Lowered

transitionAvailability :: StageTransition from to -> TransitionAvailability
transitionAvailability transition =
  case transition of
    SurfaceToParsed -> ImplementedTransition
    ParsedToExpanded -> ImplementedTransition
    ExpandedToTyped -> PendingTransition
    TypedToNormalized -> PendingTransition
    NormalizedToResolved -> PendingTransition
    ResolvedToLowered -> PendingTransition

allStageTransitions :: [SomeStageTransition]
allStageTransitions =
  [ SomeStageTransition SurfaceToParsed
  , SomeStageTransition ParsedToExpanded
  , SomeStageTransition ExpandedToTyped
  , SomeStageTransition TypedToNormalized
  , SomeStageTransition NormalizedToResolved
  , SomeStageTransition ResolvedToLowered
  ]

allStageTransitionStatuses :: [StageTransitionStatus]
allStageTransitionStatuses =
  [ StageTransitionStatus SurfaceToParsed ImplementedTransition
  , StageTransitionStatus ParsedToExpanded ImplementedTransition
  , StageTransitionStatus ExpandedToTyped PendingTransition
  , StageTransitionStatus TypedToNormalized PendingTransition
  , StageTransitionStatus NormalizedToResolved PendingTransition
  , StageTransitionStatus ResolvedToLowered PendingTransition
  ]

outgoingTransitionsFrom :: StageAxis -> [SomeStageTransition]
outgoingTransitionsFrom stage =
  filter originatesAt allStageTransitions
 where
  originatesAt (SomeStageTransition transition) =
    transitionFrom transition == stage
