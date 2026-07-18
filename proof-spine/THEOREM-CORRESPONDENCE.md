# Theorem Correspondence

## Boundary

This file records intended correspondence between upstream Coq theorem owners and
Emergent Axial Lisp implementation areas.

It is Level 1 reference documentation unless a row explicitly states that shared
vectors or verified correspondence have been implemented.

## Correspondence Table

| Invariant | Upstream owner | Theorems | Emergent target | Level |
| --- | --- | --- | --- | --- |
| Finite collections | `FiniteBasicsEnumeratesSets.v` | `cardinal_nonnegative`, `cardinal_app`, `subset_refl`, `subset_trans` | shared finite foundations | 1 |
| Board256 input domain | `FiniteTruthTablesCountFunctions.v` | `eight_inputs_have_256_states` | `MetaCons.Bitboard` | 1 |
| Claim status discipline | `ProofStatusOrdersClaims.v` | `P0_is_strongest`, `P4_is_weakest`, `status_le_refl`, `status_le_trans` | proof-spine claim registry | 1 |
| Carrier control bands | `EarnedControlBandsEncode.v` | `visible_zero_text_is_not_machine_nul`, `earned_surface_sizes`, `pre_language_precedes_readability` | `MetaCons.Carrier` | 1 |
| Diagonal closure | `DiagonalGaugeCloses.v` | `active_byte_surface_is_240`, `delta16_width_preserving`, `delta16_deterministic` | `MetaCons.Carrier` | 1 |
| Null ring closure | `NullRingCloses.v` | `xor_self_cancels`, `byte_ring_closes_to_null`, `every_closed_path_closes` | `MetaCons.Quasigroup` | 1 |
| Tetrahedral incidence | `FiniteIncidenceBalancesFlags.v` | `tetra_incidence_equalities` | `MetaCons.Tetrahedral` | 1 |
| Miquel incidence | `MiquelIncidenceBalancesFlags.v` | `miquel_incidence_balance`, `four_gauges_have_six_pairs` | `MetaCons.Tetrahedral` | 1 |
| Quadratic projection | `BQFBridgePreservesForms.v` | `bqf_decompose` | projection specifications | 1 |
| Metric projection | `MetricProjectionPreservesBounds.v` | `OMI_SQRT3_squared`, `OMI_PHI_equals_classical_phi` | projection specifications | 1 |
| Pi projection | `PiProjectionPreservesWitnesses.v` | `omi_pi_projection_series_converges`, `OMI_PI_Equals_Real_PI`, `OMI_PI_from_incidence_equals_PI` | projection specifications | 1 |
| Atomic replay | `AtomicKernelDefinesReplay.v` | `vnext_delta_deterministic`, `vnext_replay_deterministic` | debug interpreter | 1 |
| Delta period eight | `Delta16HasExactPeriodEight.v` | `delta16_001d_has_exact_period_8` | `MetaCons.Temporal` | 1 |
| Authority boundaries | `AuthorityPipelinePreservesDecision.v` | `omnicron_framing_does_not_decide`, `metatron_interpolation_preserves_decision` | runtime authority model | 1 |
| Kernel Pi bridge | `OmiPiBridgeConnectsKernel.v` | `kernel_pi_projection_series_converges`, `kernel_pi_projection_equals_real_pi` | projection specifications | 1 |

## Current Verification Note

The pinned upstream commit is recorded, but the local `make proof-strict` check
failed because an active non-owner file contains `Abort.`. This bridge therefore
does not promote any Haskell implementation to formally verified status.
