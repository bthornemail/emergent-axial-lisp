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
- Pass 4 canonical semantic serialization: versioned binary envelope for canonical S-expressions, closed axes, and bounded coordinate values
- Pass 5 deterministic M-expression lowering: readable `CONS`, `CAR`, `CDR`, `LIST`, and `QUOTE` forms lower to ordinary canonical S-expressions
- Pass 6 stage-indexed language pipeline: typed stage custody, legal transition witnesses, parser bridges, and compile-fail guards

Not implemented:

- Evaluator
- Macro or FEXPR system
- Axis-driven dispatch
- Semantic macro expansion
- Type elaboration
- Normalization
- Binding resolution
- Executable lowering
- Board256
- Quasigroup resolver profiles
- Reflection
- Effects
- Target lowering

## Authority Boundaries

The current code establishes tested implementation behavior for the canonical pair kernel, canonical parser, closed axis classification types, canonical semantic serialization, deterministic M-expression lowering, and stage-indexed custody.

Serialization records canonical structure but does not validate application-level meaning, accept declarations, project runtime views, or grant capabilities.

M-expression lowering is readable syntax translation only. It does not evaluate, resolve bindings, validate application semantics, or modify serialization tags.

Stage-indexed custody prevents ordinary public code from forging later stages. Pass 6 defines the complete legal stage graph, but only `Surface -> Parsed` is currently executable. Later transitions are declared and pending semantic implementations.

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
