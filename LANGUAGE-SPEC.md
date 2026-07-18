# LANGUAGE-SPEC.md

## Status

Defined model for Pass 1 through Pass 6.

## Canonical SEXPR

Canonical syntax is represented by:

```text
NIL
ATOM
PAIR
```

Proper and improper lists are distinct structures.

```lisp
(A B C)
```

is:

```lisp
(A . (B . (C . NIL)))
```

while:

```lisp
(A B . C)
```

is:

```lisp
(A . (B . C))
```

## Current Non-Authority

This file does not yet define modules, macros, FEXPRs, evaluation, or type elaboration.

## Parser Shorthand

The canonical parser accepts quote shorthand only as syntax sugar:

```text
'form   -> (quote form)
`form   -> (quasiquote form)
,form   -> (unquote form)
,@form  -> (unquote-splicing form)
```

These parse directly into ordinary canonical S-expression lists. No
quote-specific constructors are part of canonical `SExpr`.

`printCanonical` emits expanded list form, not shorthand.

## Canonical Semantic Serialization

Pass 4 defines a deterministic binary identity encoding that is separate from
`printCanonical`.

Serialization records canonical structure. It does not validate
application-level meaning, accept a declaration, project a runtime view, or
grant capabilities.

### Envelope

Every top-level canonical value is encoded as:

```text
magic bytes
format version
value tag
payload
```

The committed Pass 4 envelope is:

```text
magic:   45 41 4c 53
meaning: ASCII "EALS"
version: 01
```

Incompatible future changes require a new format version.

### Value Tag Registry

```text
10 CanonicalSExpr
20 CanonicalScope
21 CanonicalStructural
22 CanonicalBinding
23 CanonicalEval
24 CanonicalStage
25 CanonicalTime
26 CanonicalIntegrity
27 CanonicalCarrier
28 CanonicalProjection
29 CanonicalCapability
30 CanonicalByteCoord
31 CanonicalCar32
32 CanonicalCdr32
33 CanonicalOriginId
34 CanonicalResolverProfileId
```

Reserved or unknown value tags are rejected.

### S-Expression Payload Tags

```text
00 NIL
01 ATOM
02 PAIR
```

`PAIR` encodes its `CAR` payload followed by its `CDR` payload. Lists are not a
separate canonical type.

### Axis Payload Tags

All axis tags are explicit and do not derive from `Enum`, `Show`, or compiler
representation.

```text
ScopeAxis:      FS 00, GS 01, RS 02, US 03
StructuralAxis: Car 00, Cdr 01, Cons 02
BindingAxis:    BCar 00, BCdr 01, APVal 02, APVal1 03,
                Subr 04, FSubr 05, Expr 06, FExpr 07
EvalAxis:       Eager 00, Lazy 01, Special 02, Macro 03,
                Reflective 04, Quoted 05
StageAxis:      Surface 00, Parsed 01, Expanded 02, Typed 03,
                Normalized 04, Resolved 05, Lowered 06
TimeAxis:       LL 00, MM 01, NN 02
IntegrityAxis:  Logos 00, Nomos 01, Pathos 02
CarrierAxis:    LowControl 00, LowAffine 01,
                HighControl 02, HighProjective 03
ProjectionAxis: NoProjection 00, CharacterProjection 01,
                BitboardProjection 02, CanvasProjection 03,
                PortProjection 04, AzimuthProjection 05
Capability:     PureCapability 00, MemoryCapability 01,
                StorageCapability 02, NetworkCapability 03,
                ClockCapability 04, ForeignCapability 05,
                ProjectionCapability 06
```

### Integers, Lengths, and Limits

All multibyte integers use network byte order / big-endian.

Textual atoms, `OriginId`, and `ResolverProfileId` encode as:

```text
uint16-be byte length
strict UTF-8 bytes
```

Limits:

```text
maximum atom byte length: 256
maximum identity byte length: 256
maximum S-expression nesting: 1024
```

`ByteCoord` encodes as exactly one byte. `Car32` and `Cdr32` encode as fixed
32-bit big-endian payloads and remain distinguishable through their enclosing
value tags.

### Canonical Rejection

The decoder rejects invalid magic, unsupported versions, unknown tags,
truncated payloads, invalid UTF-8, invalid atoms, oversized text, excessive
nesting, and trailing bytes after one complete value.

## M-Expression Lowering

Pass 5 defines a deliberately small readable M-expression surface.

M-expression syntax is readable input. It is not canonical runtime identity.
Lowering does not evaluate, resolve bindings, validate application semantics,
grant capabilities, or modify serialization tags.

### Source AST

The readable surface parses into a separate source AST:

```haskell
data MExpr
  = MAtom Text
  | MCall Text [MExpr]
