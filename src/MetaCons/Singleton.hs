{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}

module MetaCons.Singleton
  ( SScopeAxis (..)
  , SStructuralAxis (..)
  , SBindingAxis (..)
  , SEvalAxis (..)
  , SStageAxis (..)
  , STimeAxis (..)
  , SIntegrityAxis (..)
  , SCarrierAxis (..)
  , SProjectionAxis (..)
  , SCapability (..)
  , SomeScopeAxis (..)
  , SomeStructuralAxis (..)
  , SomeBindingAxis (..)
  , SomeEvalAxis (..)
  , SomeStageAxis (..)
  , SomeTimeAxis (..)
  , SomeIntegrityAxis (..)
  , SomeCarrierAxis (..)
  , SomeProjectionAxis (..)
  , SomeCapability (..)
  , reifyScopeAxis
  , reifyStructuralAxis
  , reifyBindingAxis
  , reifyEvalAxis
  , reifyStageAxis
  , reifyTimeAxis
  , reifyIntegrityAxis
  , reifyCarrierAxis
  , reifyProjectionAxis
  , reifyCapability
  , allScopeSingletons
  , allStructuralSingletons
  , allBindingSingletons
  , allEvalSingletons
  , allStageSingletons
  , allTimeSingletons
  , allIntegritySingletons
  , allCarrierSingletons
  , allProjectionSingletons
  , allCapabilitySingletons
  ) where

import MetaCons.Axis

data SScopeAxis (axis :: ScopeAxis) where
  SFS :: SScopeAxis 'FS
  SGS :: SScopeAxis 'GS
  SRS :: SScopeAxis 'RS
  SUS :: SScopeAxis 'US

data SStructuralAxis (axis :: StructuralAxis) where
  SCar :: SStructuralAxis 'Car
  SCdr :: SStructuralAxis 'Cdr
  SCons :: SStructuralAxis 'Cons

data SBindingAxis (axis :: BindingAxis) where
  SBCar :: SBindingAxis 'BCar
  SBCdr :: SBindingAxis 'BCdr
  SAPVal :: SBindingAxis 'APVal
  SAPVal1 :: SBindingAxis 'APVal1
  SSubr :: SBindingAxis 'Subr
  SFSubr :: SBindingAxis 'FSubr
  SExpr :: SBindingAxis 'Expr
  SFExpr :: SBindingAxis 'FExpr

data SEvalAxis (axis :: EvalAxis) where
  SEager :: SEvalAxis 'Eager
  SLazy :: SEvalAxis 'Lazy
  SSpecial :: SEvalAxis 'Special
  SMacro :: SEvalAxis 'Macro
  SReflective :: SEvalAxis 'Reflective
  SQuoted :: SEvalAxis 'Quoted

data SStageAxis (axis :: StageAxis) where
  SSurface :: SStageAxis 'Surface
  SParsed :: SStageAxis 'Parsed
  SExpanded :: SStageAxis 'Expanded
  STyped :: SStageAxis 'Typed
  SNormalized :: SStageAxis 'Normalized
  SResolved :: SStageAxis 'Resolved
  SLowered :: SStageAxis 'Lowered

data STimeAxis (axis :: TimeAxis) where
  SLL :: STimeAxis 'LL
  SMM :: STimeAxis 'MM
  SNN :: STimeAxis 'NN

data SIntegrityAxis (axis :: IntegrityAxis) where
  SLogos :: SIntegrityAxis 'Logos
  SNomos :: SIntegrityAxis 'Nomos
  SPathos :: SIntegrityAxis 'Pathos

data SCarrierAxis (axis :: CarrierAxis) where
  SLowControl :: SCarrierAxis 'LowControl
  SLowAffine :: SCarrierAxis 'LowAffine
  SHighControl :: SCarrierAxis 'HighControl
  SHighProjective :: SCarrierAxis 'HighProjective

