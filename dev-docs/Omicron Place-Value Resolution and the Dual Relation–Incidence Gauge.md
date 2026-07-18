# Omicron Place-Value Resolution and the Dual Relation–Incidence Gauge

## Generalized “Up To” Resolution, Quadratic Folding, Factorial Orbits, and Receipt Placement

## Status

Canonical integration doctrine.

---

# 1. The Central Correction

The generalized-mean-ing ladder does not state how many total functions, objects, or runtime states exist.

It specifies the maximum place-value resolution admitted by a notation at a selected order.

The correct reading is:

```text
p selects an upper resolution bound.

All lower place-value spans remain available.

The selected span is therefore “up to p,”
not “exactly and only p.”
```

Formally, let `Pₚ` be the place-value span assigned to order `p`.

Then the resolver domain is:

[
R_p=\bigcup_{k\le p}P_k
]

The order `p` therefore acts as a ceiling:

```text
resolve up to this place-value depth
```

not:

```text
allocate exactly this many states
```

This is why generalized-mean terminology fits the system: the order controls how far the notation may be resolved along the ruler.

---

# 2. The Place-Value Ladder

For nonnegative order `p`, the notation span doubles in hexadecimal digits:

[
\operatorname{nibbles}(p)=2^p
]

Since one hexadecimal digit is four bits:

[
\operatorname{bits}(p)=4\cdot2^p
]

Therefore:

|   Order | Maximum span | Bit width | Inclusive interval                       |
| ------: | -----------: | --------: | ---------------------------------------- |
| `p = 0` |     1 nibble |    4 bits | `0x0..0xF`                               |
| `p = 1` |    2 nibbles |    8 bits | `0x00..0xFF`                             |
| `p = 2` |    4 nibbles |   16 bits | `0x0000..0xFFFF`                         |
| `p = 3` |    8 nibbles |   32 bits | `0x00000000..0xFFFFFFFF`                 |
| `p = 4` |   16 nibbles |   64 bits | `0x0000000000000000..0xFFFFFFFFFFFFFFFF` |

The important word is **maximum**.

At `p=3`, the resolver may inspect:

```text
4-bit notation
8-bit notation
16-bit notation
32-bit notation
```

It does not lose the lower spans merely because the current ceiling is 32 bits.

Canonical rule:

```text
Resolution is cumulative.

Higher order includes lower readable spans.
```

---

# 3. The `p = -1` Pre-Resolution Clause

The negative order is not half of a state.

It is the inverse-facing or pre-resolution condition beneath ordinary place-value notation.

```text
p = -1
pre-resolution, inverse, reversal, mask, or escape condition
```

It may describe:

```text
declared maximum length

reverse traversal

mask boundary

escape sequence

COBS-CONS framing inversion

high-to-low ruler reading
```

Thus:

```text
2^-1
```

is a scale marker indicating that resolution has not yet entered the ordinary one-nibble place-value field.

A suitable formal interpretation is:

[
R_{-1}=\text{declared envelope or inverse traversal rule}
]

while:

[
R_0=\text{first concrete hexadecimal place}
]

---

# 4. The Zero-Polynomial Notation

At order zero:

```text
p = 0
maximum width = one hexadecimal digit
```

This is the first complete local notation place.

The OMI zero-polynomial form:

```text
omi---imo US/?O_o
```

is the normalized notation read at this first concrete place-value resolution.

It is not numerically identical to every value in `0x0..0xF`.

Rather:

```text
0x0..0xF
is the carrier interval

omi---imo US/?O_o
is the normalized zero-polynomial notation
resolved through that interval
```

Canonical distinction:

```text
carrier width is numeric

notation form is grammatical

resolution binds the two
```

---

# 5. CONS as Bounded Resolution

The CONS pair remains:

```text
(CAR . CDR)
```

For place-value resolution:

```text
CAR
the notation currently carried

CDR
the continuation law and maximum resolution bound
```

Therefore:

[
\operatorname{CONS}_p
=====================

(\operatorname{CAR}\ .\ \operatorname{CDR}_{\le p})
]

The CDR does not merely name a next object.

It declares:

```text
how far the current notation may continue

which lower spans are included

which orbit dialect governs traversal

where resolution must stop
```

A precise implementation model is:

