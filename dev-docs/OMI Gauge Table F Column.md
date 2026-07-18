# OMI Gauge Table, F-Column Surface, and Byte-Ring Closure

**Status:** Canonical working draft
**Layer:** notation / gauge table / proof bridge / port surface
**Scope:** OMI workbook notation, OMI-Port carrier notation, OMI-ISA witness fixtures, Coq proof alignment

---

## 1. Core Claim

OMI notation begins in the hidden control plane, crosses into readable separation at `0x20`, branches through the printable F-column surface, and closes through the Null Ring byte cycle.

The system has four linked surfaces:

```text
Pinch Point      0x00..0x1F
Gauge Control    0x1C..0x1F
Space Boundary   0x20
Branch Surface   0x1F..0x6F
Gauge Table      0x00..0x7F
Surrogate Field  0x7F..0xFF
```

The hidden control plane is:

```text
0x1C  FS   File / Frame Separator
0x1D  GS   Group / Graph Separator
0x1E  RS   Record / Relation Separator
0x1F  US   Unit / Symbol Separator
```

The printable F-column surface is:

```text
0x1F  US   hidden unit separator
0x2F  /    printable separator
0x3F  ?    witness/query separator
0x4F  O    upper/norm Omicron
0x5F  _    carrier/floor separator
0x6F  o    lower/local omicron
```

Canonical short rule:

```text
FS GS RS US are the hidden control gauges.
US / ? O _ o is the printable F-column branch.
```

---

## 2. Hidden Gauge Control and Tangential Projection

The non-printing control plane runs from:

```text
0x00..0x1F
```

It ends in the gauge quartet:

```text
0x1C  FS
0x1D  GS
0x1E  RS
0x1F  US
```

This quartet is the tangential gauge operator for the system.

It is linear in the byte table:

```text
0x00 ... 0x1C 0x1D 0x1E 0x1F
```

But when viewed through the ASCII table as a two-dimensional projection of a one-dimensional byte line, the hidden gauge quartet becomes the branch base for the printable F-column:

```text
0x1F  US
0x2F  /
0x3F  ?
0x4F  O
0x5F  _
0x6F  o
```

Thus:

```text
0x1F is the hidden unit separator.
0x2F is the first printable path separator.
0x3F is the query/witness separator.
0x4F is upper Omicron.
0x5F is the carrier floor.
0x6F is lower omicron.
```

The space byte is the hinge:

```text
0x20  SP
```

At `0x20`, the hidden control plane becomes readable separation.

---

## 3. Space, Branch, Gauge Table, and Surrogates

The system may be read as a staged byte surface:

```text
Pinch Point:
  0x00..0x1F

Gauge Control:
  0x1C..0x1F

Space:
  0x20

Branch Point:
  0x1F..0x6F

Gauge Table:
  0x00..0x7F

Interpretive Space:
  0x80

Complementary Surrogate Annotations:
  0x7F..0xFF
```

The first readable separation occurs at:

```text
0x20
```

The first deletion/seal boundary occurs at:

```text
0x7F
```

The saturated carrier horizon occurs at:

```text
0xFF
```

The interpretive midpoint above the seven-bit gauge table is:

```text
0x80
```

The local/private/public/remote interpretation of `0x80..0xFF` remains an open declarative-resolution layer. It should not be overclaimed yet.

Working placeholder:

```text
0x80..0x8F  declared frame constructions
0x90..0x9F  buffer configurations
0xA0..0xAF  attestation and scribe-facing annotations
0xB0..0xBF  escape / alias / carrier transition space
0xC0..0xFF  place-value extension and surrogate annotation space
```

Boundary:

```text
The upper byte field may annotate, surrogate, escape, or extend.
It does not automatically validate or receipt.
```

---

## 4. Omicron Resolver Envelope

The Omicron resolver envelope is parameterized by an F-band gauge:

```text
Fδ 00 1C 1D 1E 1F 20 Fδ
```

where:

```text
Fδ ∈ 0xF0..0xFF
```

The canonical closure envelope is:

```text
FF 00 1C 1D 1E 1F 20 FF
```

Meaning:

```text
Fδ   selected F-band gauge / resolver horizon
00   NUL origin
1C   FS frame boundary
1D   GS group boundary
1E   RS relation boundary / diagonal closure witness
1F   US unit boundary
20   readable space boundary
Fδ   matching resolver closure
```

Authority boundary:

```text
Omicron frames.
Omicron does not validate.
Omicron does not receipt.
```

---

## 5. OMI Notation Citation Surface

OMI notation may be written as a citation ket:

```text
|OMI---IMO>
```

or as the folded route:

```text
omi---imo
```

The transport carrier begins with:

```text
omi---imo US/
```

where `US/` means:

```text
0x1F  hidden unit separator
0x2F  printable separator
```

The printable branch alias is:

```text
?O_o
```

Therefore the compact canonical alias is:

```text
omi---imo?O_o
```

This may be read as:

```text
omi---imo
  root folded relation

?
  witness/query separator

O
  upper/norm Omicron

_
  carrier/floor separator

o
  lower/local omicron
```

Expanded relation surface:

```text
omi---imo/?---?O---O_---_o---o
```

Canonical distinction:

```text
#/ belongs to carrier compatibility syntax.
?O_o belongs to OMI-native notation.
```

---

## 6. Place-Value Cascade

The branch surface cascades through hexadecimal place-value lanes.

The compact OMI surface may begin with:

```text
omi---imo US/
```

and cascade through `?O_o` as the visible place-value branch:

```text
(0x0000, 0x1000, 0x2000, 0x3000)
(0x4000, 0x5000, 0x6000, 0x7000)
(0x8000, 0x9000, 0xA000, 0xB000)
(0xC000, 0xD000, 0xE000, 0xF000)
```

This is the high-nibble lane surface.

Interpretation:

```text
0x0000..0x3000  first quadrant / origin-facing route
0x4000..0x7000  second quadrant / printable branch route
0x8000..0xB000  interpretive/surrogate route
0xC000..0xF000  extension/escape/place-value route
```

The precise public/private/local/remote semantics of the upper quadrants should remain declarative until they are proven or implemented.

---

## 7. Null Ring and Byte-Ring Closure

The folded null seed is:

```text
(NULL . NULL)
```

The byte ring is:

```text
(0x00 . 0x20)
(0x20 . 0x7F)
(0x7F . 0xFF)
(0xFF . 0x00)
```

The dot relation is XOR:

```text
0x00 ^ 0x20 = 0x20
0x20 ^ 0x7F = 0x5F
0x7F ^ 0xFF = 0x80
0xFF ^ 0x00 = 0xFF
```

The full witness closure is:

```text
0x20 ^ 0x5F ^ 0x80 ^ 0xFF = 0x00
```

The four absences are:

```text
0x00  absence before inscription
0x20  absence inside readable text
0x7F  absence after removal
0xFF  saturated absence
```

Canonical law:

```text
The Null Ring closes because every boundary appears twice in the full cycle.
```

Expanded cancellation:

```text
0x00 ^ 0x20 ^ 0x20 ^ 0x7F ^ 0x7F ^ 0xFF ^ 0xFF ^ 0x00 = 0x00
```

---

## 8. Metatron Witness

Metatron is the attestation scribe and contrast witness.

Canonical registers:

```text
0xAA55
0x55AA
```

Binary form:

```text
0xAA55 = 10101010 01010101
0x55AA = 01010101 10101010
```

Metatron laws:

```text
0xAA55 has 8 one bits and 8 zero bits.
0x55AA has 8 one bits and 8 zero bits.
0xAA55 ^ 0x55AA = 0xFFFF.
0xAA55 ^ 0xFFFF = 0x55AA.
0x55AA ^ 0xFFFF = 0xAA55.
```

Boundary:

```text
Metatron scribes.
Metatron witnesses.
Metatron interpolates.
Metatron does not validate.
Metatron does not receipt.
```

---

## 9. Tetragrammatron Diagonal Closure

The Tetragrammatron adjudicates closure through the Polybius diagonal witness.

The nibble field is:

```text
0  1  2  3
4  5  6  7
8  9  A  B
C  D  E  F
```