data SProjectionAxis (axis :: ProjectionAxis) where
  SNoProjection :: SProjectionAxis 'NoProjection
  SCharacterProjection :: SProjectionAxis 'CharacterProjection
  SBitboardProjection :: SProjectionAxis 'BitboardProjection
  SCanvasProjection :: SProjectionAxis 'CanvasProjection
  SPortProjection :: SProjectionAxis 'PortProjection
  SAzimuthProjection :: SProjectionAxis 'AzimuthProjection

data SCapability (capability :: Capability) where
  SPureCapability :: SCapability 'PureCapability
  SMemoryCapability :: SCapability 'MemoryCapability
  SStorageCapability :: SCapability 'StorageCapability
  SNetworkCapability :: SCapability 'NetworkCapability
  SClockCapability :: SCapability 'ClockCapability
  SForeignCapability :: SCapability 'ForeignCapability
  SProjectionCapability :: SCapability 'ProjectionCapability

data SomeScopeAxis = forall axis. SomeScopeAxis (SScopeAxis axis)
data SomeStructuralAxis = forall axis. SomeStructuralAxis (SStructuralAxis axis)
data SomeBindingAxis = forall axis. SomeBindingAxis (SBindingAxis axis)
data SomeEvalAxis = forall axis. SomeEvalAxis (SEvalAxis axis)
data SomeStageAxis = forall axis. SomeStageAxis (SStageAxis axis)
data SomeTimeAxis = forall axis. SomeTimeAxis (STimeAxis axis)
data SomeIntegrityAxis = forall axis. SomeIntegrityAxis (SIntegrityAxis axis)
data SomeCarrierAxis = forall axis. SomeCarrierAxis (SCarrierAxis axis)
data SomeProjectionAxis = forall axis. SomeProjectionAxis (SProjectionAxis axis)
data SomeCapability = forall capability. SomeCapability (SCapability capability)

reifyScopeAxis :: SScopeAxis axis -> ScopeAxis
reifyScopeAxis SFS = FS
reifyScopeAxis SGS = GS
reifyScopeAxis SRS = RS
reifyScopeAxis SUS = US

reifyStructuralAxis :: SStructuralAxis axis -> StructuralAxis
reifyStructuralAxis SCar = Car
reifyStructuralAxis SCdr = Cdr
reifyStructuralAxis SCons = Cons

reifyBindingAxis :: SBindingAxis axis -> BindingAxis
reifyBindingAxis SBCar = BCar
reifyBindingAxis SBCdr = BCdr
reifyBindingAxis SAPVal = APVal
reifyBindingAxis SAPVal1 = APVal1
reifyBindingAxis SSubr = Subr
reifyBindingAxis SFSubr = FSubr
reifyBindingAxis SExpr = Expr
reifyBindingAxis SFExpr = FExpr

reifyEvalAxis :: SEvalAxis axis -> EvalAxis
reifyEvalAxis SEager = Eager
reifyEvalAxis SLazy = Lazy
reifyEvalAxis SSpecial = Special
reifyEvalAxis SMacro = Macro
reifyEvalAxis SReflective = Reflective
reifyEvalAxis SQuoted = Quoted

reifyStageAxis :: SStageAxis axis -> StageAxis
reifyStageAxis SSurface = Surface
reifyStageAxis SParsed = Parsed
reifyStageAxis SExpanded = Expanded
reifyStageAxis STyped = Typed
reifyStageAxis SNormalized = Normalized
reifyStageAxis SResolved = Resolved
reifyStageAxis SLowered = Lowered

reifyTimeAxis :: STimeAxis axis -> TimeAxis
reifyTimeAxis SLL = LL
reifyTimeAxis SMM = MM
reifyTimeAxis SNN = NN

reifyIntegrityAxis :: SIntegrityAxis axis -> IntegrityAxis
reifyIntegrityAxis SLogos = Logos
reifyIntegrityAxis SNomos = Nomos
reifyIntegrityAxis SPathos = Pathos

reifyCarrierAxis :: SCarrierAxis axis -> CarrierAxis
reifyCarrierAxis SLowControl = LowControl
reifyCarrierAxis SLowAffine = LowAffine
reifyCarrierAxis SHighControl = HighControl
reifyCarrierAxis SHighProjective = HighProjective