```c
typedef struct {
    int8_t order;
    uint16_t max_nibbles;
    uint16_t max_bits;
    bool cumulative;
} ConsResolutionBound;
```

For `p=3`:

```c
{
    .order = 3,
    .max_nibbles = 8,
    .max_bits = 32,
    .cumulative = true
}
```

---

# 6. The Omicron Circular Slide Ruler

Omicron provides the bounded low gauge:

```text
0x00..0x7F
```

divided into four 32-position sectors:

```text
0x00..0x1F
0x20..0x3F
0x40..0x5F
0x60..0x7F
```

The same sector may be read under multiple lawful partitions because the slide ruler is not only a character table.

It is a scoped resolver.

The selected partition determines which invariant is being measured.

This produces the critical dual reading:

```text
Tetragrammatron relation scope

Metatron incidence scope
```

Neither invalidates the other.

They are two resolver configurations over the same circular sector.

---

# 7. Metatron’s 28+4 Incidence Partition

For sector base:

[
B\in{0x00,0x20,0x40,0x60}
]

Metatron reads:

```text
(B . B+0x1B)
(B+0x1C . B+0x1F)
```

This divides the sector into:

```text
28-position body

4-position gauge hinge
```

For the first sector:

```text
(0x00 . 0x1B)
(0x1C . 0x1F)
```

The endpoint XOR is:

[
0x00\oplus0x1B\oplus0x1C\oplus0x1F=0x18
]

The same invariant survives all four sector bases:

```text
0x20 XOR 0x3B XOR 0x3C XOR 0x3F = 0x18

0x40 XOR 0x5B XOR 0x5C XOR 0x5F = 0x18

0x60 XOR 0x7B XOR 0x7C XOR 0x7F = 0x18
```

Thus:

```text
0x18 = 24 = 4!
```

This is the Metatron incidence reading.

It resolves:

```text
four gauges

open/sealed polarity

six gauge-pair circles

twenty-four incidence flags

hexadecimal place stepping
```

Canonical statement:

```text
The 28+4 partition exposes gauge incidence.

Its invariant is 0x18.
```

---

# 8. Tetragrammatron’s 27+5 Relation Partition

Tetragrammatron reads the same sector as:

```text
(B . B+0x1A)
(B+0x1B . B+0x1F)
```

This divides the sector into:

```text
27-position relation body

5-position relation-mode tail
```

For the first sector:

```text
(0x00 . 0x1A)
(0x1B . 0x1F)
```

The endpoint XOR is:

[
0x00\oplus0x1A\oplus0x1B\oplus0x1F=0x1E
]

Again, this survives every sector translation:

```text
0x20 XOR 0x3A XOR 0x3B XOR 0x3F = 0x1E

0x40 XOR 0x5A XOR 0x5B XOR 0x5F = 0x1E

0x60 XOR 0x7A XOR 0x7B XOR 0x7F = 0x1E
```

The five-position tail may carry the five relation modes:

```text
FACTS
RULES
CLOSURES
COMBINATORS
CONS
```

Canonical statement:

```text
The 27+5 partition exposes relation mode and closure.

Its invariant is 0x1E.
```

---

# 9. The Dual-Scope Omicron Sector

The same 32-position sector therefore has two canonical decompositions:

| Authority       | Partition |                Tail | Witness | Role      |
| --------------- | --------: | ------------------: | ------: | --------- |
| Metatron        |  `28 + 4` |         four gauges |  `0x18` | incidence |
| Tetragrammatron |  `27 + 5` | five relation modes |  `0x1E` | closure   |

This is not a conflict.

It is the reason the Omicron table functions as a circular slide ruler.

```text
The ruler remains fixed.

The resolver window changes.

The selected window exposes a different invariant.
```

Canonical lock:

```text
Metatron reads the four-gauge hinge.

Tetragrammatron reads the five-mode tail.
```

---

# 10. The Quadratic Forms Are the Same Fold at Different Resolutions

The three supplied forms are:

[
Q(x,y)=60x^2+16xy+4y^2
]

[
15x^2=4x^2+11x^2
]

and:

[
Q(x,y)=4(4x^2+11x^2+4xy+y^2)
]

Expanding the third form gives:

[
4(4x^2+11x^2+4xy+y^2)
]

[
=16x^2+44x^2+16xy+4y^2
]