The two diagonals are:

```text
D⁺ = {0, 5, A, F}
D⁻ = {3, 6, 9, C}
```

XOR closure:

```text
0 ^ 5 ^ A ^ F = 0x0
3 ^ 6 ^ 9 ^ C = 0x0
```

The full diagonal set is:

```text
D⁺ ∪ D⁻ = {0, 3, 5, 6, 9, A, C, F}
```

The complement is:

```text
K = {1, 2, 4, 7, 8, B, D, E}
```

Sum invariants:

```text
SUM(D⁺) = 0x1E
SUM(D⁻) = 0x1E
SUM(D⁺ ∪ D⁻) = 0x3C
SUM(K) = 0x3C
SUM(0..F) = 0x78
```

Thus:

```text
0x1E  relation closure witness
0x3C  centered fold witness
0x78  shifted/full system witness
```

Tetragrammatron fold laws:

```text
0x3C is the centered fold witness.
0x78 is the shifted/carry fold witness.
0x78 == (0x3C << 1) masked to 8 bits.
0x3C == (0x78 >> 1).
0x3C has 4 one bits and 4 zero bits.
0x78 has 4 one bits and 4 zero bits.
0x3C ^ 0x78 == 0x44.
```

Boundary:

```text
Tetragrammatron validates and fold-carries.
It does not project.
It does not scribe.
```

---

## 10. Tetragrammatron Polyharmonic Governor

The Tetragrammatron is also the Polyharmonic Governor.

It separates:

```text
3 clocks
4 visible offsets
5 governor modes
```

### 10.1 Three Clocks

```text
Atomic Logic Clock
Spectral Observer Clock
Cosmic Orbit Clock
```

### 10.2 Four Visible Offsets

```text
FS = 0x0001
GS = 0x0010
RS = 0x0100
US = 0x1000
```

Offset stepping:

```text
0x0001 << 4 == 0x0010
0x0010 << 4 == 0x0100
0x0100 << 4 == 0x1000
```

### 10.3 Five Governors

```text
FACTS        p = -1
RULES        p =  0
CLOSURES     p =  1
COMBINATORS  p =  2
CONS         p =  3
```

Governor order:

```text
The exponents are consecutive from -1 through 3.
RULES is the p=0 Genesis/equality pivot.
FACTS and CONS are circular inverse endpoints.
```

Readable form:

```text
FACTS ground.
RULES permit.
CLOSURES seal.
COMBINATORS compose.
CONS embodies.
```

Or in older OMI canon:

```text
Rules declare.
Facts ground.
Closures seal.
Combinators compose.
CONS reduces.
```

---

## 11. Miquel Incidence and the 11-Cell Oversight Frame

The Tetragrammatron is not merely four gauges.

It is the Miquel incidence controller generated by four gauges under open/sealed polarity.

Four gauges:

```text
FS
GS
RS
US
```

Two boundary states:

```text
sealed
open
```

This gives eight points:

```text
sealed FS
sealed GS
sealed RS
sealed US
open FS
open GS
open RS
open US
```

The six pairwise gauge planes are:

```text
FS-GS
FS-RS
FS-US
GS-RS
GS-US
RS-US
```

Miquel incidence counts:

```text
points        = 8
circles       = 6
point degree  = 3
circle degree = 4
flags         = 24
```

Balance:

```text
8 * 3 = 6 * 4 = 24
```

The oversight arithmetic is:

```text
hidden 5-cell          = 5
pairwise gauge planes  = C(4,2) = 6
oversight frame        = 5 + 6 = 11
```

Canonical sentence:

```text
5-cell hides.
6 gauge-pair planes oversee.
11-cell governs.
Projection lies.
Receipt accepts.
```

Boundary:

```text
The 5 + 6 = 11 frame is an OMI oversight arithmetic.
It is not automatically identified with the abstract regular 11-cell without an incidence-preserving proof.
```

---

## 12. Polybius Square as Invariant Set Logic

The Polybius square:

```text
0  1  2  3
4  5  6  7
8  9  A  B
C  D  E  F
```

Primary diagonal:

```text
D⁺ = {0, 5, A, F}
```