```

This AST is distinct from canonical `SExpr`.

### Grammar

```text
expression :=
    identifier
  | identifier "(" arguments? ")"

arguments :=
    expression ("," expression)*
```

Whitespace may occur around identifiers, commas, and parentheses. Comments are
not part of the Pass 5 M-expression grammar.

### Operators

Operator recognition is case-sensitive. The recognized operators are:

```text
CONS
CAR
CDR
LIST
QUOTE
```

Bare identifiers lower to canonical atoms. Calls with unrecognized operator
names return a typed `unknown operator` lowering error. No locale-dependent
case conversion is performed.

### Arity

```text
CONS  exactly 2
CAR   exactly 1
CDR   exactly 1
QUOTE exactly 1
LIST  zero or more
```

Incorrect arity is a typed lowering error.

### Lowering

```text
CONS(a, b)     -> (cons a b)
CAR(x)         -> (car x)
CDR(x)         -> (cdr x)
LIST(a, b, c)  -> (list a b c)
LIST()         -> (list)
QUOTE(x)       -> (quote x)
```

Nested expressions lower recursively while preserving argument order.

### Limits

```text
maximum M-expression identifier byte length: 256
maximum M-expression nesting depth: 1024
maximum arguments per call: 256
```

## Stage-Indexed Custody

Pass 6 establishes legal stage custody and transition typing.

It does not implement semantic macro expansion. It does not establish type
correctness. It does not normalize language meaning. It does not resolve
bindings. It does not produce executable target code.

### Stage Vocabulary

The closed stage vocabulary is `StageAxis`:

```text
Surface
Parsed
Expanded
Typed
Normalized
Resolved
Lowered
```

The diagnostic canonical stage path is:

```text
Surface -> Parsed -> Expanded -> Typed -> Normalized -> Resolved -> Lowered
```

`Lowered` has no automatic successor.

### Indexed Terms

Stage-indexed terms carry type-level custody evidence:

```haskell
Term 'Surface
Term 'Parsed
Term 'Expanded
Term 'Typed
Term 'Normalized
Term 'Resolved
Term 'Lowered
```

Public callers may construct only surface input with `surfaceForm`. Parsed
terms are produced through authorized parser bridges. Later-stage constructors
are hidden from ordinary public code, and there is no public production API
that manufactures `Expanded`, `Typed`, `Normalized`, `Resolved`, or `Lowered`
terms.

The current later-stage payloads are structural custody wrappers around
canonical syntax. Names such as typed-stage wrapper and resolved-stage custody
must not be read as completed semantic type elaboration or binding resolution.

### Authorized Bridges

Currently executable parser bridges:

```haskell
parseSurface
parseAndLowerMSurface
```

Only `Surface -> Parsed` is currently executable. Later transition
implementations are pending. A legal edge does not attest that its semantic
obligation has been discharged.

### Transition Witnesses

Legal transition witnesses are exactly:

```text
Surface -> Parsed
Parsed -> Expanded
Expanded -> Typed
Typed -> Normalized
Normalized -> Resolved
Resolved -> Lowered
```

There is no witness for `Parsed -> Resolved`, `Lowered -> Surface`,
`Typed -> Parsed`, or any transition originating at `Lowered`.

### Transition Availability

The Pass 6A transition availability table is diagnostic metadata only:

```text
Surface -> Parsed       ImplementedTransition
Parsed -> Expanded      PendingTransition
Expanded -> Typed       PendingTransition
Typed -> Normalized     PendingTransition
Normalized -> Resolved  PendingTransition
Resolved -> Lowered     PendingTransition
```

Pending transition entries do not execute and do not grant custody.

### Existential Terms

External heterogeneous storage uses `SomeTerm`, which retains an
`SStageAxis stage` witness with the staged term. Code cannot safely use the
payload at a specific stage without checking or otherwise recovering the stage
evidence.
