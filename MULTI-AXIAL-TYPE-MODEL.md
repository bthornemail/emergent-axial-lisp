# MULTI-AXIAL-TYPE-MODEL.md

## Status

Defined model with Pass 3 closed-axis foundation implemented.

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
