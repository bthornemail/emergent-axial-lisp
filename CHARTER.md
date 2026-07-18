# CHARTER.md

## Purpose

This repository implements Emergent Axial Lisp and the Meta-CONS Runtime in ordered, tested passes.

## Current Authority

Implemented and tested behavior in this bootstrap is limited to the canonical pair kernel.

## Non-Authority

This charter does not prove mathematical theorems, validate projections, grant runtime effects, or define target-machine lowering.

## Implementation Discipline

Each pass must define its contract, add typed data and errors, implement pure behavior, add tests, run the build, and document the authority boundary before later passes begin.
