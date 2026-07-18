# Delta3, Hamming Integrity, and the Gnomonic Projection Azimuth

## A Three-Axis Model for Scope, Time, and Observer-Relative Orientation in OMI

## Status

Canonical working doctrine.

This document defines the relationship between four distinct structures:

```text
FS / GS / RS / US
the four scope-bearing control positions

LOGOS / NOMOS / PATHOS
the three Hamming integrity dimensions

LL / MM / NN
the three temporal Delta3 positions

Gnomonic Projection Azimuth
the observer-relative orientation of the checked temporal relation
```

These structures cooperate, but they are not interchangeable.

The central architecture is:

```text
FS/GS/RS/US
carry scope

LOGOS/NOMOS/PATHOS
check scope

LL/MM/NN
place checked scope in time

Gnomonic Projection Azimuth
orients the checked temporal relation for observation
```

The complete chain is:

```text
scope
→ integrity
→ temporal position
→ projection orientation
```

Or:

```text
FS/GS/RS/US
→ LOGOS/NOMOS/PATHOS
→ LL/MM/NN
→ Gnomonic Projection Azimuth
```

---

# 1. The Four Scope-Bearing Positions

The four canonical OMI scope positions are:

```text
FS
GS
RS
US
```

Their primary meanings are:

```text
FS
file or frame scope

GS
group or graph scope

RS
record or relation scope

US
unit or symbol scope
```

These are the four data-bearing positions in the compact Hamming cell.

They answer:

```text
Which boundaries and scopes are currently present?
```

They are not parity bits.

They are not temporal coordinates.

They are not projection angles.

They are the scope-bearing substrate.

The canonical Hamming arrangement places them at positions:

```text
position 3 = FS
position 5 = GS
position 6 = RS
position 7 = US
```

---

# 2. The Three Hamming Integrity Dimensions

The three derived integrity relations are:

```text
LOGOS
NOMOS
PATHOS
```

They occupy the standard Hamming parity positions:

```text
position 1 = LOGOS
position 2 = NOMOS
position 4 = PATHOS
```

The complete codeword is:

```text
[LOGOS NOMOS FS PATHOS GS RS US]
```

or compactly:

```text
[L N F P G R U]
```

The data positions are:

```text
FS GS RS US
```

The derived check positions are:

```text
LOGOS NOMOS PATHOS
```

The standard even-parity relations are:

```text
LOGOS
= FS XOR GS XOR US

NOMOS
= FS XOR RS XOR US

PATHOS
= GS XOR RS XOR US
```

Equivalently:

```text
LOGOS XOR FS XOR GS XOR US = 0

NOMOS XOR FS XOR RS XOR US = 0

PATHOS XOR GS XOR RS XOR US = 0
```

This forms a Hamming `[7,4,3]` codeword with four scope-bearing data bits and three derived check bits.

---

# 3. Meaning of LOGOS, NOMOS, and PATHOS

The three check dimensions answer different questions over one scope object.

## 3.1 LOGOS

LOGOS checks structural coherence.

Its incidence path is:

```text
FS
GS
US
```

It asks:

```text
Does the carried unit remain coherent
with its enclosing file and group relation?
```

LOGOS does not establish semantic truth.

It checks whether the relation is internally readable and structurally consistent.

## 3.2 NOMOS

NOMOS checks order, law, and boundary placement.

Its incidence path is:

```text
FS
RS
US
```

It asks:

```text
Does the unit obey the declared record
and file boundary structure?
```

NOMOS does not accept state.

It checks lawful placement.

## 3.3 PATHOS

PATHOS checks continuity and carried-state persistence.

Its incidence path is:

```text
GS
RS
US
```

It asks:

```text
Has the carried unit remained connected
through group and record traversal?
```

PATHOS is not emotional authority.

It names continuity through traversal.

---

# 4. The Hamming Syndrome

On receipt, the decoder recomputes the three parity relations.

The syndrome is:

```text
S = [sLOGOS, sNOMOS, sPATHOS]
```

