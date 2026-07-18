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

Proof Spine A is documentation-only. It records upstream theorem correspondence
but does not prove Haskell correspondence.
