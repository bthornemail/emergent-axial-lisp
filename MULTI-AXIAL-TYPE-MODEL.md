# MULTI-AXIAL-TYPE-MODEL.md

## Status

Defined model with Pass 3 closed-axis foundation implemented and Pass 8 typed
custody specified.

The Multi-Axial Runtime Model owns axis definitions, legal coordinate combinations, dispatch rules, resolver profiles, recovery laws, and authority boundaries.

## Pass 3 Implemented Surface

Pass 3 introduces closed trusted-core coordinates for:

- scope
- structure
- binding
- evaluation policy
- stage
- time
- integrity
- carrier class
- projection class
- capability class

The implementation uses closed Haskell ADTs, promoted with `DataKinds`, and
handwritten singleton witnesses for runtime reification at future extension
boundaries.

## Type-Level Relations

Implemented type families:

- `EvalPolicy`: maps `Subr` and `Expr` to `Eager`, and `FSubr` and `FExpr` to `Special`
- `NextStage`: represents lawful stage successors as `Just next`, with `Lowered` mapped to `Nothing`
- `Mirror`: maps `LowControl` with `HighControl`, and `LowAffine` with `HighProjective`

## Bounded Values

Pass 3 adds hidden-constructor smart types for:

- `ByteCoord`
- `Car32`
- `Cdr32`
- `OriginId`
- `ResolverProfileId`

## Non-Authority

These types classify coordinates only. Pass 3 does not implement evaluation,
dispatch, validation, serialization, Hamming parity, carrier byte operations,
recovery, projection, or reflection.

## Pass 4 Serialization Boundary

Pass 4 adds canonical binary tags for the closed axis values. Those tags record
which closed coordinate was serialized. They do not add dispatch behavior,
validation authority, projection authority, or carrier byte operations.

## Pass 6 Stage Custody Boundary

`StageAxis` is the closed vocabulary of stages. A stage-indexed `Term stage` is
a separate value that carries custody evidence for one stage.

The existence of a constructor such as `Resolved` in `StageAxis` does not
authorize ordinary public code to construct a resolved-stage term.

Pass 6 adds typed transition witnesses for the legal stage edges and hides
later-stage term constructors. Pass 6A hardens the authority boundary. Pass 7
implements the `Parsed -> Expanded` semantic edge, so the currently executable
edges are `Surface -> Parsed` and `Parsed -> Expanded`. All later edges remain
declared as pending semantic implementations.

The legal transition graph is metadata and type evidence. A legal edge does not
attest that its semantic obligation has been discharged. The stage model does
not implement macro expansion, type elaboration, normalization, binding
resolution, executable lowering, validation, projection, or effects.

Expanded custody means the Pass 7 core-expansion postcondition has been
checked: recognized core forms have proper shape and valid arity, improper
applications outside `quote` are rejected, quoted data is opaque, and expansion
is deterministic and idempotent over the tested bounded samples.

## Pass 8 Typed Custody Boundary

`StageAxis 'Typed` is a coordinate in the closed stage vocabulary. It is not
itself evidence that a value has discharged type-analysis obligations.

Future `Term 'Typed` custody must be earned by structured type evidence, not by
attaching a stage label to an unexamined `SExpr`. That evidence must preserve
the expanded source correspondence, per-node known or unknown type evidence,
symbolic typing assumptions, function arity, mutation/effect obligations, and
the typing-rules version.

Type evidence is distinct from binding resolution, module linkage, storage
location identity, effect authorization, runtime validation, evaluation, and
formal semantic proof. A typed term may contain unresolved symbolic names and
explicit Unknown evidence. It may not contain unresolved type contradictions.

`Expanded -> Typed` remains a pending transition implementation.
