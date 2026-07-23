---
omino-centroid: "0x00"
omino-azimuth: "0°"
geometric-stratum: "Layer 1: PHYSICAL"
wire-surface: "Emergent Axial Lisp"
substrate-targets:
  definitions: "../.omi/AxialLisp.hs"
  binary: "../.omi/axial_lisp.h"
---
# Introduction - Layer 1 Physical Wire Core

This document defines the standalone Layer 1 execution wire. The layer maps
incoming fixed-width codepoints into un-nested `(CAR . CDR)` pair surfaces before
those surfaces are interpreted by Layer 2 authority lenses.

All machine-readable substrate files remain flat inside `../.omi/`, while this
visible overlay records the human-readable routing contract.