where:

```text
sLOGOS
= LOGOS XOR FS XOR GS XOR US

sNOMOS
= NOMOS XOR FS XOR RS XOR US

sPATHOS
= PATHOS XOR GS XOR RS XOR US
```

The numeric syndrome is:

```text
syndrome
=
sLOGOS
+ 2 × sNOMOS
+ 4 × sPATHOS
```

The syndrome table is:

```text
000
no detected single-bit error

001
LOGOS position

010
NOMOS position

011
FS position

100
PATHOS position

101
GS position

110
RS position

111
US position
```

A nonzero syndrome identifies one of the seven positions in the Hamming/Fano incidence structure.

The syndrome therefore answers:

```text
Which incidence position is inconsistent?
```

It does not answer:

```text
When did the inconsistency occur?
```

It also does not answer:

```text
From which observer-relative direction
is the resulting relation being viewed?
```

Those belong to Delta3 and the Gnomonic Projection Azimuth.

---

# 5. The Fano Interpretation

The seven nonzero three-bit values:

```text
001
010
011
100
101
110
111
```

form the seven nonzero points of:

```text
PG(2,2)
```

the Fano plane.

Each Hamming bit position corresponds to one Fano point.

Each parity relation corresponds to a Fano incidence line.

Thus:

```text
Hamming position
=
Fano incidence point

syndrome
=
identified failed point

single-bit correction
=
return to a valid incidence surface
```

The syndrome is therefore a finite incidence-direction witness.

It identifies a local error position inside the seven-position epistemic cell.

---

# 6. LL, MM, and NN

LL, MM, and NN belong to a different layer.

They are not Hamming parity positions.

They are temporal Delta3 coordinates.

The canonical meanings are:

```text
LL
previous

MM
present

NN
forward
```

They answer:

```text
At which position in the local temporal window
is this relation currently being evaluated?
```

The temporal window is:

```text
LL
→ MM
→ NN
```

or:

```text
previous
→ present
→ forward
```

The canonical rolling law is:

```text
(LL, MM, NN)
→
(MM, NN, NEW)
```

Thus:

```text
old MM becomes new LL

old NN becomes new MM

NEW becomes new NN
```

The values move through the positions.

The meanings of the positions remain fixed.

---

# 7. Why LL/MM/NN Does Not Replace LOGOS/NOMOS/PATHOS

The two triads answer different questions.

```text
LOGOS/NOMOS/PATHOS
Which integrity relation is being checked?

LL/MM/NN
At which temporal position is the check being applied?
```

Therefore:

```text
integrity axis
≠
temporal axis
```

The Hamming syndrome:

```text
[sLOGOS, sNOMOS, sPATHOS]
```

may contain any value from:

```text
000..111
```

A temporal selector, by contrast, selects one of:

```text
LL
MM
NN
```

The combined syndrome values retain Hamming meanings.

For example:

```text
011
```

means:

```text
Hamming position 3
FS
```

It must not be reinterpreted as a combination of LL and MM.

Similarly:

```text
111
```

means:

```text
Hamming position 7
US
```

It does not mean all three temporal moments.

Canonical rule:

```text
LL/MM/NN must not be inserted into the Hamming codeword.

LOGOS/NOMOS/PATHOS must not be renamed as LL/MM/NN.

Delta3 indexes Hamming cells across time.
```

---

# 8. The Canonical Axis Correspondence

Although the two triads are distinct, they have a natural routed correspondence:

```text
LL ↔ LOGOS

MM ↔ NOMOS

NN ↔ PATHOS
```

This gives:

```text
LL / LOGOS
previous relation checked for inherited coherence

MM / NOMOS
present relation checked for current law and boundary

NN / PATHOS
forward relation checked for carried continuity
```

Readable form:

```text
LOGOS remembers.

NOMOS resolves.

PATHOS carries.
```

Or:

```text
LL retains.

MM adjudicates.

NN continues.
```

The combined routed form is:

