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

Not implemented:

- Parser
- Evaluator
- Macro or FEXPR system
- Axes
- Board256
- Quasigroup resolver profiles
- Reflection
- Effects
- Target lowering

## Authority Boundaries

The current code establishes tested implementation behavior for the canonical pair kernel only.

Projection, parsing, evaluation, validation, recovery, reflection, and host effects have no authority in this milestone because they do not exist yet.

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
