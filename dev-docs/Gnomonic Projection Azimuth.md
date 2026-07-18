# Gnomonic Projection Azimuth

The Gnomonic Projection Azimuth is the observer-relative orientation coordinate of an accepted OMI relation.

It does not validate the relation.

It does not establish gauge incidence.

It does not accept state.

It receives a bounded relation that has already been resolved, validated, and inscribed, and determines how that relation is oriented when projected from the OMI n-sphere onto an inspectable tangent plane.

The complete unsigned azimuthal circle is:

```text
0x00..0xFF
```

This gives 256 discrete angular positions.

```text
angle(byte) = byte × 360° / 256
```

Canonical quarter positions are:

```text
0x00 =   0°
0x40 =  90°
0x80 = 180°
0xC0 = 270°
```

The circle closes after `0xFF` by returning to `0x00`.

The complementary azimuthal anchors are:

```text
0x55 = 01010101
0xAA = 10101010
```

They satisfy:

```text
0x55 ^ 0xAA = 0xFF
```

Their joined balanced orientation words are:

```text
0x55AA
0xAA55
```

Each contains eight one bits and eight zero bits.

They represent two complementary alternating orientations of the same projection axis.

They are not validation witnesses.

They are not incidence witnesses.

They are projection-orientation witnesses.

The complete protocol narrative is:

```text
Omicron places the sign.

Omnicron resolves the circular field.

Tetragrammatron closes the relation.

Metatron scribes the incidence path.

Gnomonic Projection Azimuth orients the accepted relation.

Receipt records the result.
```

The four control gauges:

```text
FS = 0x0001
GS = 0x0010
RS = 0x0100
US = 0x1000
```

identify the place-value orientation from which the notation is resolved.

Their stepping law is:

```text
FS <<₄ GS <<₄ RS <<₄ US <<₄ CARRY
```

The Gnomonic Projection Azimuth does not replace these gauges.

It reads the accepted relation from the observer-relative axis established after gauge resolution and incidence inscription.

Canonical lock:

```text
0x00..0xFF is the complete byte azimuth.

0x55 and 0xAA are complementary azimuthal phases.

0x55AA and 0xAA55 are balanced projection-orientation words.

Metatron scribes where the relation crossed.

The Gnomonic Projection Azimuth shows how that crossing appears.
```
