# SECURITY.md

## Status

Bootstrap boundary.

The current implementation has no parser, evaluator, module loader, network access, filesystem access, FFI, projection output, or ambient runtime effects.

Future passes must add explicit bounds and capability checks before accepting untrusted modules or running user-defined computation.
