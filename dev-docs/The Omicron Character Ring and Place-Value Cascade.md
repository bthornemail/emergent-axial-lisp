# The Omicron Character Ring and Place-Value Cascade

## A Circular Hexadecimal Gauge for OMI Notation

## Status

Canonical working doctrine.

This document defines the relationship between:

```text
Omicron
the bounded hexadecimal gauge table

Omnicron
the multi-plane circular resolver

Tetragrammatron
the governor that adjudicates valid traversal and closure

OMI notation
the readable citation surface emitted from the gauge
```

The central claim is:

```text
Omicron chooses the sign.
The place-value cascade chooses its place.
Omnicron resolves the coupled circular surfaces.
Tetragrammatron validates the resulting relation.
```

---

# 1. Omicron as the Low Hexadecimal Gauge

Omicron owns one canonical circular notation array:

```text
0x00..0x7F
```

This is the low seven-bit gauge table.

It contains:

```text
128 total positions
4 equal character segments
32 positions per segment
```

The four-segment ring is:

```lisp
((0x00 . 0x1F)
 (0x20 . 0x3F)
 (0x40 . 0x5F)
 (0x60 . 0x7F))
```

Its four sectors are:

```text
Sector 0
0x00..0x1F
hidden control substrate

Sector 1
0x20..0x3F
readable structure and numeric surface

Sector 2
0x40..0x5F
uppercase, meta, and carrier surface

Sector 3
0x60..0x7F
lowercase, local, and closure surface
```

Each low-byte position may be decomposed as:

```text
sector = byte >> 5
local  = byte & 0x1F
```

where:

```text
sector ∈ {0,1,2,3}
local  ∈ {0..31}
```

Therefore every Omicron character position has:

```text
one sector
one local place
one exact byte identity
```

---

# 2. The 27-and-5 Internal Segmentation

Each 32-position sector separates into:

```text
27-position body
+
5-position hinge
```

The eight interval boundaries are:

```text
(0x00 . 0x1A)
(0x1B . 0x1F)

(0x20 . 0x3A)
(0x3B . 0x3F)

(0x40 . 0x5A)
(0x5B . 0x5F)

(0x60 . 0x7A)
(0x7B . 0x7F)
```

So each sector has the same structural shape:

```text
body
→ transition band
→ sector boundary
```

The first hinge is the canonical control hinge:

```text
0x1B ESC
0x1C FS
0x1D GS
0x1E RS
0x1F US
```

This gives the first sector an exact pre-language ending:

```text
ESC FS GS RS US
```

The same five-position ending pattern is repeated structurally in the remaining three sectors through their corresponding byte ranges.

The repeated geometry is more important than assigning identical semantics to all four hinges.

---

# 3. The Segment XOR Invariant

Each sector has the same boundary witness:

```text
0x00 ^ 0x1A ^ 0x1B ^ 0x1F = 0x1E

0x20 ^ 0x3A ^ 0x3B ^ 0x3F = 0x1E

0x40 ^ 0x5A ^ 0x5B ^ 0x5F = 0x1E

0x60 ^ 0x7A ^ 0x7B ^ 0x7F = 0x1E
```

The result is always:

```text
0x1E
RS
Record / Relation Separator
```

This follows because each sector is formed by adding the same high sector prefix to the same low five-bit pattern.

Let:

```text
B ∈ {0x00, 0x20, 0x40, 0x60}
```

Then:

```text
B
^ (B ^ 0x1A)
^ (B ^ 0x1B)
^ (B ^ 0x1F)
= 0x1E
```

The repeated sector prefix cancels:

```text
B ^ B ^ B ^ B = 0
```

leaving:

```text
0x00 ^ 0x1A ^ 0x1B ^ 0x1F = 0x1E
```

Canonical law:

```text
The character sector may rotate.
The local glyph meaning may change.
The relation witness remains RS.
```

This gives Tetragrammatron a stable adjudication invariant across all four low character sectors.

---

