---
omino-centroid: "0x00"
omino-azimuth: "0°"
geometric-stratum: "±1: KERNEL"
balance-hinge: "Bit 7 OMINO"
substrate-targets:
  declarations: "../.omi/rules.omi"
  definitions: "../.omi/AxialLispCheck.hs"
  binary: "../.omi/axial_lisp_check.c"
---
# Wire Invariants - Local Verification Surface

The standalone harness checks the Layer 1 wire through four local invariants:
pair recomposition, bounded 32-bit packing, bit-7 local/remote separation, and
the five canonical substrate target names.

The same operations are mirrored by the C99 header-only adapter so the local
verification target can check both the Haskell model and the bare-metal syntax
surface.
