# Emergent Axial Lisp

Emergent Axial Lisp is a homoiconic multi-axial declarative language for the Meta-CONS Runtime.

## Identity

- Language: Emergent Axial Lisp
- Subtitle: A Homoiconic Multi-Axial Declarative Language for the Meta-CONS Runtime
- Architecture: Multi-Axial Runtime Model
- Runtime: Meta-CONS Runtime
- Reflective protocol: Meta-CONS Metaobject Protocol

## Current Status

Implemented:

- Pass 0 repository foundation
- Pass 1 canonical SEXPR kernel: `NIL`, `ATOM`, `PAIR`, `cons`, `car`, `cdr`, structural equality, proper-list helpers, and deterministic canonical printing
- Pass 2 canonical S-expression parser: atoms, `NIL`, proper lists, dotted pairs, quote shorthand expansion, comments, source positions, and resource bounds
- Proof Spine A documentation bridge to pinned `omi-axioms`
- Pass 3 closed multi-axial type foundation: closed axis ADTs, singleton witnesses, type-family mappings, and bounded coordinate smart constructors

Not implemented:

- Evaluator
- Macro or FEXPR system
- Axis serialization
- Axis-driven dispatch
- Board256
- Quasigroup resolver profiles
- Reflection
- Effects
- Target lowering

## Authority Boundaries

The current code establishes tested implementation behavior for the canonical pair kernel, canonical parser, and closed axis classification types.

Projection, evaluation, validation, recovery, reflection, and host effects have no authority in this milestone because they do not exist yet.

## Repository Map

- `src/Emergent`: language-facing syntax and canonical printing
- `src/MetaCons`: runtime kernel functions over canonical pairs
- `test/Unit`: direct unit tests
- `test/Property`: bounded property-style tests
- `dev-docs`: source architectural documents and historical design material

## Build

```bash
cabal build all
cabal test all
fourmolu --mode check .
hlint .
```

`fourmolu` and `hlint` must be installed separately.

## First Milestone

The first milestone is a trustworthy homoiconic kernel:

- construct canonical dotted pairs
- print them deterministically
- recover `CAR`
- recover `CDR`
- distinguish proper and improper lists