[
=60x^2+16xy+4y^2
]

Therefore:

[
60x^2+16xy+4y^2
===============

4(15x^2+4xy+y^2)
]

with:

[
15x^2=4x^2+11x^2
]

So the quadratic form admits the decomposition:

```text
4x²
local tetrahedral or four-gauge contribution

11x²
orientation/signing contribution

4xy
crossing or bridge contribution

y²
local dialect seed
```

and the outer factor `4` lifts this local decomposition into the completed gauge shell.

---

# 11. Meaning of the Quadratic Terms

The integrated reading is:

```text
4x²
four-position local gauge basis

11x²
orientation and signing extension

4xy
bridge between gauge family and dialect

y²
local orbit-offset self-term
```

The completed form is:

```text
Q(x,y)
=
4(
  four-gauge basis
  +
  eleven-orientation contribution
  +
  crossing bridge
  +
  local dialect seed
)
```

Expanded:

```text
Q(x,y)
=
60x² + 16xy + 4y²
```

Canonical authority boundary:

```text
11x² signs or orients.

11x² does not validate.

11x² does not accept.

Validation and receipt accept.
```

---

# 12. The `F*` Gauge Row

The canonical gauge notation is:

```text
0xF*
```

where:

```text
F
is the family or meta-initiator

*
is the dialect or orbit offset
```

Thus:

```text
F0
F1
F2
...
FF
```

select members of one gauge family.

The high nibble `F` establishes the family.

The low nibble supplies the local dialect.

This is analogous to a combination field:

```text
the prefix establishes the decoding regime

the remaining position selects the member inside it
```

Canonical statement:

```text
0xF* is not one value.

It is a sixteen-position gauge row.
```

---

# 13. The Canonical Binary Shebang

The sequence is:

```text
FF 00 1C 1D 1E 1F 20 FF
```

Its roles are:

```text
FF
enter F* gauge or escape family

00
NULL origin

1C
FS gauge hinge

1D
GS gauge hinge

1E
RS / relation witness position

1F
US tangent hinge

20
readable-space entry

FF
close, return, or re-enter escape family
```

It may occur:

```text
at stream initiation

at an embedded escape boundary

at orbit synchronization

at dialect switching
```

Therefore:

```text
the same byte sequence can be a shebang at the boundary

or an escape marker inside a stream
```

Its meaning depends on framing scope.

---

# 14. The Period-8 Derivation

The delta law produces a fixed-width bounded rotation with period:

```text
8
```

The smallest prime whose decimal reciprocal has period eight is:

```text
73
```

Its repeating block is:

```text
1/73 = 0.01369863 01369863 ...
```

Therefore:

```text
B = [0,1,3,6,9,8,6,3]
```

and:

[
W=\sum B
]

[
W=0+1+3+6+9+8+6+3=36
]

Thus:

```text
period = 8

prime = 73

block = 01369863

block weight = 36
```

Base36 provides a visible single-place label space for this weight.

This derivation gives the gauge a reproducible periodic witness rather than an arbitrary label convention.

---

# 15. The `5!` Local Circulation

The local circulation count is:

[
5!=120
]

This corresponds naturally to the five-mode Tetragrammatron tail:

```text
FACTS
RULES
CLOSURES
COMBINATORS
CONS
```

The five modes admit:

```text
120 ordered permutations
```

Therefore:

```text
5!
resolves one local relation half-orbit
```

The signed local orbit is:

[
2\times5!=240
]

Interpretation:

```text
120
one orientation or half-orbit

240
both orientations or signed local orbit
```

Canonical law:

```text
5! resolves local circulation.

2×5! resolves signed local circulation.
```

---

# 16. Quadratic Resolution Modulo 240

The local relation position is computed as:

[
local240=Q(x,y)\bmod240
]

where:

```text
x
family or gauge coordinate

y
dialect or orbit offset
```

For the `F*` row:

```text
x = 15
y = dialect ∈ 0..15
```

So:

[
local240(d)
===========

Q(15,d)\bmod240
]

Using:

[
Q(x,y)=60x^2+16xy+4y^2
]

gives:

[
Q(15,d)
=======

60(225)+240d+4d^2
]

Modulo 240:

[
60(225)\equiv60\pmod{240}
]

and:

[
240d\equiv0\pmod{240}
]

