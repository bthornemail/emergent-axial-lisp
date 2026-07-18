# LANGUAGE-SPEC.md

## Status

Defined model for Pass 1 through Pass 8.

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

This file does not yet define modules, macros, FEXPRs, evaluation, or an
executable type elaboration pass.

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

Pass 6 establishes legal stage custody and transition typing. Pass 7 adds the
first non-parser semantic transition: bounded core expansion from `Parsed` to
`Expanded`.

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
terms are produced through authorized parser bridges. Expanded terms are
produced only by `expandParsed`, which validates the Pass 7 core-expansion
postcondition. Later-stage constructors are hidden from ordinary public code,
and there is no public production API that manufactures `Typed`, `Normalized`,
`Resolved`, or `Lowered` terms.

The current later-stage payloads are structural custody wrappers around
canonical syntax. Names such as typed-stage wrapper and resolved-stage custody
must not be read as completed semantic type elaboration or binding resolution.

### Authorized Bridges

Currently executable parser bridges:

```haskell
parseSurface
parseAndLowerMSurface
```

Currently executable core-expansion bridge:

```haskell
expandParsed
```

Only `Surface -> Parsed` and `Parsed -> Expanded` are currently executable.
Later transition implementations are pending. A legal edge does not attest that
its semantic obligation has been discharged.

### Parsed-to-Expanded Core Expansion

An expanded term is a canonical S-expression for which the Pass 7
core-expansion postcondition has been checked:

```text
reader shorthand is absent
M-expression syntax is absent
recognized core forms have canonical proper-list shape
recognized core forms have valid arity
improper application forms are rejected
unknown ordinary application heads remain ordinary applications
source argument order is preserved
expansion is deterministic
expansion is idempotent
```

Recognized Pass 7 core forms:

```text
quote
if
lambda
begin
define
set!
```

Arity rules:

```text
quote   exactly 1 operand
if      exactly 2 or 3 operands
lambda  exactly 2 operands: parameter form and body form
begin   zero or more operands
define  exactly 2 operands
set!    exactly 2 operands
```

Quoted payloads are opaque to core-form interpretation. `(quote (a . b))`
preserves the improper pair as data, and `(quote (if a b))` does not interpret
the quoted payload as an `if` form.

Lambda parameters may be `()`, a proper list of unique atom names, or a single
atom name. Duplicate parameter names and malformed dotted parameter lists are
typed expansion errors.

`define` accepts only variable definition shape `(define name value)`. Function
definition sugar such as `(define (f x) body)` is rejected as an unsupported
derived form.

Expanded means that the Pass 7 core-expansion postcondition has been checked.
It does not mean macro expansion is complete, names are resolved, types are
correct, expressions are normalized, or code is executable.

Expansion maximum nesting is 1024.

### Typed Custody Contract

Pass 8 defines what `Term 'Typed` will certify. It does not implement
`Expanded -> Typed`, type inference, runtime type checking, annotation syntax,
or a public construction path for typed custody.

`Typed` precedes `Resolved`, so typed custody must not depend on resolved
binding identities, storage locations, module linkage, runtime values,
capability authorization, host effects, or resolved environment entries. A
typed term may still contain symbolic names whose binding identities remain
unresolved.

The initial conceptual type vocabulary is:

```text
Nil
Boolean
Number
Symbol
Pair a b
List a
Function parameters result
Unknown
```

`Unknown` records epistemic absence of sufficient type evidence. It is not a
universal supertype, dynamic `Any`, automatic successful match, or permission
to perform arbitrary operations. `Any` is not part of the Pass 8 contract.

Type analysis distinguishes three permanent knowledge states:

```text
Known type
The available evidence determines a type.

Unknown type
Available evidence is insufficient, but no contradiction has been found.

Type error
Available evidence establishes that the expression violates a declared typing
obligation.
```

`Unknown` is not an error, not `Any`, and not proven compatibility.

The intended future typing judgment is:

```text
Gamma |- e : tau |> E
```