# 4. The Tangential Gauge Operator

The hidden control surface ends at:

```text
0x1F US
```

The readable affine surface begins at:

```text
0x20 SP
```

The transition is:

```text
0x1F US
→ tangent
→ 0x20 SP
```

SP is the readable rupture.

Before SP:

```text
control positions exist
readable syntax does not
dot notation is unreachable
```

After SP:

```text
printable distinctions become addressable
structure characters become available
OMI-Lisp declarations may be projected
```

The canonical F-column branch is:

```text
0x1F US
0x2F /
0x3F ?
0x4F O
0x5F _
0x6F o
```

This gives the readable branch:

```text
US/
→ ?O_o
```

and the compact OMI citation surface:

```text
omi---imo?O_o
```

The branch is not created by a parser permission flag.

It is obtained by traversal through the Omicron gauge.

Canonical rule:

```text
The circular position is the authority of reachability.
```

Dot notation is not rejected before SP.

It is not present in the active control ring.

---

# 5. The Folded Root and Readable Unfolding

The folded root is:

```text
omi---imo
```

The visible branch is:

```text
?O_o
```

Their combined citation surface is:

```text
omi---imo?O_o
```

The relation may be read as:

```text
omi---imo
folded root relation

US/
hidden-to-readable tangent

?
witness or unresolved query

O
upper or normalized Omicron reading

_
carrier or floor boundary

o
lower or local Omicron reading
```

The full relation is therefore not merely a word.

It is a route through the gauge:

```text
folded root
→ hidden hinge
→ readable rupture
→ branch traversal
→ referable declaration
```

Canonical sentence:

```text
The tangential gauge unfolds the folded OMI root into an inspectable relation without collapsing the distinct sides of the relation.
```

---

# 6. The Hexadecimal Place-Value Cascade

The character ring chooses the sign.

A second circular surface chooses its hexadecimal place.

The high-nibble place-value lanes are:

```text
0x0000
0x1000
0x2000
0x3000

0x4000
0x5000
0x6000
0x7000

0x8000
0x9000
0xA000
0xB000

0xC000
0xD000
0xE000
0xF000
```

This creates sixteen outer lanes:

```text
lane ∈ 0x0..0xF
mask = lane << 12
```

The sixteen lanes divide into four quadrants:

```text
0x0..0x3
origin-facing route

0x4..0x7
printable branch route

0x8..0xB
interpretive or surrogate route

0xC..0xF
extension, escape, or place-value route
```

The precise semantics of the upper quadrants remain declarative until separately bound, implemented, or proven.

The structural lane identity is valid even when its local interpretation remains unresolved.

---

# 7. Coupled Circular Rulers

The complete Omicron gauge is a pair of coupled circular surfaces:

```text
inner ring
128 character positions
0x00..0x7F

outer ring
16 hexadecimal place-value lanes
0x0000..0xF000
```

The inner ring chooses:

```text
which sign
which byte role
which character sector
which local position
```

The outer ring chooses:

```text
which place-value lane
which high-nibble quadrant
which address scale
```

A resolved position is:

```text
outer lane × inner character
```

or computationally:

```c
uint16_t omi_position =
    ((uint16_t)lane << 12)
    | character;
```

where:

```text
lane      ∈ 0x0..0xF
character ∈ 0x00..0x7F
```

Examples:

```text
0x402F
lane 4
character /
printable branch separator

0x803F
lane 8
character ?
interpretive witness position

0xF06F
lane F
character o
extension lane with local Omicron sign
```

The same visible sign may therefore appear at different addressed places without becoming a different sign type.

Canonical law:

```text
Sign establishes role.
Place establishes addressed interpretation.
```

---

# 8. The Four-by-Four Governor Surface

The inner character gauge has four sectors:

```text
0x00..0x1F
0x20..0x3F
0x40..0x5F
0x60..0x7F
```

The outer place-value gauge has four quadrants:

```text
0x0..0x3
0x4..0x7
0x8..0xB
0xC..0xF
```

