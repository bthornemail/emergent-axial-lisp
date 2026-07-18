# CONFORMANCE.md

## Status

Bootstrap conformance only.

## Pass 1 Tested Behavior

- `car(cons a b) = a`
- `cdr(cons a b) = b`
- structural equality distinguishes pair order
- canonical printing is deterministic
- proper and improper lists remain distinguishable

## Pass 2 Tested Behavior

- canonical parser accepts atoms, `NIL`, proper lists, improper lists, dotted pairs, quote shorthand, quasiquote shorthand, unquote shorthand, unquote-splicing shorthand, and line comments
- shorthand lowers immediately to ordinary canonical lists
- canonical parser rejects invalid dotted syntax, trailing forms, empty input, overlong atoms, and excessive nesting
- parse errors carry line, column, and offset

## Pass 3 Tested Behavior

- every closed-axis singleton reifies to its runtime axis value
- every closed axis has deterministic diagnostic text
- carrier mirror is involutive for all four carrier classes
- `Subr` and `Expr` map to `Eager`
- `FSubr` and `FExpr` map to `Special`
- lawful stage transitions are represented and `Lowered` has no successor
- `ByteCoord` accepts `0x00` through `0xFF` and rejects values outside that range
- `Car32` and `Cdr32` remain nominally distinct
- identity smart constructors reject empty identifiers

Proof Spine A is documentation-only. It records upstream theorem correspondence
but does not prove Haskell correspondence.