Binary:

```text
0000
0101
1010
1111
```

XOR:

```text
0000 ^ 0101 ^ 1010 ^ 1111 = 0000
```

Anti-diagonal:

```text
D⁻ = {3, 6, 9, C}
```

Binary:

```text
0011
0110
1001
1100
```

XOR:

```text
0011 ^ 0110 ^ 1001 ^ 1100 = 0000
```

Key observation:

```text
Each diagonal XORs to zero.
This is exact, byte-wide, platform-independent closure.
No floating point is involved.
```

This is non-destructive closure.

The wheel can be inspected at any stage.

The structure proves itself through exact arithmetic rather than by collapsing into a single witness bit.

---

## 13. Binary Quadratic Form

The OMI binary quadratic form is:

```text
Q(x,y) = 60x² + 16xy + 4y²
```

It separates the three major planes:

```text
4y²    Atomic Logic Clock
16xy   Spectral Observer / Bridge Plane
60x²   Cosmic Orbit Clock
```

Important arithmetic correction:

```text
60x² + 16xy + 4y²
  = 4(15x² + 4xy + y²)
```

It does not factor as:

```text
4(3x + y)(5x + y)
```

because:

```text
4(3x + y)(5x + y)
= 4(15x² + 8xy + y²)
= 60x² + 32xy + 4y²
```

The discriminant of the original form is:

```text
b² - 4ac = 16² - 4(60)(4)
          = 256 - 960
          = -704
```

Since:

```text
a = 60 > 0
discriminant < 0
```

the form is positive definite over the real plane.

Correct statement:

```text
Q(x,y) is positive definite.
It has no real linear factorization.
Its roots live in a complex/projective interpretation, not as real transition lines.
```

Boundary:

```text
The quadratic form organizes OMI plane weights.
It does not by itself prove a physical geometry.
```

---

## 14. OMI-ISA Witness Split

The executable witness fixtures should remain separated:

```text
NULL Ring:
  0x00 / 0x20 / 0x7F / 0xFF
  byte-ring closure

Tetragrammatron:
  0x1E / 0x3C / 0x78
  diagonal closure, fold-carry, polyharmonic governor

Metatron:
  0xAA55 / 0x55AA
  alternating balanced witness
```

Canonical lock:

```text
0x3C / 0x78 belongs to Tetragrammatron.
0xAA55 / 0x55AA belongs to Metatron.
0x00 / 0x20 / 0x7F / 0xFF belongs to the Null Ring.
```

---

## 15. Proof Boundary

The proof rail belongs to Coq.

The executable rail belongs to OMI-ISA.

The notation rail belongs to OMI workbook / OMI-Port.

Correct propagation:

```text
Coq proves.
Canon names.
OMI workbook notation cites.
OMI-Port routes.
OMI-Lisp may declare.
OMI-ISA witnesses.
Tetragrammatron validates.
Metatron scribes.
Receipt records.
```

C tests and OMI-ISA fixtures do not prove the mathematics.

They witness bounded executable behavior aligned with already-proven or proof-scaffolded invariants.

Boundary:

```text
No projection is authority.
No route is connection.
No notation is receipt.
No gauge is truth.
```

---

## 16. Final Canon

```text
The hidden control plane establishes place.

FS, GS, RS, and US close the pre-language gauge control line.

Space at 0x20 opens readable separation.

The F-column branches the hidden unit separator into printable notation:

US / ? O _ o

The Null Ring closes the byte cycle:

0x00 → 0x20 → 0x7F → 0xFF → 0x00

The Tetragrammatron adjudicates diagonal closure through:

0x1E, 0x3C, and 0x78

The Metatron scribes contrast through:

0xAA55 and 0x55AA

Omicron frames the resolver envelope:

Fδ 00 1C 1D 1E 1F 20 Fδ

OMI notation cites relation as:

omi---imo?O_o

Receipt alone records accepted closure.
```

Shortest form:

```text
US hides.
Slash separates.
Question witnesses.
O norms.
Underscore carries.
o localizes.

Null Ring closes.
Tetragrammatron validates.
Metatron scribes.
Omicron frames.
Receipt records.
```