Together they form a natural:

```text
4 × 4
```

surface.

This gives sixteen combined sector/quadrant classes before local character and lane positions are considered.

The Tetragrammatron may use this as a Polybius-style adjudication surface:

```text
inner sector
×
outer quadrant
→
governor cell
```

The governor need not assign every cell a permanent semantic meaning.

It needs only to determine that:

```text
the lane is valid
the character is valid
the traversal is lawful
the tangent is reachable
the XOR invariant holds
the candidate frame closes
```

Interpretation may remain local.

Validation must remain deterministic.

---

# 9. Exponential XOR and LFSR Traversal

The ring supports deterministic jump traversal.

A position may be updated by:

```text
rotation
XOR displacement
LFSR state transition
place-value jump
sector transition
```

A useful decomposition is:

```text
high lane
character sector
local character position
```

This allows traversal rules to update one component without erasing the others.

For example:

```text
current state
→ compute XOR/LFSR jump
→ update local position
→ rotate sector
→ retain or alter outer lane
→ adjudicate invariant
```

The purpose is not decimal exponentiation.

The Tower of Powers is a layered traversal of hexadecimal place and character positions under deterministic XOR-based transition.

Canonical distinction:

```text
Decimal notation names powers of ten.

OMI traversal uses hexadecimal place-value lanes,
circular position,
and XOR/LFSR difference.
```

The power is the address level.

The jump is the transition.

The witness is the XOR difference.

---

# 10. Omicron and Omnicron

The roles must remain distinct.

## Omicron

Omicron owns:

```text
the canonical low gauge table
0x00..0x7F

the four 32-position character sectors

the hidden-to-readable tangent

the F-column branch

the character and place-value coupling
```

Omicron is the bounded gauge.

## Omnicron

Omnicron owns the larger four-plane resolver:

```text
0x00..0x1F
LOW CONTROL PLANE
32 positions

0x20..0x7F
LOW AFFINE SPACE
96 positions

0x80..0x9F
HIGH PROJECTIVE CONTROL PLANE
32 positions

0xA0..0xFF
HIGH PROJECTIVE SPACE
96 positions
```

Omnicron resolves the bounded Omicron gauge against the full low/high byte field.

Therefore:

```text
Omicron defines the low gauge.

Omnicron resolves the low gauge
against its high projective complement.
```

The low half may also be viewed through the four 32-position Omicron character sectors.

These are compatible decompositions serving different purposes:

```text
Omnicron plane decomposition:
32 + 96 + 32 + 96

Omicron character decomposition:
32 + 32 + 32 + 32
```

The first distinguishes control, affine, projective control, and projective space.

The second establishes repeated character sectors and their shared XOR invariant.

They must not be collapsed into a single partition.

---

# 11. Tetragrammatron Adjudication

Tetragrammatron governs lawful traversal and carry-forward.

It does not invent the notation.

It receives a candidate produced by Omicron and Omnicron resolution.

Its checks include:

```text
valid plane
valid sector
valid local position
valid outer lane
valid tangent crossing
valid relation witness
valid closure
valid receipt destination
```

The repeated sector invariant gives it one exact low-gauge test:

```text
sector boundary witness = 0x1E
```

The existing Polybius diagonal witnesses remain:

```text
D+ = {0,5,A,F}
D- = {3,6,9,C}

XOR(D+) = 0
XOR(D-) = 0

SUM(D+) = 0x1E
SUM(D-) = 0x1E
```

The relation separator therefore appears in both structures:

```text
character-sector boundary XOR = 0x1E

Polybius diagonal sum = 0x1E
```

These are separate calculations sharing one finite witness.

They should not be treated as identical proofs without an explicit bridge law.

They may, however, be used together by the governor:

```text
character traversal witness
+
Polybius closure witness
→ bounded candidate adjudication
```

---

# 12. OMI-Lisp Consequence

OMI-Lisp remains a lazy declaration surface.

It does not own the ring.