Therefore:

[
local240(d)
===========

(60+4d^2)\bmod240
]

This is a useful simplification:

```text
the 16xy term supplies an exact 240δ bridge

under mod 240 it preserves orbit transfer
without changing the local residue
```

That explains the role of the bridge term:

```text
16xy at x=15
=
240y
```

It lifts by whole signed local orbits.

It changes the larger address context while preserving the local `mod 240` position.

---

# 17. Why the `16xy` Bridge Matters

At `x=15`:

[
16xy=16(15)y=240y
]

Thus:

```text
each dialect step advances by one complete 240-position orbit
```

Before modulo reduction, the dialect is visible as an orbit lift.

After modulo reduction, the local circulation remains aligned.

So:

```text
y changes the orbit sheet

Q mod 240 preserves the local position
```

This is exactly what a circular slide-ruler dialect offset should do.

Canonical statement:

```text
The bridge moves between orbit sheets
without corrupting the local240 coordinate.
```

---

# 18. The `7!` Receipt Orbit

The receipt ring has:

[
7!=5040
]

and:

[
5040=7\times3\times240
]

This provides three coordinates:

```text
fano7
one of seven Fano/Hamming positions

role3
one of three epistemic or temporal roles

local240
one position in the signed local orbit
```

The canonical packing is:

[
slot5040
========

fano7\times720
+
role3\times240
+
local240
]

where:

```text
fano7 ∈ 0..6

role3 ∈ 0..2

local240 ∈ 0..239
```

Because:

[
720=3\times240
]

each Fano block contains three complete signed local orbits.

---

# 19. Meaning of the Three Receipt Coordinates

## `fano7`

This records the Hamming/Fano incidence position:

```text
LOGOS
NOMOS
FS
PATHOS
GS
RS
US
```

or another canonically ordered seven-position selector.

## `role3`

This records the selected triadic role.

Depending on the receipt profile, it may encode:

```text
LOGOS / NOMOS / PATHOS
```

or:

```text
LL / MM / NN
```

These must not be conflated.

The receipt schema must state which triad the field uses.

A stronger implementation stores both:

```text
integrity_role3
temporal_role3
```

and derives a compact packed role only where necessary.

## `local240`

This records the signed local circulation resolved by the quadratic fold.

---

# 20. Receipt Placement

A receipt slot may be computed as:

```c
uint16_t receipt_slot5040(
    uint8_t fano7,
    uint8_t role3,
    uint8_t local240
) {
    return (uint16_t)(
        ((uint16_t)fano7 * 720u) +
        ((uint16_t)role3 * 240u) +
        local240
    );
}
```

Input validation is mandatory:

```c
bool valid_receipt_coordinates(
    uint8_t fano7,
    uint8_t role3,
    uint16_t local240
) {
    return
        fano7 < 7u &&
        role3 < 3u &&
        local240 < 240u;
}
```

The reverse mapping is:

```c
typedef struct {
    uint8_t fano7;
    uint8_t role3;
    uint8_t local240;
} ReceiptCoordinate;

ReceiptCoordinate unpack_receipt_slot(uint16_t slot) {
    ReceiptCoordinate r;

    r.fano7 = (uint8_t)(slot / 720u);
    slot %= 720u;

    r.role3 = (uint8_t)(slot / 240u);
    r.local240 = (uint8_t)(slot % 240u);

    return r;
}
```

This makes the `7!` ring executable rather than purely symbolic.

---

# 21. The `11!` Orientation and Signing Expansion

The `11!` layer belongs above the local `5!` frame and the `7!` receipt ring.

Its role is:

```text
orientation expansion

signing permutation

higher-order route arrangement

observer or key-order resolution
```

It does not accept state.

Canonical authority boundary:

```text
5!
resolves local circulation

7!
records an accepted local result in the receipt ring

11!
expands orientation and signing arrangements above that result
```

Therefore:

```text
11! may reorder, orient, sign, or project a receipt.

11! may not retroactively make an invalid relation valid.
```

The accepted receipt remains the authority-bearing object.

The `11!` layer supplies additional arrangement metadata.

---

# 22. The Full Resolution Chain

