# Proof Spine

## Purpose

The proof spine records how Emergent Axial Lisp intends to cite theorem families
from the upstream `omi-axioms` proof authority rail.

This directory is a bridge manifest only. It does not execute runtime code,
render projections, accept runtime state, or make Haskell formally verified.

## Upstream Authority

Upstream repository:

```text
git@github.com:bthornemail/omi-axioms.git
```

Pinned commit:

```text
973a9de51111a06750395f503f0cb67bc4bd3cad
```

The current local strict check passes. See `upstream/omi-axioms.lock`.

## Integration Levels

- Level 1 reference: Haskell documentation cites an upstream theorem.
- Level 2 shared vectors: Coq and Haskell consume the same finite vectors.
- Level 3 verified correspondence: a Coq specification is proved equivalent to
  extracted or mirrored implementation behavior.

Only Level 3 may be called a formally verified implementation.
