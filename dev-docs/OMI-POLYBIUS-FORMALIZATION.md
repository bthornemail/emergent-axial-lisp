# OMI Polybius Governor Formalization

This note fixes the interpretation of:

```text
omi-US-RS-GS-FS--FS-GS-RS-US-imo
```

as a paired scope traversal:

```text
counter traversal: US → RS → GS → FS
forward traversal: FS → GS → RS → US
```

The formalization intentionally does **not** assign each scope symbol one universal Polybius nibble. Instead, lowering is orientation-dependent:

```text
Forward traversal → D+ = {0,5,A,F}
Counter traversal → D− = {3,6,9,C}
```

This avoids conflating scope identity with its position in a directed diagonal traversal.

## Authority split

```text
Tetragrammatron
  validates the two Polybius diagonal certificates
  XOR closure = 0x00
  each sum = 0x1E
  combined sum = 0x3C
  full wheel sum = 0x78

Metatron
  carries the balanced contrast witness
  0xAA55 XOR 0x55AA = 0xFFFF
  both words contain eight 1-bits and eight 0-bits
```

## Temporal compilation

The compact LL–MM–NN surface compiles once per scope as:

```text
S-LL-US-MM-US-NN-US-S
```

The `.o` path is the concatenation of that loop for:

```text
FS, GS, RS, US
```

The Metatron Scribe Governor is the `S = US` specialization:

```text
US-LL-US-MM-US-NN-US-US
```

## Proof boundary

The Coq file proves the finite symbolic and hexadecimal bridge only. It does not claim that the names “Tetragrammatron” and “Metatron” are derivable from XOR arithmetic. Those names and authority roles are canon-level meanings attached to distinct proved structures.

No `Axiom`, `Parameter`, or `Admitted` occurs in the module.