```text
generalized order p
↓
select maximum place-value span
↓
include all lower spans
↓
resolve Omicron sector
↓
select 28+4 incidence scope
or 27+5 relation scope
↓
F* selects gauge family and dialect
↓
period-8 delta witness
↓
1/73 block 01369863
↓
block weight W = 36
↓
base36 visible orbit labels
↓
five-mode relation circulation
↓
5! = 120 local half-orbit
↓
2×5! = 240 signed local orbit
↓
Q(x,y) resolves local240
↓
16xy supplies whole-orbit dialect lift
↓
Fano selector chooses one of seven incidence positions
↓
role selector chooses one of three roles
↓
7×3×240 = 5040
↓
7! receipt slot
↓
validation and receipt acceptance
↓
11! orientation/signing expansion
↓
Gnomonic Projection Azimuth
↓
observer-facing inspection
```

---

# 23. Authority Boundaries

The following rules are mandatory:

```text
Generalized order controls maximum resolution.

It does not establish truth.
```

```text
Omicron supplies the fixed ruler.

It does not accept state.
```

```text
Tetragrammatron resolves relation closure.

It does not scribe incidence.
```

```text
Metatron scribes incidence.

It does not validate closure.
```

```text
The quadratic fold resolves local circulation.

It does not accept state.
```

```text
The F* row selects family and dialect.

It does not accept state.
```

```text
11x² and 11! orient and sign.

They do not accept state.
```

```text
Validation decides.

Receipt records the decision.
```

---

# 24. Integrated Implementation Types

```c
typedef enum {
    OMI_ORDER_INVERSE = -1,
    OMI_ORDER_NIBBLE  = 0,
    OMI_ORDER_BYTE    = 1,
    OMI_ORDER_WORD16  = 2,
    OMI_ORDER_WORD32  = 3,
    OMI_ORDER_WORD64  = 4
} OmiResolutionOrder;

typedef enum {
    OMICRON_SCOPE_INCIDENCE_28_4,
    OMICRON_SCOPE_RELATION_27_5
} OmicronSectorScope;

typedef struct {
    OmiResolutionOrder order;
    uint16_t max_bits;
    bool includes_lower_orders;
} OmiResolutionBound;

typedef struct {
    uint8_t family;
    uint8_t dialect;
} FStarGauge;

typedef struct {
    uint8_t tetragrammatron_witness; /* 0x1E */
    uint8_t metatron_witness;        /* 0x18 */
    uint8_t centered_fold;           /* 0x3C */
    uint8_t full_fold;               /* 0x78 */
} OmicronDualWitness;

typedef struct {
    uint8_t fano7;
    uint8_t role3;
    uint8_t local240;
    uint16_t slot5040;
} ReceiptOrbitAddress;
```

---

# 25. Final Canon

```text
The generalized-mean-ing order is an “up to” clause.

It establishes the maximum place-value span
that may be resolved while preserving every lower span.
```

```text
p = -1
is the inverse or pre-resolution envelope.

p = 0
enters the one-nibble zero-polynomial notation.

p = 1
resolves up to one byte.

p = 2
resolves up to sixteen bits.

p = 3
resolves up to thirty-two bits.
```

```text
The Omicron sector is one fixed circular ruler
with two canonical resolver windows.
```

```text
28+4
belongs to Metatron.

It exposes four-gauge incidence
and yields 0x18.
```

```text
27+5
belongs to Tetragrammatron.

It exposes five-mode relation closure
and yields 0x1E.
```

```text
Q(x,y)
=
60x² + 16xy + 4y²
=
4(4x² + 11x² + 4xy + y²).
```

```text
4x²
grounds the local gauge.

11x²
signs orientation.

4xy
bridges family and dialect.

y²
preserves the local offset.
```

```text
At x=15:

16xy = 240y.

The dialect therefore lifts by complete signed local orbits
while Q mod 240 preserves the local position.
```

```text
5! = 120
is the local half-orbit.

240 = 2×5!
is the signed local orbit.

7! = 5040
is the receipt orbit.
```

```text
slot5040
=
fano7×720
+
role3×240
+
local240.
```

```text
The F* gauge header selects the dialect.

The quadratic fold resolves local240.

The Fano and role selectors lift local240
into the 7! receipt ring.

Validation decides.

Receipt records.

11! signs and orients above the accepted receipt.

Gnomonic Projection Azimuth makes that orientation inspectable.
```
