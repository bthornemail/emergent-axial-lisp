# PORTABILITY.md

## Status

Bootstrap boundary with a documented Haskell package range.

The current implementation is pure Haskell. C99, WebAssembly, Omnicron ISA, and other target adapters are not implemented.

## Supported Compiler Range Decision

The Cabal bounds intentionally allow the current GHC 9.10 package set while
retaining the earlier bootstrap range:

- `base >= 4.17 && < 4.21`
- `bytestring >= 0.11 && < 0.13`
- `text >= 2.0 && < 2.2`
- `transformers >= 0.5 && < 0.7`

This is a supported compiler-range decision for the Haskell bootstrap surface,
not a formal compatibility proof for every package version in the range.

## Tested Package Set

Pass 3 was tested with:

- GHC 9.10.3
- `base-4.20.2.0`
- `bytestring-0.12.2.0`
- `text-2.1.3`
- `parsec-3.1.18.0`
- `transformers-0.6.1.1`

## Serialization Portability

Pass 4 canonical semantic serialization uses fixed byte tags and big-endian
multibyte integers. It does not depend on host endianness, Haskell constructor
layout, `Enum` ordinals, or `Show` output.