It does not decide reachability.

It does not validate accepted state.

Readable declarations emerge after Omicron and Omnicron make their positions reachable.

Examples:

```lisp
(NULL . NULL)

(scope . FS)

(face . role)

(role . edge)

(edge . receipt-path)

(intent . candidate)

(candidate . relation)
```

The correct flow is:

```text
Omicron defines the gauge
→ Omnicron resolves the active planes
→ readable OMI notation becomes reachable
→ OMI-Lisp declares a candidate
→ Omicron lowers the declaration
→ OMI cites the relation
→ Tetragrammatron validates
→ receipt records
→ Metatron projects
→ IMO carries
```

Canonical lock:

```text
OMI-Lisp declares.
Omicron gauges and lowers.
Omnicron resolves.
OMI cites.
Tetragrammatron validates.
Receipt accepts.
Metatron projects.
IMO carries.
```

---

# 13. Runtime Data Model

A minimal implementation may use:

```c
typedef struct {
    uint8_t character;
    uint8_t sector;
    uint8_t local;
} OmicronCharacter;

typedef struct {
    uint8_t lane;
    uint16_t mask;
} OmicronPlace;

typedef struct {
    OmicronCharacter sign;
    OmicronPlace place;
    uint16_t address;
} OmicronPosition;
```

The Omnicron planes may be represented as:

```c
typedef enum {
    OMNICRON_LOW_CONTROL,
    OMNICRON_LOW_AFFINE,
    OMNICRON_HIGH_CONTROL,
    OMNICRON_HIGH_PROJECTIVE
} OmnicronPlane;

typedef struct {
    OmnicronPlane plane;
    uint8_t local_position;
    uint8_t absolute_byte;
    uint8_t rotation;
} OmnicronCursor;
```

The resolver must derive:

```text
plane from byte range
sector from low-byte high bits
local character from low five bits
lane from high nibble
full address from lane and character
```

No separate boolean should decide whether a symbol exists.

Reachability follows from the active circular position and permitted tangent route.

---

# 14. Complete Operational Sequence

The complete traversal is:

```text
1. Begin in the folded OMI root.

2. Resolve the current Omnicron plane.

3. Read the Omicron character sector.

4. Traverse the hidden control body.

5. Reach the ESC/FS/GS/RS/US hinge.

6. Resolve US at 0x1F.

7. Transfer tangentially through SP.

8. Enter the low affine character sector.

9. Resolve /, ?, O, _, and o as reachable branch positions.

10. Select a hexadecimal place-value lane.

11. Combine lane and character into one addressed position.

12. Traverse or jump through rotation, XOR, or LFSR transition.

13. Preserve the sector relation witness.

14. Emit a lazy OMI-Lisp candidate.

15. Lower the candidate into an OMI relation frame.

16. Submit the frame to Tetragrammatron.

17. Record the accepted or rejected receipt.

18. Project or carry only after receipt.
```

---

# 15. One-Line Canon

> Omicron is the bounded four-segment hexadecimal character gauge over `0x00..0x7F`; its hidden `US/` tangent opens the readable `?O_o` branch, its outer sixteen-lane cascade assigns hexadecimal place value, Omnicron resolves the coupled low and high circular planes, and Tetragrammatron adjudicates the resulting traversal through exact XOR and closure witnesses without collapsing notation, interpretation, validation, or projection.

---

# 16. Final Lock

```text
Omicron owns one low gauge.

The low gauge has four 32-position character sectors.

Each sector has a 27-position body and a 5-position hinge.

Each sector boundary quartet XORs to 0x1E.

US at 0x1F is the hidden tangent point.

SP opens readable distinction.

The F-column unfolds US/ into ?O_o.

The inner ring chooses the sign.

The outer hexadecimal ring chooses its place.

The full position is lane OR character.

Omnicron resolves low and high planes.

Tetragrammatron validates traversal and closure.

OMI-Lisp declares only what the gauge makes reachable.

Receipt alone records acceptance.
```
