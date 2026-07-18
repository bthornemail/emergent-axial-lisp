# Claim Status

## Status Vocabulary

- `proved`: machine-checked theorem in a strict-passing proof state.
- `upstream_indexed_proved`: listed as proved by the upstream proof index, but
  the local lock did not complete strict verification.
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
| Board256 input domain | upstream_indexed_proved | pending | pending | unproved |
| Carrier bands | upstream_indexed_proved | pending | pending | unproved |
| Tetrahedral incidence | upstream_indexed_proved | pending | pending | unproved |
| Delta period eight | upstream_indexed_proved | pending | pending | unproved |
| Authority boundaries | upstream_indexed_proved | pending | pending | unproved |

## Non-Claims

The Haskell implementation is not formally verified. The proof spine records
ancestry and intended correspondence only.
