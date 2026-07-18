# CONFORMANCE.md

## Status

Bootstrap conformance only.

## Pass 1 Tested Behavior

- `car(cons a b) = a`
- `cdr(cons a b) = b`
- structural equality distinguishes pair order
- canonical printing is deterministic
- proper and improper lists remain distinguishable

No parser conformance is claimed.