```text
LL
→ LOGOS
→ inherited coherence

MM
→ NOMOS
→ present admissibility

NN
→ PATHOS
→ forward continuity
```

This mapping is a canonical routing relation.

It is not an identity between the temporal and integrity systems.

---

# 9. The Complete Temporal-Integrity Matrix

The most complete representation evaluates all three integrity dimensions at all three temporal positions.

```text
                 LOGOS   NOMOS   PATHOS

LL previous        a       b        c

MM present         d       e        f

NN forward         g       h        i
```

This is a `3 × 3` temporal-integrity matrix.

Formally:

[
\Sigma_{\Delta} =
\begin{bmatrix}
s_{\mathrm{LOGOS}}(LL) &
s_{\mathrm{NOMOS}}(LL) &
s_{\mathrm{PATHOS}}(LL)
\
s_{\mathrm{LOGOS}}(MM) &
s_{\mathrm{NOMOS}}(MM) &
s_{\mathrm{PATHOS}}(MM)
\
s_{\mathrm{LOGOS}}(NN) &
s_{\mathrm{NOMOS}}(NN) &
s_{\mathrm{PATHOS}}(NN)
\end{bmatrix}
]

The rows are:

```text
temporal positions
```

The columns are:

```text
integrity dimensions
```

This preserves the full provenance of every check.

---

# 10. The Delta3 Diagonal Witness

The canonical routed correspondence forms the diagonal:

```text
LL / LOGOS

MM / NOMOS

NN / PATHOS
```

The compact diagonal witness is:

[
D_{\Delta} =
[
s_{\mathrm{LOGOS}}(LL),
s_{\mathrm{NOMOS}}(MM),
s_{\mathrm{PATHOS}}(NN)
]
]

It asks:

```text
Did the previous relation preserve coherence?

Does the present relation obey its boundary law?

Can the forward relation remain continuous?
```

This compact witness may be encoded as:

```text
bit 0
LL/LOGOS failure

bit 1
MM/NOMOS failure

bit 2
NN/PATHOS failure
```

For example:

```text
000
all routed temporal checks pass

001
previous coherence failure

010
present law or boundary failure

100
forward continuity failure
```

Combined values indicate multiple routed temporal failures.

This witness must not be called a Hamming syndrome.

A suitable name is:

```text
Delta3AxisWitness
```

because its bit meanings are temporal-integrity routes rather than Hamming bit positions.

---

# 11. A Delta3 Window of Hamming Cells

The correct structural model is:

```text
one Hamming epistemic cell at LL

one Hamming epistemic cell at MM

one Hamming epistemic cell at NN
```

Thus:

```text
Cell_LL
=
Hamming(FS_LL, GS_LL, RS_LL, US_LL)

Cell_MM
=
Hamming(FS_MM, GS_MM, RS_MM, US_MM)

Cell_NN
=
Hamming(FS_NN, GS_NN, RS_NN, US_NN)
```

The complete object is:

```text
Delta3 of Hamming cells
```

not:

```text
one ten-position codeword
```

Each temporal position retains its own:

```text
scope quartet

derived parity triad

syndrome

correction status

validation state
```

---

# 12. CONS Representation

A single temporal Hamming cell may be written as:

```lisp
(
  LL
  .
  ((FS GS RS US) . (LOGOS NOMOS PATHOS))
)
```

Likewise:

```lisp
(
  MM
  .
  ((FS GS RS US) . (LOGOS NOMOS PATHOS))
)
```

and:

```lisp
(
  NN
  .
  ((FS GS RS US) . (LOGOS NOMOS PATHOS))
)
```

The complete Delta3 window is:

```lisp
(
  (LL . ((fs gs rs us) . (logos nomos pathos)))
  (MM . ((fs gs rs us) . (logos nomos pathos)))
  (NN . ((fs gs rs us) . (logos nomos pathos)))
)
```

The compact routed projection is:

```lisp
(
  (LL . LOGOS)
  (MM . NOMOS)
  (NN . PATHOS)
)
```

