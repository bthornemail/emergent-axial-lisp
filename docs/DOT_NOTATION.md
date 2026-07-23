---
omino-centroid: "0x00"
omino-azimuth: "0°"
geometric-stratum: "±2: SYSTEM"
pair-surface: "Un-Nested CAR/CDR"
substrate-targets:
  declarations: "../.omi/cons.omi"
  definitions: "../.omi/AxialLisp.hs"
  binary: "../.omi/cons.o"
---
# Dot Notation - Un-Nested Pair Surface

Layer 1 represents a direct `(CAR . CDR)` wire as one fixed 32-bit value. The
lower 16 bits hold `CAR`, and the upper 16 bits hold `CDR`.

The law surface is recomposable: extracting `CAR` and `CDR` from `cons x y`
returns `x` and `y` without allocating nested list structure.