reifyProjectionAxis :: SProjectionAxis axis -> ProjectionAxis
reifyProjectionAxis SNoProjection = NoProjection
reifyProjectionAxis SCharacterProjection = CharacterProjection
reifyProjectionAxis SBitboardProjection = BitboardProjection
reifyProjectionAxis SCanvasProjection = CanvasProjection
reifyProjectionAxis SPortProjection = PortProjection
reifyProjectionAxis SAzimuthProjection = AzimuthProjection

reifyCapability :: SCapability capability -> Capability
reifyCapability SPureCapability = PureCapability
reifyCapability SMemoryCapability = MemoryCapability
reifyCapability SStorageCapability = StorageCapability
reifyCapability SNetworkCapability = NetworkCapability
reifyCapability SClockCapability = ClockCapability
reifyCapability SForeignCapability = ForeignCapability
reifyCapability SProjectionCapability = ProjectionCapability

allScopeSingletons :: [SomeScopeAxis]
allScopeSingletons = [SomeScopeAxis SFS, SomeScopeAxis SGS, SomeScopeAxis SRS, SomeScopeAxis SUS]

allStructuralSingletons :: [SomeStructuralAxis]
allStructuralSingletons = [SomeStructuralAxis SCar, SomeStructuralAxis SCdr, SomeStructuralAxis SCons]

allBindingSingletons :: [SomeBindingAxis]
allBindingSingletons =
  [ SomeBindingAxis SBCar
  , SomeBindingAxis SBCdr
  , SomeBindingAxis SAPVal
  , SomeBindingAxis SAPVal1
  , SomeBindingAxis SSubr
  , SomeBindingAxis SFSubr
  , SomeBindingAxis SExpr
  , SomeBindingAxis SFExpr
  ]

allEvalSingletons :: [SomeEvalAxis]
allEvalSingletons =
  [ SomeEvalAxis SEager
  , SomeEvalAxis SLazy
  , SomeEvalAxis SSpecial
  , SomeEvalAxis SMacro
  , SomeEvalAxis SReflective
  , SomeEvalAxis SQuoted
  ]

allStageSingletons :: [SomeStageAxis]
allStageSingletons =
  [ SomeStageAxis SSurface
  , SomeStageAxis SParsed
  , SomeStageAxis SExpanded
  , SomeStageAxis STyped
  , SomeStageAxis SNormalized
  , SomeStageAxis SResolved
  , SomeStageAxis SLowered
  ]

allTimeSingletons :: [SomeTimeAxis]
allTimeSingletons = [SomeTimeAxis SLL, SomeTimeAxis SMM, SomeTimeAxis SNN]

allIntegritySingletons :: [SomeIntegrityAxis]
allIntegritySingletons = [SomeIntegrityAxis SLogos, SomeIntegrityAxis SNomos, SomeIntegrityAxis SPathos]

allCarrierSingletons :: [SomeCarrierAxis]
allCarrierSingletons =
  [ SomeCarrierAxis SLowControl
  , SomeCarrierAxis SLowAffine
  , SomeCarrierAxis SHighControl
  , SomeCarrierAxis SHighProjective
  ]

allProjectionSingletons :: [SomeProjectionAxis]
allProjectionSingletons =
  [ SomeProjectionAxis SNoProjection
  , SomeProjectionAxis SCharacterProjection
  , SomeProjectionAxis SBitboardProjection
  , SomeProjectionAxis SCanvasProjection
  , SomeProjectionAxis SPortProjection
  , SomeProjectionAxis SAzimuthProjection
  ]

allCapabilitySingletons :: [SomeCapability]
allCapabilitySingletons =
  [ SomeCapability SPureCapability
  , SomeCapability SMemoryCapability
  , SomeCapability SStorageCapability
  , SomeCapability SNetworkCapability
  , SomeCapability SClockCapability
  , SomeCapability SForeignCapability
  , SomeCapability SProjectionCapability
  ]