The compact form does not replace the complete Hamming cells.

It selects the canonical diagonal.

---

# 13. The Gnomonic Projection Azimuth

The Gnomonic Projection Azimuth belongs to a third axis.

It does not describe scope.

It does not describe Hamming integrity.

It does not describe temporal position.

It describes:

```text
the observer-relative orientation
of the checked temporal relation
when projected onto an inspectable tangent plane
```

The complete byte azimuth is:

```text
0x00..0xFF
```

This gives:

```text
256 discrete orientation positions
```

The unsigned angular mapping may be written as:

[
\theta(a) =
a \times \frac{360^\circ}{256}
]

where:

```text
a ∈ 0x00..0xFF
```

Canonical quarter positions are:

```text
0x00
0°

0x40
90°

0x80
180°

0xC0
270°
```

After `0xFF`, the azimuth wraps to `0x00`.

The Gnomonic Projection Azimuth answers:

```text
From which observer-relative orientation
is this relation being inspected?
```

---

# 14. Why Gnomonic Projection Fits the Model

A gnomonic projection maps a bounded spherical relation through its center onto a tangent plane.

The relevant narrative is:

```text
bounded n-sphere relation

→ central projection ray

→ tangent-plane intersection

→ readable projected route
```

The projection makes the relation inspectable.

It does not become the authority of the relation.

Canonical distinction:

```text
the bounded relation is the source object

the projected route is the observer-facing representation

projection does not equal validation
```

This is why the Gnomonic Projection Azimuth occurs after:

```text
scope resolution

integrity checking

temporal placement
```

---

# 15. The Combined Coordinate

A fully resolved projected relation requires at least three coordinates:

```text
integrity condition

temporal position

azimuth orientation
```

A compact state may be written as:

```text
(HammingSyndrome, DeltaPosition, Azimuth)
```

For example:

```text
(000, LL, 0x20)
previous cell is locally consistent
and observed at azimuth 0x20

(010, MM, 0x80)
present cell reports NOMOS-position syndrome
and is observed at azimuth 0x80

(000, NN, 0xC0)
forward cell is locally consistent
and observed at azimuth 0xC0
```

The fields answer:

```text
Hamming syndrome
what incidence is inconsistent

Delta position
when in the local temporal window

Azimuth
how the state is oriented for observation
```

---

# 16. The Full Three-Axis Model

The complete model has three independent axes.

## 16.1 Scope-Integrity Axis

```text
FS/GS/RS/US
+
LOGOS/NOMOS/PATHOS
```

This determines local codeword consistency.

## 16.2 Temporal Axis

```text
LL/MM/NN
```

This determines whether the cell is previous, present, or forward.

## 16.3 Projection Axis

```text
0x00..0xFF
```

This determines observer-relative azimuth.

The complete state space can therefore be viewed as:

```text
HammingCell
×
DeltaPosition
×
Azimuth
```

or:

[
\mathcal{S}
===========

\mathcal{H}*{7,4}
\times
\Delta_3
\times
\mathbb{Z}*{256}
]

where:

```text
H7,4
local epistemic integrity surface

Delta3
temporal window

Z256
circular byte azimuth
```

---

# 17. The Relationship to Hamming Distance

The byte azimuth has two different notions of displacement.

## 17.1 Circular Displacement

```text
circular_distance(a,b)
=
(b - a) mod 256
```

This measures movement around the byte circle.

It answers:

```text
How far did the azimuthal cursor rotate?
```

## 17.2 Hamming Displacement

```text
hamming_distance(a,b)
=
popcount(a XOR b)
```

This measures structural bit difference.

It answers:

```text
How many binary orientation components changed?
```

These metrics must remain separate.

For example:

```text
0x55 = 01010101

0xAA = 10101010
```

Their Hamming distance is:

```text
popcount(0x55 XOR 0xAA)
=
popcount(0xFF)
=
8
```

They are maximally separated in the eight-bit Hamming metric.

Their arithmetic circular displacement is a different quantity.