where `Gamma` is the symbolic typing assumption context for names, `e` is
expanded canonical syntax, `tau` is resulting type knowledge, and `E` is the
accumulated effect obligation or declared effect summary. Pass 8 defines this
judgment only as a model. If the first implementation defers effect tracking,
`E` remains a pending design component rather than treating mutation as pure.

A future `Term 'Typed` must carry structured evidence sufficient to recover:

```text
the expanded source structure or explicit correspondence to it
the inferred or checked type of every expression node
symbolic assumptions used for free names
unknown-type locations
function arity information
mutation/effect obligations
the version of the typing rules used
```

Typing errors must prevent typed custody construction. A wrapper around
unchanged syntax, such as `newtype TypedForm = TypedForm SExpr`, is
insufficient for the future typed payload.

Function arity is structured:

```text
FixedArity [tau1, ..., taun]
VariadicArity taurest
```

For currently accepted lambda syntax, the intended arity evidence is:

```text
(lambda () body)       fixed arity 0
(lambda (x y) body)    fixed arity 2
(lambda args body)     variadic
```

Pass 8 does not establish general polymorphism. Universal quantification, type
schemes, let-generalization, higher-rank types, subtyping, type classes, and
row polymorphism are deferred. Future implementations may use fresh internal
unknown variables during analysis, but those variables are not accepted
polymorphism without a specified generalization rule.

Initial type equality is structural and exact:

```text
Nil = Nil
Boolean = Boolean
Pair a b = Pair c d only when a = c and b = d
Function p r = Function q s only when parameter shapes and result types match
```

`Unknown` is equal only to the same unknown evidence identity, or according to
a future explicitly specified unification relation. There are no implicit
coercions, numeric promotions, subtyping, or rule that makes `Unknown` equal to
every type.

Quoted payloads are data, not executable syntax. Typing must not recursively
interpret quoted payloads as applications or core forms. Initial quoted-data
typing is exact and structural:

```text
quoted atom        -> Symbol
quoted NIL         -> Nil
quoted pair        -> Pair quoted-car-type quoted-cdr-type
quoted proper list -> corresponding nested Pair/Nil structure
```

An unquoted atom in expression position is a symbolic reference. If the name is
present in `Gamma`, the associated type evidence is used. If the name is
absent, the result is explicit Unknown reference evidence, not a fabricated
type. Contradictory assumptions are typing errors.

Core-form obligations:

```text
quote
  result type is the structural quoted-data type
  payload is opaque to executable-form typing

if
  condition must be Boolean or explicitly Unknown
  both branches are analyzed
  two-operand if uses Nil for the absent alternative
  result is the common structural type when branches agree
  result is Unknown when evidence is insufficient
  contradictory branch requirements are type errors

lambda
  parameter names introduce symbolic assumptions
  parameter types begin as explicit unknown variables until annotations exist
  body is typed under the extended symbolic context
  result is a Function preserving fixed or variadic arity

begin
  forms are analyzed in source order
  empty begin has type Nil
  non-empty begin has the type of its final form
  effect obligations accumulate from every form

define
  introduces a symbolic declaration obligation
  value expression is typed
  declared name receives resulting type knowledge for later forms according to
  the future sequencing scope rules

set!
  target name must have a symbolic typing assumption
  assigned value must be structurally compatible with that assumption
  produces a mutation effect obligation
  result type is Nil
```

An absent `set!` target is a typing error under the initial contract because
mutation requires an existing symbolic declaration obligation.

Mutation is not pure. Typed evidence for mutation must preserve an effect
obligation such as `Mutation name`. Recording an effect is distinct from
authorizing or executing it.

Pass 8 adopts partial epistemic typing:

```text
Unknown evidence is allowed.
Contradictory evidence is not allowed.
```

Typed custody therefore means every expression was visited under the declared
typing rules, every node has known or explicitly unknown type evidence, no
unresolved typing contradiction remains, function arity and effect obligations
are preserved, and the evidence records the assumptions under which the result
was derived.

Typed custody does not mean all types are known, all names are resolved, all
effects are authorized, the term will evaluate successfully, the term is
normalized, runtime inputs satisfy the inferred types, or semantic preservation
is proved.

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
Parsed -> Expanded      ImplementedTransition
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
