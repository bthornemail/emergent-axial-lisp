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
92fd11b01d520f650eb52ea101471455a9b65d88
```

The current local strict check failed because `coq/test_dd_show.v` contains an
active `Abort.` outside the archive. See `upstream/omi-axioms.lock`.

## Integration Levels

- Level 1 reference: Haskell documentation cites an upstream theorem.
- Level 2 shared vectors: Coq and Haskell consume the same finite vectors.
- Level 3 verified correspondence: a Coq specification is proved equivalent to
  extracted or mirrored implementation behavior.

Only Level 3 may be called a formally verified implementation.
