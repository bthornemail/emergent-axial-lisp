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

## Pass 6 Tested Behavior

- stage witnesses reify to the expected `StageAxis`
- every stage wrapper exposes the correct witness
- the canonical stage path has exactly seven values in order
- canonical surface parsing produces only `Parsed` custody
- M-expression surface parsing and lowering produces `Parsed` custody through a distinct bridge
- legal transition witnesses cover exactly six stage edges
- transition availability marks exactly two implemented edges and four pending edges after Pass 7
- `Lowered` has no outgoing transition
- `SomeTerm` preserves its stage witness
- parsed custody preserves canonical syntax structure
- compile-fail fixtures reject using `Parsed` as `Typed`, lowering `Parsed` directly, resolving `Surface`, constructing `Resolved` through public constructors, constructing a `Lowered` successor, using existential payloads without stage recovery, importing removed identity-transition functions, and calling removed identity-transition functions
- bounded property-style tests cover independently specified observed stages, `nextStage` agreement, legal-transition agreement with `NextStage`, transition availability counts, no transition from `Lowered`, and existential stage preservation

## Pass 7 Tested Behavior

- `expandSExpr` is total over the bounded sample set and returns typed expansion errors
- `expandParsed` is the only public production path to `Term 'Expanded`
- ordinary atoms and ordinary proper applications are preserved structurally
- `quote`, `if`, `lambda`, `begin`, `define`, and `set!` are recognized as core forms
- recognized core forms enforce their locked arity rules
- quoted payloads are opaque and preserve improper pair data
- malformed lambda parameters and duplicate lambda parameter names are rejected
- variable `define` is accepted, while function-definition sugar is rejected as unsupported
- improper application forms outside `quote` are rejected
- unknown proper application heads remain ordinary applications
- expansion nesting is bounded at 1024
- transition availability marks exactly two implemented edges and four pending edges
- bounded property-style tests cover determinism, idempotence, argument-order preservation, quote opacity, deterministic serialization of expanded output as a downstream observation, and implemented-edge agreement with `NextStage`
- compile-fail fixtures reject direct construction of `Expanded` and `Typed`, advancing `Expanded` to `Typed`, calling removed identity elaboration, and using `Parsed` where `Expanded` is required
- golden fixtures lock representative canonical S-expression inputs to canonical expanded output

Proof Spine A is documentation-only. It records upstream theorem correspondence
but does not prove Haskell correspondence.
