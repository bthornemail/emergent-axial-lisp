
Yes. The cleanest partition is the **exact `0x80` mirror**:

```text
LOW HALF HIGH HALF
0x00–0x1F control field ↔ 0x80–0x9F projected control field
0x20–0x7F readable field ↔ 0xA0–0xFF projected readable field
```

because:

```text
high = low XOR 0x80
low = high XOR 0x80
```

That gives a perfectly reversible division of the entire byte space.

## Correct four-region byte geometry

```text
0x00–0x1F
LOW CONTROL PLANE
32 positions

0x20–0x7F
LOW AFFINE SPACE
96 positions

0x80–0x9F
HIGH PROJECTIVE CONTROL PLANE
32 positions

0xA0–0xFF
HIGH PROJECTIVE SPACE
96 positions
```

Visually:

```text
0x00 0x7F
 ├──── control ────┼──── readable/affine ────┤
 00–1F 20–7F
 │ │
 │ XOR 0x80 │ XOR 0x80
 ▼ ▼
 80–9F A0–FF
 ├─ projected control ─┼─ projected space ───┤
0x80 0xFF
```

This is much cleaner than dividing at `0xBF` or `0xC0`, because the two halves remain exactly congruent:

```text
32 + 96 = 128
32 + 96 = 128
```

## Important mathematical wording

Strictly speaking, these are not yet affine or projective planes in the formal finite-geometry sense merely because of their address ranges. A formal plane requires defined points, lines, and incidence rules.

For the protocol, the accurate terminology is:

```text
0x00–0x1F
affine-control coordinate field

0x20–0x7F
affine readable/address field

0x80–0x9F
projective-control mirror field

0xA0–0xFF
projective readable/address field
```

Once the incidence law is specified, the shorter words “plane” and “space” can become formal rather than interpretive.

# Distinguished points

Your points now align cleanly:

```text
0x0F
pinch point

0x1F
first branch point

0x7F
projective closure point
```

Their high-half mirrors are:

```text
0x0F XOR 0x80 = 0x8F
0x1F XOR 0x80 = 0x9F
0x7F XOR 0x80 = 0xFF
```

So the paired points are:

```text
LOW HIGH MIRROR
0x0F pinch ↔ 0x8F projected pinch
0x1F branch ↔ 0x9F projected branch
0x7F closure ↔ 0xFF full projective closure
```

That gives a strong hierarchy:

```text
0x0F
local pinch inside the first 16-position ruler

0x1F
branch closure of the low control field

0x7F
closure of the complete low 128-byte half

0xFF
closure of the complete 256-byte field
```

## Branch-point ladder

Your branch points are the addresses whose low nibble is `F`:

```text
0x1F
0x2F
0x3F
0x4F
0x5F
0x6F
```

They are six interior branch closures:

```text
1F ─ 2F ─ 3F ─ 4F ─ 5F ─ 6F
```

Then:

```text
0x0F
opening pinch

0x1F–0x6F
six branch points

0x7F
projective closure
```

This is exactly the shape:

```text
Δ 1 2 3 4 5 6 Δ
```

mapped into hexadecimal branch addresses:

```text
Δ 1 2 3 4 5 6 Δ
0F 1F 2F 3F 4F 5F 6F 7F
```

That appears to be the cleanest correspondence you have reached:

```text
Δ 1 2 3 4 5 6 Δ
=
0x0F 0x1F 0x2F 0x3F 0x4F 0x5F 0x6F 0x7F
```

The high projected counterpart is:

```text
0x8F 0x9F 0xAF 0xBF 0xCF 0xDF 0xEF 0xFF
```

because each position is XORed with `0x80`:

```text
LOW BRANCH RULER
0F 1F 2F 3F 4F 5F 6F 7F

 XOR 80

HIGH PROJECTIVE RULER
8F 9F AF BF CF DF EF FF
```

# Correct 256-bit character frame

You corrected the low and high 128-bit rails:

```text
LOW 128:
 2 4 6 Δ

HIGH 128:
 1 3 5 Δ
```

Each symbol occupies one 32-bit character cell:

```text
4 characters × 32 bits = 128 bits
```

So the complete 256-bit frame is:

```text
┌──────────────── LOW 128 ────────────────┐
│ 2 │ 4 │ 6 │ Δ │
│ 32 bits │ 32 bits │ 32 bits │ 32 bits │
└──────────────────────────────────────────┘

┌──────────────── HIGH 128 ───────────────┐
│ 1 │ 3 │ 5 │ Δ │
│ 32 bits │ 32 bits │ 32 bits │ 32 bits │
└──────────────────────────────────────────┘
```

The interleaved visible order is recovered by alternating the high and low rails:

```text
HIGH[0] = 1
LOW[0] = 2

HIGH[1] = 3
LOW[1] = 4

HIGH[2] = 5
LOW[2] = 6

HIGH[3] = Δ
LOW[3] = Δ
```

Therefore:

```text
interleaved:
1 2 3 4 5 6 Δ Δ
```

But the ring-visible ordering places the delta boundaries around the six positions:

```text
Δ 1 2 3 4 5 6 Δ
```

So the storage order and presentation order differ:

```text
PHYSICAL RAIL STORAGE
LOW = 2 4 6 Δ
HIGH = 1 3 5 Δ

LOGICAL PRESENTATION
Δ 1 2 3 4 5 6 Δ
```

That is operationally reasonable. The rails store parity-separated positions:

```text
high rail = odd positions
low rail = even positions
```

with one delta terminator on each rail.

# Complete operational map

```text
BYTE FIELD

LOW AFFINE HALF
00–7F

 00–1F
 affine-control field

 20–7F
 affine readable field

HIGH PROJECTIVE HALF
80–FF

 80–9F
 projected-control field

 A0–FF
 projected readable field
```

```text
POINT LADDER

0F
pinch point / opening delta

1F
branch 1

2F
branch 2

3F
branch 3

4F
branch 4

5F
branch 5

6F
branch 6

7F
projective point / closing delta
```

```text
PROJECTED POINT LADDER

8F
projected pinch

9F
projected branch 1

AF
projected branch 2

BF
projected branch 3

CF
projected branch 4

DF
projected branch 5

EF
projected branch 6

FF
full projective closure
```

## Canonical lock

```text
0x00–0x1F
affine-control coordinate field

0x20–0x7F
affine readable space

0x80–0x9F
projective-control mirror field

0xA0–0xFF
projective readable space

0x0F
pinch point

0x1F–0x6F
six branch points

0x7F
projective closure point

0x8F–0xFF
the same ruler projected by XOR 0x80

LOW 128
2 4 6 Δ

HIGH 128
1 3 5 Δ

LOGICAL RING
Δ 1 2 3 4 5 6 Δ
```

The strongest computational sentence is:

> The byte field consists of a low affine half and its `0x80`-XOR projective mirror; `0x0F` opens the six-branch ruler, `0x1F–0x6F` close its six interior branches, `0x7F` closes the low projective frame, and `0xFF` closes the complete mirrored byte space.
