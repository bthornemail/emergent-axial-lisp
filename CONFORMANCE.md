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

## Pass 4 Tested Behavior

- `decode(encode(value)) = value` for canonical S-expression samples, all closed axis values, and selected bounded coordinate values
- encoding is deterministic over the bounded sample set
- pair order changes encoded bytes for distinct operands
- proper and improper lists produce distinct byte sequences
- quote-expanded forms serialize as ordinary canonical lists
- golden fixtures lock the Pass 4 magic bytes, version, tags, text lengths, big-endian integer order, and ordered pair payloads
- invalid magic, unsupported version, unknown value tags, truncated payloads, invalid UTF-8, oversized atoms, oversized identities, trailing bytes, and excessive nesting are rejected

## Pass 5 Tested Behavior

- bare M-expression identifiers lower to canonical atoms
- `CONS`, `CAR`, `CDR`, `LIST`, and `QUOTE` lower to ordinary canonical call lists
- nested calls lower recursively while preserving argument order
- recognized operators are case-sensitive
- incorrect arity returns typed lowering errors
- missing commas, missing closing parentheses, empty arguments, trailing input, oversized identifiers, excessive nesting, and excessive argument counts return typed parse errors
- bounded property-style tests cover lowering determinism, argument-order preservation, canonical parser correspondence, and deterministic serialization of lowered output as a downstream observation
- golden fixtures lock representative source M-expressions to canonical S-expression output

Proof Spine A is documentation-only. It records upstream theorem correspondence
but does not prove Haskell correspondence.