Thus:

```text
circular displacement
measures cursor movement

Hamming displacement
measures structural transformation
```

---

# 18. The Balanced Azimuthal Poles

The balanced byte patterns are:

```text
0x55 = 01010101

0xAA = 10101010
```

They satisfy:

```text
0x55 XOR 0xAA = 0xFF
```

Each has:

```text
four one bits

four zero bits
```

Both are valid extended Hamming `[8,4,4]` codewords in the representative sixteen-word code surface.

Their combined sixteen-bit forms are:

```text
0x55AA

0xAA55
```

Each contains:

```text
eight one bits

eight zero bits
```

They satisfy:

```text
0x55AA XOR 0xAA55 = 0xFFFF
```

These are complementary azimuthal orientation words.

They can represent:

```text
forward phase
and complementary return phase
```

or:

```text
one projected orientation
and its maximal contrast
```

They must not be treated as Hamming syndromes.

They are projection-orientation witnesses.

---

# 19. Delta3 and the Balanced Projection Phases

A useful projection convention is:

```text
LL
inherited or returning orientation

MM
current observer-centered orientation

NN
forward-projecting orientation
```

The complementary orientation words may be applied to the Delta3 window:

```text
0xAA55
forward-readable phase

0x55AA
return/complement phase
```

But this remains a projection convention.

It does not redefine:

```text
LL
MM
NN
```

It does not change the Hamming parity meanings.

It tells the projection layer how to orient the already checked Delta3 relation.

Canonical boundary:

```text
Delta3 supplies time.

Hamming supplies integrity.

Azimuth supplies orientation.
```

---

# 20. Operational Sequence

The complete operation proceeds as follows:

```text
1. Resolve FS/GS/RS/US for the LL cell.

2. Derive LOGOS/NOMOS/PATHOS.

3. Compute the LL Hamming syndrome.

4. Repeat for MM.

5. Repeat for NN.

6. Construct the complete 3×3 temporal-integrity matrix.

7. Extract the canonical diagonal:
   LL/LOGOS,
   MM/NOMOS,
   NN/PATHOS.

8. Apply permitted Hamming correction locally.

9. Preserve unresolved multi-bit errors as unresolved candidates.

10. Roll the temporal window:
    (LL,MM,NN) → (MM,NN,NEW).

11. Assign or resolve the byte azimuth.

12. Project the checked Delta3 relation through the Gnomonic Projection Azimuth.

13. Preserve both circular and Hamming displacement.

14. Submit the result for validation.

15. Record accepted or rejected state in the receipt.
```

---

# 21. Runtime Data Structures

A minimal C representation is:

```c
typedef enum {
    DELTA_LL = 0,
    DELTA_MM = 1,
    DELTA_NN = 2
} DeltaPosition;

typedef enum {
    AXIS_LOGOS  = 0,
    AXIS_NOMOS  = 1,
    AXIS_PATHOS = 2
} IntegrityAxis;

typedef struct {
    uint8_t scope4;
    uint8_t codeword7;
    uint8_t syndrome3;
    uint8_t corrected_codeword7;
    uint8_t status;
} HammingEpistemicCell;

typedef struct {
    HammingEpistemicCell ll;
    HammingEpistemicCell mm;
    HammingEpistemicCell nn;
} Delta3HammingWindow;

typedef struct {
    DeltaPosition delta;
    HammingEpistemicCell cell;
    uint8_t azimuth;
} ProjectedDeltaCell;

typedef struct {
    ProjectedDeltaCell ll;
    ProjectedDeltaCell mm;
    ProjectedDeltaCell nn;
    uint16_t orientation_word;
} GnomonicDelta3Projection;
```

The canonical routing table is:

```c
static const IntegrityAxis DELTA_AXIS[3] = {
    AXIS_LOGOS,
    AXIS_NOMOS,
    AXIS_PATHOS
};
```

The routed diagonal witness may be extracted as:

