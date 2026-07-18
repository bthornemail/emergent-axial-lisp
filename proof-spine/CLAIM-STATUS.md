# Claim Status

## Status Vocabulary

- `proved`: machine-checked theorem in a strict-passing proof state.
- `defined_model`: specification-level model without a formal theorem.
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
| Stage vocabulary | defined_model | implemented | tested locally | unproved |
| Legal transition graph | defined_model | implemented and tested | tested locally | unproved |
| Surface to Parsed transition | not_applicable | implemented | tested locally | unproved |
| Parsed to Expanded transition | not_applicable | implemented | tested locally | unproved |
| Expansion determinism | pending | implemented | tested locally | unproved |
| Expansion idempotence | pending | implemented | tested locally | unproved |
| Quote opacity | pending | implemented | tested locally | unproved |
| Typed custody contract | defined_model | pending | documentation_only | unproved |
| Type vocabulary | defined_model | pending | documentation_only | unproved |
| Known/Unknown/Error model | defined_model | pending | documentation_only | unproved |
| Typing judgment | defined_model | pending | documentation_only | unproved |
| Expanded to Typed transition | pending | pending | tested as unavailable | unproved |
| Type soundness | pending | pending | pending | unproved |
| Progress | pending | pending | pending | unproved |
| Preservation | pending | pending | pending | unproved |
| Later stage transition implementations | pending | pending | tested as unavailable | unproved |
| Board256 input domain | proved | pending | pending | unproved |
| Carrier bands | proved | pending | pending | unproved |
| Tetrahedral incidence | proved | pending | pending | unproved |
| Delta period eight | proved | pending | pending | unproved |
| Authority boundaries | proved | pending | pending | unproved |

## Non-Claims

The Haskell implementation is not formally verified. The proof spine records
ancestry and intended correspondence only.
