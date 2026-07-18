# Claim Status

## Status Vocabulary

- `proved`: machine-checked theorem in a strict-passing proof state.
- `implemented`: Haskell behavior exists.
- `tested`: behavior is covered by local tests.
- `pending`: planned but not implemented.
- `documentation_only`: recorded as a proof-spine bridge, with no runtime code.
- `unproved`: no cross-language correspondence proof exists.

## Current Claims

| Area | Theorem status | Haskell status | Vector status | Correspondence status |
| --- | --- | --- | --- | --- |
| Parser | not_applicable | implemented | tested locally | unproved |
| Canonical pair kernel | not_applicable | implemented | tested locally | unproved |
| Canonical serialization | not_applicable | implemented | tested locally | unproved |
| M-expression lowering | pending | implemented | tested locally | unproved |
| Board256 input domain | proved | pending | pending | unproved |
| Carrier bands | proved | pending | pending | unproved |
| Tetrahedral incidence | proved | pending | pending | unproved |
| Delta period eight | proved | pending | pending | unproved |
| Authority boundaries | proved | pending | pending | unproved |

## Non-Claims

The Haskell implementation is not formally verified. The proof spine records
ancestry and intended correspondence only.