```c
uint8_t delta3_axis_witness(
    const Delta3HammingWindow *window
) {
    uint8_t ll_logos =
        (window->ll.syndrome3 >> 0) & 1u;

    uint8_t mm_nomos =
        (window->mm.syndrome3 >> 1) & 1u;

    uint8_t nn_pathos =
        (window->nn.syndrome3 >> 2) & 1u;

    return (uint8_t)(
        ll_logos |
        (mm_nomos << 1) |
        (nn_pathos << 2)
    );
}
```

This must be typed as:

```text
Delta3AxisWitness
```

not:

```text
HammingSyndrome
```

because the bit semantics differ.

---

# 22. Complete Narrative Alignment

The names now form one coherent narrative.

```text
FS/GS/RS/US
establish where the relation is scoped

LOGOS/NOMOS/PATHOS
determine whether the scoped relation is coherent

LL/MM/NN
place that coherent or incoherent relation in time

Gnomonic Projection Azimuth
orients the temporal relation for inspection
```

Readable form:

```text
Scope says where it belongs.

Integrity says whether it holds together.

Delta says when it stands.

Azimuth says how it appears from here.
```

The routed triad becomes:

```text
LOGOS remembers the previous relation.

NOMOS adjudicates the present relation.

PATHOS carries the forward relation.
```

The projection layer then says:

```text
The relation has been checked.

The temporal position has been identified.

Now orient it for observation.
```

---

# 23. Authority Boundaries

The following distinctions are mandatory.

```text
Hamming validity
is not semantic truth

Delta position
is not Hamming correction

Azimuth orientation
is not validation

Projection
is not acceptance

Receipt
records the accepted result
```

The Gnomonic Projection Azimuth must not correct Hamming errors.

The Hamming decoder must not alter Delta3 position.

Delta3 shifting must not imply semantic acceptance.

The projection orientation must not alter the underlying accepted relation.

Canonical authority sequence:

```text
decode

check

correct locally where allowed

place temporally

validate

receipt

project
```

---

# 24. Compact Canonical Model

```text
DATA
=
FS GS RS US

CHECK
=
LOGOS NOMOS PATHOS

HAMMING CELL
=
[LOGOS NOMOS FS PATHOS GS RS US]

DELTA WINDOW
=
LL MM NN

CANONICAL ROUTING
=
LL→LOGOS
MM→NOMOS
NN→PATHOS

AZIMUTH
=
0x00..0xFF

BALANCED ORIENTATION WORDS
=
0x55AA
0xAA55
```

The complete object is:

```text
GnomonicDelta3Projection
=
Azimuth(
  Delta3(
    HammingCell(scope)
  )
)
```

---

# 25. One-Line Canon

> FS, GS, RS, and US carry the bounded scope object; LOGOS, NOMOS, and PATHOS form its Hamming integrity surface; LL, MM, and NN place successive integrity-checked cells into previous, present, and forward temporal positions; and the Gnomonic Projection Azimuth orients that checked Delta3 relation over the byte circle `0x00..0xFF`, with `0x55AA` and `0xAA55` serving as complementary balanced projection phases rather than parity syndromes or temporal states.

---

# 26. Final Canon Lock

```text
FS/GS/RS/US
is scope.

LOGOS/NOMOS/PATHOS
is integrity.

LL/MM/NN
is temporal position.

0x00..0xFF
is byte azimuth.

0x55AA / 0xAA55
are complementary balanced projection phases.

The Hamming syndrome says:
which incidence position is inconsistent.

Delta3 says:
whether the cell is previous, present, or forward.

The Gnomonic Projection Azimuth says:
how the checked temporal relation is oriented for observation.

The canonical routing is:

LL → LOGOS
MM → NOMOS
NN → PATHOS

This routing is a diagonal projection
of the complete 3×3 temporal-integrity matrix.

It does not rename the Hamming syndrome.

It does not collapse time into integrity.

It does not collapse projection into validation.

Scope carries.

Integrity checks.

Delta moves.

Azimuth orients.

Receipt records.
```
