# AGENTS.md

## Emergent Axial Lisp / Meta-CONS Runtime

**Status:** Normative implementation contract  
**Audience:** Coding agents, maintainers, reviewers, and formalization contributors  
**Primary language:** Haskell  
**Secondary targets:** Coq, C99, WebAssembly, Omnicron ISA  
**Project:** Emergent Axial Lisp  
**Runtime:** Meta-CONS Runtime  
**Architecture:** Multi-Axial Runtime Model  
**Reflective protocol:** Meta-CONS Metaobject Protocol  

---

# 0. Mission

Implement **Emergent Axial Lisp** as a portable, embeddable, homoiconic, multi-stage declarative language whose canonical CONS structures are evaluated by the **Meta-CONS Runtime** through typed axes of:

```text
scope
structure
binding
origin
evaluation
stage
time
integrity
carrier
projection
capability
```

The implementation MUST preserve the distinction between:

```text
declaration
typing
resolution
recovery
validation
acceptance
recording
projection
reflection
host effects
```

No implementation layer may silently inherit the authority of another.

The implementation MUST NOT restore the deprecated fixed 8-tuple as the runtime object model. The authoritative runtime object is an emergent typed relation assembled from active declarations, scopes, bindings, origins, stages, and resolver profiles.

---

# 1. Canonical identity

The project names are fixed:

```text
LANGUAGE
Emergent Axial Lisp

SUBTITLE
A Homoiconic Multi-Axial Declarative Language
for the Meta-CONS Runtime

ARCHITECTURE
Multi-Axial Runtime Model

RUNTIME
Meta-CONS Runtime

REFLECTIVE PROTOCOL
Meta-CONS Metaobject Protocol
```

These names are not interchangeable.

## 1.1 Emergent Axial Lisp owns

```text
canonical SEXPR syntax
readable MEXPR syntax
quotation and quasiquotation
macros
FEXPR and special forms
typed modules
declarative metadata
metaobject declarations
multi-stage lowering forms
capability requests
```

## 1.2 Multi-Axial Runtime Model owns

```text
axis definitions
legal coordinate combinations
dispatch rules
stage transitions
resolver profiles
recovery laws
authority boundaries
```

## 1.3 Meta-CONS Runtime owns

```text
environment construction
ordered CONS resolution
coproduct composition
quasigroup recovery
staged evaluation
reflection
capability mediation
module loading
target lowering
embedding
```

## 1.4 Meta-CONS Metaobject Protocol owns

```text
class inspection
scope inspection
binding inspection
origin inspection
stage inspection
evaluation-policy inspection
time inspection
integrity inspection
carrier inspection
recovery-law inspection
lowering inspection
projection inspection
capability inspection
```

Reflection does not automatically grant mutation.

---

# 2. Authority hierarchy

All agents MUST obey this hierarchy:

```text
formal proof
    establishes a theorem

conformance test
    establishes tested implementation behavior

reference implementation
    establishes one executable realization

language specification
    defines normative semantics

architecture document
    defines responsibilities and boundaries

projection
    displays a view only
```

Never claim that:

```text
a diagram proves a theorem
a projection validates a relation
a passing parser test proves semantic preservation
a Haskell type alone proves a Coq theorem
a carrier address is canonical identity
a visible byte is the complete relation
```

Use explicit claim status when documenting new work:

```text
proved
implemented
tested
defined_model
interpretation
proposal
```

---

# 3. Non-negotiable semantic laws

## 3.1 Homoiconicity

Canonical programs and canonical data MUST share one structural representation.

The canonical representation is an S-expression tree constructed from:

```text
NIL
ATOM
PAIR
```

Proper and improper lists MUST remain distinguishable.

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

No printer, parser, serializer, projection, or adapter may collapse this distinction.

---

## 3.2 MEXPR lowering

MEXPR is a readable surface.

SEXPR is canonical structure.

Every valid MEXPR MUST lower deterministically to exactly one canonical SEXPR.

The lowering relation MUST satisfy:

```text
same MEXPR input
→ same canonical SEXPR output
```

MEXPR MUST NOT introduce semantic forms that have no canonical SEXPR representation.

---

## 3.3 Ordered CAR/CDR relation

The canonical structural relation is ordered:

```lisp
(CAR . CDR)
```

Do not assume:

```text
CONS(CAR, CDR) = CONS(CDR, CAR)
```

unless a specific resolver profile proves that property.

Bitwise operations such as OR, AND, and XOR may be commutative while structural identity remains ordered.

---

## 3.4 CONS roles

CONS has several distinct roles:

```text
Structural CONS
constructs a pair

Resolver CONS
combines ordered CAR and CDR coordinates

Quasigroup CONS
supports recovery of a missing coordinate

Coproduct CONS
mediates independent origin-tagged contributions

Centroid CONS
resolves four scoped tetrahedral contributions

Reflective Meta-CONS
exposes the mechanism by which an object is interpreted
```

Do not collapse these roles into one untyped function.

---

## 3.5 Projection non-authority

Projection may render:

```text
characters
bitboards
canvas nodes
ports
azimuths
debug views
```

Projection MUST NOT:

```text
validate
accept
mutate canonical identity
erase provenance
replace full CAR/CDR coordinates
grant host capability
```

---

## 3.6 Pure core before effects

The following phases MUST remain pure:

```text
parse
MEXPR lowering
macro expansion
type elaboration
normalization
resolution
quasigroup recovery
core lowering
canonical serialization
```

Effects belong outside the semantic core.

The effect runtime may provide:

```text
module loading
storage
network access
clock access
foreign calls
projection output
```

through explicit capabilities only.

---

# 4. Closed axes

Use closed algebraic data types for fixed coordinate families.

```haskell
data ScopeAxis
  = FS
  | GS
  | RS
  | US

data StructuralAxis
  = Car
  | Cdr
  | Cons

data BindingAxis
  = BCar
  | BCdr
  | APVal
  | APVal1
  | Subr
  | FSubr
  | Expr
  | FExpr

data EvalAxis
  = Eager
  | Lazy
  | Special
  | Macro
  | Reflective
  | Quoted

data StageAxis
  = Surface
  | Parsed
  | Expanded
  | Typed
  | Normalized
  | Resolved
  | Lowered

data TimeAxis
  = LL
  | MM
  | NN

data IntegrityAxis
  = Logos
  | Nomos
  | Pathos

data CarrierAxis
  = LowControl
  | LowAffine
  | HighControl
  | HighProjective

data ProjectionAxis
  = NoProjection
  | CharacterProjection
  | BitboardProjection
  | CanvasProjection
  | PortProjection
  | AzimuthProjection

data Capability
  = PureCapability
  | MemoryCapability
  | StorageCapability
  | NetworkCapability
  | ClockCapability
  | ForeignCapability
  | ProjectionCapability
```

Do not use strings for these coordinates inside the trusted core.

Adapters may parse strings into validated typed values.

---

# 5. Scope model

The four canonical scope coordinates are:

```text
FS
frame or file scope

GS
group or graph scope

RS
record or relation scope

US
unit or symbol scope
```

Scope answers:

```text
where does this declaration apply?
```

Scope does not answer:

```text
is it valid?
what time is it?
what is its Hamming syndrome?
how should it be projected?
```

The four scopes also form the vertices of the tetrahedral scope object:

```text
A = FS
B = GS
C = RS
D = US
```

Six edges:

```text
FS-GS
FS-RS
FS-US
GS-RS
GS-US
RS-US
```

Four faces:

```text
FS-GS-RS
FS-GS-US
FS-RS-US
GS-RS-US
```

The centroid is not a fifth scope.

---

# 6. Binding model

The environment classes are:

```text
CAR
CDR
APVAL
APVAL1
SUBR
FSUBR
EXPR
FEXPR
```

Their meanings are:

```text
CAR
carried structural coordinate

CDR
continuation or resolver coordinate

APVAL
primary value binding

APVAL1
alternate, shadow, auxiliary, or scoped value binding

SUBR
system-defined ordinary function

FSUBR
system-defined special form

EXPR
user-defined ordinary function

FEXPR
user-defined special form
```

Evaluation policy:

```text
SUBR
evaluate operands before invocation

EXPR
evaluate operands before invocation

FSUBR
pass operand forms unevaluated

FEXPR
pass operand forms unevaluated
```

Do not redefine APVAL1 as lazy evaluation unless a separate profile explicitly says so.

---

# 7. Environment model

For symbol `s` and scope `σ`:

```text
E_σ(s)
```

may contain:

```text
CAR
CDR
APVAL
APVAL1
SUBR
FSUBR
EXPR
FEXPR
```

The complete environment is:

```text
E(s) =
[E_FS(s) : E_GS(s) : E_RS(s) : E_US(s)]
```

This gives a conceptual:

```text
4 scopes × 8 environment classes = 32 typed positions
```

Agents MUST preserve these as two independent axes:

```text
scope
where the binding applies

binding class
what kind of binding it is
```

Do not collapse scope and binding into one enum.

---

# 8. Temporal and integrity axes

## 8.1 Temporal Delta3

```text
LL
previous

MM
present

NN
forward
```

LL/MM/NN are temporal positions.

They are not deprecated.

They are not Hamming syndrome bits.

## 8.2 Integrity3

```text
LOGOS
NOMOS
PATHOS
```

Compact Hamming order:

```text
[LOGOS NOMOS FS PATHOS GS RS US]
```

Parity equations:

```text
LOGOS = FS XOR GS XOR US
NOMOS = FS XOR RS XOR US
PATHOS = GS XOR RS XOR US
```

Canonical routed diagonal:

```text
LL → LOGOS
MM → NOMOS
NN → PATHOS
```

This is a routing relation through the complete:

```text
Delta3 × Integrity3
```

matrix.

Do not equate time with integrity.

---

# 9. Carrier geometry

The byte field is fixed by the exact `XOR 0x80` mirror:

```text
0x00–0x1F
low control coordinate field

0x20–0x7F
low affine readable field

0x80–0x9F
high projective-control mirror field

0xA0–0xFF
high projective readable field
```

Mirror law:

```text
mirror(x) = x XOR 0x80
mirror(mirror(x)) = x
```

Agents MUST NOT introduce alternate byte hierarchies that replace this lock.

The following are compatible views of the same byte field:

```text
low/high mirror
four 32-position sectors
eight 27+5 environment bands
shared 256-position blackboard
scope-key-local coordinate decompositions
```

These are views, not competing identities.

---

# 10. Sparse 256-bit boards

Each independent source may contribute one selected rank-8 predicate:

```text
256 input coordinates
1 output bit per coordinate
256 total bits
```

The runtime stores one selected board, not the full population of `2^256` predicates.

Canonical Haskell representation:

```haskell
newtype Board256 =
  Board256 (Word64, Word64, Word64, Word64)
```

Required operations:

```text
empty
singleton
test
set
clear
union
intersection
symmetricDifference
difference
complement
popCount
serialize
deserialize
```

All operations MUST be bounded to 256 bits.

---

# 11. Origin-preserving coproduct

Independent modules MUST enter through tagged injection.

For source boards `B_i`:

```text
B = ⨆ B_i
```

Each contribution is:

```text
(origin, local-coordinate, payload)
```

Two contributions may share one visible byte while remaining distinct:

```text
(RULES.o, 0x48) ≠ (FACTS.o, 0x48)
```

The shared blackboard projection may map both to `0x48`, but the runtime MUST preserve the complete fiber behind that coordinate.

A visible coordinate MUST NOT erase:

```text
source
scope
binding
CAR
CDR
resolver profile
stage
time
integrity
carrier
version
```

---

# 12. Quasigroup recovery

A resolver profile may implement a quasigroup operation:

```text
CAR * CDR = CONS
CAR \ CONS = CDR
CONS / CDR = CAR
```

Required laws:

```text
leftDivide a (qmul a b) = b
rightDivide (qmul a b) b = a
qmul a (leftDivide a c) = c
qmul (rightDivide c b) b = c
```

Do not call a resolver profile a quasigroup unless all four laws hold over its declared domain.

Plain XOR is not sufficient as the complete ordered structural identity because:

```text
a XOR b = b XOR a
```

An acceptable bounded affine profile may use:

```text
qmul(a,b) = P(a) XOR Q(b) XOR k
```

where `P` and `Q` are distinct invertible transforms.

Every normative resolver profile requires:

```text
Haskell implementation
exhaustive finite-domain conformance tests where feasible
negative tests
Coq proof before the profile is declared formally proved
```

---

# 13. Projective tetrahedral scope coordinate

Each scope carries a scoped CONS relation:

```text
X_FS = CONS_FS(CAR_FS, CDR_FS)
X_GS = CONS_GS(CAR_GS, CDR_GS)
X_RS = CONS_RS(CAR_RS, CDR_RS)
X_US = CONS_US(CAR_US, CDR_US)
```

The unresolved projective scope coordinate is:

```text
P = [X_FS : X_GS : X_RS : X_US]
```

or:

```text
P = [CONS_FS : CONS_GS : CONS_RS : CONS_US]
```

The affine readable relation is a selected chart or realization of that projective object.

The centroid is:

```text
the balanced shared relation induced by all four scoped contributions
```

The centroid is not:

```text
a fifth vertex
a fifth scope
a Q4 state
a new byte region
```

---

# 14. Parser and syntax requirements

The parser MUST support:

```text
atoms
NIL
proper lists
improper lists
dotted pairs
quote
quasiquote
unquote
module forms
typed declarations
metadata forms
```

Parser requirements:

```text
deterministic
total over valid input
explicit error locations
bounded recursion or protected stack behavior
canonical round-trip printer
no hidden evaluation during parsing
```

Required law:

```text
parse(printCanonical(ast)) = ast
```

for every canonical AST.

---

# 15. Multi-stage compilation

The fixed stage progression is:

```text
Surface
→ Parsed
→ Expanded
→ Typed
→ Normalized
→ Resolved
→ Lowered
```

Each pass MUST declare:

```text
input stage
output stage
required invariants
preserved invariants
possible errors
required capabilities
```

Do not allow a later-stage constructor to be forged by ordinary public code.

Use hidden constructors or smart constructors where necessary.

---

# 16. Macro and FEXPR boundary

## 16.1 Macros

Macros:

```text
receive syntax
return syntax
run before ordinary evaluation
must preserve canonical source structure
must not use undeclared host effects
```

## 16.2 FEXPRs

FEXPRs:

```text
run during evaluation
receive unevaluated operand forms
may decide whether and how operands are evaluated
must declare evaluation policy and capabilities
```

Do not treat macros and FEXPRs as synonyms.

---

# 17. Haskell implementation rules

## 17.1 Use algebraic data types for closed facts

Use ADTs for:

```text
axes
errors
syntax constructors
stages
capabilities
object classes
resolver identifiers
```

## 17.2 Use GADTs for indexed syntax and legal state

Use GADTs where the type system should prevent:

```text
evaluating an unparsed source
lowering an untyped term
projecting an unresolved object
recovering under an unknown profile
forging a validated stage
```

## 17.3 Use type families for computed relationships

Use type families for:

```text
NextStage
EvalPolicy
Mirror
legal carrier transitions
profile result types
scope-specific admissibility
```

## 17.4 Use type classes only for open behavior

Appropriate classes include:

```haskell
class Resolvable a where
  type Resolved a
  resolve :: a -> Either ResolveError (Resolved a)

class Reflective a where
  metaobject :: a -> MetaObject

class Lowerable source target where
  lower :: source -> Either LowerError target

class Projectable source target where
  project :: source -> Either ProjectionError target

class Quasigroup q where
  qmul :: q -> q -> q
  leftDivide :: q -> q -> q
  rightDivide :: q -> q -> q
```

Do not model every noun as a type class.

## 17.5 Use newtypes for bounded values

Use hidden constructors and smart constructors for:

```text
ByteCoord
Car32
Cdr32
OriginId
Board256
ModuleId
ResolverProfileId
LogicalTime
```

## 17.6 Existentials only at extension boundaries

Existential packages are allowed for:

```text
heterogeneous module declarations
runtime-loaded resolver profiles
adapter registries
target registries
```

Every existential MUST carry the witnesses required for safe use.

---

# 18. Pure semantic API

The initial pure API SHOULD include:

```haskell
parse
  :: SurfaceSource
  -> Either ParseError ParsedModule

lowerMExpr
  :: MExpr
  -> Either MExprError ParsedExpr

expand
  :: ExpansionEnv
  -> ParsedModule
  -> Either ExpansionError ExpandedModule

elaborate
  :: TypeEnv
  -> ExpandedModule
  -> Either TypeError TypedModule

normalize
  :: TypedModule
  -> Either NormalizeError NormalizedModule

resolveModule
  :: ResolverEnv
  -> NormalizedModule
  -> Either ResolveError ResolvedModule

lowerModule
  :: Target target
  -> ResolvedModule
  -> Either LowerError (Program target)

serializeCanonical
  :: Canonical a
  => a
  -> ByteString
```

Do not add IO to these functions.

---

# 19. Effect runtime

Use a separate effect layer such as:

```haskell
newtype MetaConsT m a =
  MetaConsT
    { unMetaConsT ::
        ReaderT RuntimeCapabilities
          (StateT RuntimeState
            (ExceptT RuntimeError
              (WriterT [RuntimeEvent] m))) a
    }
```

The transformer stack may change after profiling, but the following separation is fixed:

```text
pure semantics determine meaning

effect runtime supplies capabilities
```

Capabilities MUST be explicit.

No ambient access to:

```text
filesystem
network
clock
foreign calls
projection output
```

---

# 20. Metaobject protocol requirements

Every inspectable runtime declaration SHOULD expose:

```text
class
scope
binding
origin
stage
evaluation policy
time
integrity
carrier
projection
recovery profile
lowering rule
capabilities
```

Required reflective functions:

```text
classOf
scopeOf
bindingOf
originOf
stageOf
evaluationPolicyOf
timeOf
integrityOf
carrierOf
projectionOf
recoveryLawOf
capabilitiesOf
```

Reflective mutation requires:

```text
explicit reflective capability
legal stage transition
revalidation
preservation of canonical identity
```

---

# 21. Repository layout

Use this initial structure:

```text
emergent-axial-lisp/
├── AGENTS.md
├── README.md
├── CHARTER.md
├── WHITEPAPER.md
├── LANGUAGE-SPEC.md
├── MULTI-AXIAL-TYPE-MODEL.md
├── META-CONS-RUNTIME.md
├── METAOBJECT-PROTOCOL.md
├── CONFORMANCE.md
├── SECURITY.md
├── PORTABILITY.md
├── cabal.project
├── emergent-axial-lisp.cabal
│
├── src/
│   ├── Emergent/
│   │   ├── Syntax.hs
│   │   ├── Parser.hs
│   │   ├── Printer.hs
│   │   ├── MExpr.hs
│   │   ├── Quote.hs
│   │   ├── Macro.hs
│   │   ├── Module.hs
│   │   └── Error.hs
│   │
│   ├── MetaCons/
│   │   ├── Kernel.hs
│   │   ├── Axis.hs
│   │   ├── Singleton.hs
│   │   ├── Bounded.hs
│   │   ├── Environment.hs
│   │   ├── Binding.hs
│   │   ├── Resolver.hs
│   │   ├── Quasigroup.hs
│   │   ├── Coproduct.hs
│   │   ├── Bitboard.hs
│   │   ├── Tetrahedral.hs
│   │   ├── Temporal.hs
│   │   ├── Integrity.hs
│   │   ├── Carrier.hs
│   │   ├── Reflect.hs
│   │   ├── Evaluate.hs
│   │   ├── Normalize.hs
│   │   ├── CoreIR.hs
│   │   ├── Lower.hs
│   │   ├── Runtime.hs
│   │   ├── Capability.hs
│   │   └── Error.hs
│   │
│   └── Adapter/
│       ├── Markdown.hs
│       ├── Canvas.hs
│       ├── Port.hs
│       ├── OmnicronISA.hs
│       ├── C99.hs
│       └── Wasm.hs
│
├── app/
│   ├── Main.hs
│   └── Repl.hs
│
├── test/
│   ├── Unit/
│   ├── Property/
│   ├── Golden/
│   ├── Conformance/
│   └── Negative/
│
├── proof/
│   ├── Syntax.v
│   ├── Stage.v
│   ├── Scope.v
│   ├── Integrity.v
│   ├── Quasigroup.v
│   ├── Coproduct.v
│   ├── Preservation.v
│   └── README.md
│
├── vectors/
│   ├── syntax.yaml
│   ├── mexpr.yaml
│   ├── scope4.yaml
│   ├── binding8.yaml
│   ├── compact743.yaml
│   ├── delta3.yaml
│   ├── recovery.yaml
│   ├── coproduct.yaml
│   ├── board256.yaml
│   └── carrier-mirror.yaml
│
└── examples/
    ├── hello.eal
    ├── dotted-pair.eal
    ├── scoped-bindings.eal
    ├── fexpr.eal
    ├── macro.eal
    ├── coproduct-board.eal
    ├── quasigroup-recovery.eal
    └── reflective-evaluator.eal
```

Do not create all files as empty placeholders.

Create files only when their immediate contract is defined and tested.

---

# 22. Initial implementation order

## Pass 0 — Repository foundation

Create:

```text
AGENTS.md
README.md
CHARTER.md
WHITEPAPER.md
cabal.project
package file
CI build
formatting config
```

Required checks:

```text
cabal build
cabal test
hlint
ormolu/fourmolu check
```

## Pass 1 — Kernel

Implement:

```text
NIL
Atom
Pair
CAR
CDR
canonical equality
canonical printer
```

Tests:

```text
proper list round trip
improper list round trip
deep pair equality
NIL behavior
printer determinism
```

## Pass 2 — Parser

Implement:

```text
atoms
lists
dotted pairs
quote
quasiquote
unquote
source spans
```

Tests:

```text
valid forms
invalid forms
round trip
error offsets
deep nesting limits
```

## Pass 3 — Axes

Implement:

```text
closed ADTs
DataKinds promotion
singletons
bounded smart constructors
serialization tags
```

Tests:

```text
all values round trip
invalid tags reject
mirror involution
```

## Pass 4 — Binding environment

Implement:

```text
scoped environment
origin-qualified bindings
APVAL/APVAL1
SUBR/FSUBR
EXPR/FEXPR
ambiguity reporting
```

## Pass 5 — Staging

Implement:

```text
stage-indexed forms
MEXPR lowering
macro expansion interface
type elaboration skeleton
```

## Pass 6 — Board256 and coproduct

Implement:

```text
Board256
tagged source injection
visible occupancy
fiber preservation
overlap report
```

## Pass 7 — Quasigroup profile

Implement one small finite lawful profile first.

Do not begin with the most elaborate intended profile.

Required:

```text
qmul
leftDivide
rightDivide
exhaustive law tests
negative altered-profile test
```

## Pass 8 — Temporal and integrity

Implement:

```text
Delta3
Integrity3
compact Hamming [7,4,3]
syndrome mapping
single-position correction
diagonal routing
```

## Pass 9 — Tetrahedral scope object

Implement:

```text
four vertices
six edges
four faces
centroid resolver interface
projective tuple
affine chart view
```

## Pass 10 — Metaobject protocol

Implement read-only reflection first.

Mutation comes later.

## Pass 11 — Effect runtime

Implement capability-mediated module loading and projection output.

## Pass 12 — Lowering

Implement debug IR target before ISA/C/WASM.

## Pass 13 — Formalization

Promote only stable laws to Coq.

No `Admitted`.

No placeholder theorem names claiming success.

---

# 23. Required tests

Every pass MUST add tests before being called complete.

## 23.1 Unit tests

Test local constructors and operations.

## 23.2 Property tests

Use QuickCheck or Hedgehog for:

```text
parse/print round trips
mirror involution
Board256 algebra
quasigroup laws
coproduct origin preservation
serialization round trips
stage transition consistency
```

## 23.3 Golden tests

Use golden files for:

```text
canonical SEXPR printing
MEXPR lowering
Core IR output
projection output
error messages
```

## 23.4 Negative compile-time tests

Use compile-fail fixtures or `should-not-typecheck` style tests for:

```text
lowering an untyped term
projecting an unresolved term
forging a validated stage
mixing scopes without an explicit bridge
using unavailable capabilities
constructing invalid byte coordinates
using a resolver without evidence
```

## 23.5 Conformance vectors

Vectors MUST be language-neutral.

Haskell, C, Coq extraction, and future runtimes should consume the same vector semantics.

---

# 24. Formal proof rules

The proof directory is authoritative only for files that:

```text
compile with coqc
contain no Admitted
contain no admit
contain no untracked Axiom
contain no placeholder Parameters replacing the theorem
```

Every proof file MUST state:

```text
what is proved
what is defined
what is assumed
what remains unproved
```

Initial proof priorities:

```text
mirror involution
quasigroup recovery
parser or lowering determinism
stage preservation
origin preservation under coproduct projection
compact Hamming correctness
```

Do not attempt to prove the entire runtime at once.

---

# 25. Error model

Use typed error ADTs.

Do not return unstructured strings from the core.

At minimum:

```haskell
data ParseError
data MExprError
data ExpansionError
data TypeError
data NormalizeError
data ResolveError
data RecoveryError
data ProjectionError
data CapabilityError
data LowerError
data RuntimeError
```

Each error SHOULD carry:

```text
error class
source span where applicable
scope
binding
origin
stage
human-readable message
machine-readable details
```

---

# 26. Serialization rules

Canonical serialization MUST preserve:

```text
pair order
proper/improper list distinction
scope
binding
origin
stage
time
integrity
carrier
projection metadata
resolver profile
board data
extension fields
```

Separate:

```text
semantic digest
canonical runtime identity

projection digest
one rendered representation
```

Changing layout or color must not change semantic identity unless layout or color is explicitly semantic in that profile.

---

# 27. Adapters

Adapters are declaration or projection surfaces.

They are not authority.

Adapters may include:

```text
Markdown
JSON Canvas
OMI-Lisp compatibility syntax
OMI-Port
Omnicron ISA
C99
WASM
DOM
SVG
hardware carriers
```

Every adapter MUST define:

```text
input schema
output schema
lossless fields
lossy fields
authority boundary
round-trip guarantee, if any
```

No adapter may redefine canonical semantics.

---

# 28. Security boundaries

The runtime MUST assume that modules may be:

```text
untrusted
remote
malformed
ambiguous
resource-exhausting
capability-seeking
```

Required protections:

```text
bounded parser recursion
bounded board sizes
bounded word widths
explicit capability grants
origin tagging
module size limits
evaluation fuel or step limits
projection output limits
no ambient IO
no implicit FFI
```

FEXPR and macro execution require especially strict resource and capability controls.

---

# 29. Performance boundaries

Correctness and determinism come before optimization.

Do not introduce:

```text
unsafePerformIO
unchecked pointer casts
mutable global state
representation-dependent hashes
parallel evaluation that changes observable order
```

unless the optimization is isolated, documented, benchmarked, and proven observationally equivalent.

Recommended early data structures:

```text
Map for environments
Set for capabilities
Vector for ordered fixed collections
strict ByteString for serialization
small strict records for metaobjects
four Word64 values for Board256
```

---

# 30. Coding standards

## Haskell

Use:

```text
NoImplicitPrelude only if a local prelude is created immediately
explicit export lists
total pattern matches
-Wall
-Wcompat
-Werror in CI after bootstrap stabilization
DerivingStrategies
NamedFieldPuns
RecordWildCards only sparingly
```

Avoid:

```text
partial functions
head
tail
fromJust
undefined
error in library code
unsafeCoerce
String for canonical byte data
```

## Coq

Use:

```text
small definitions
explicit theorem statements
standard tactics
lia/ring/vm_compute only where appropriate
no pseudo-Coq syntax
no unexplained axioms
```

## C targets

Use:

```text
C99 or later as declared
fixed-width integers
opaque handles
explicit ownership
no hidden global allocator
canonical error codes
```

---

# 31. Documentation requirements

Every core module MUST document:

```text
purpose
authority
non-authority
invariants
public constructors
error conditions
laws
tests
```

Every major mathematical claim MUST be labeled:

```text
proved
tested
implemented
defined_model
interpretation
```

Do not describe a model as mathematically established when it is only encoded or tested.

---

# 32. Commit discipline

Each implementation pass SHOULD be one reviewable commit or a short series of tightly related commits.

Commit message style:

```text
Pass N: Add canonical pair kernel
Pass N: Add parser round-trip tests
Pass N: Add Board256 coproduct fibers
Pass N: Prove mirror involution
```

Do not mix:

```text
large renames
semantic changes
formatting
generated files
proof changes
```

in one commit without necessity.

---

# 33. Completion criteria

A pass is complete only when:

```text
code compiles
tests pass
formatting passes
documentation is updated
no placeholder implementation remains
negative cases are covered
authority boundary is stated
```

A feature is not complete because a type exists.

A theorem is not complete because the intended statement is written.

A runtime path is not complete because a projection renders.

---

# 34. Immediate first task for the coding agent

Begin with **Pass 0 and Pass 1 only**.

Create the repository foundation and implement the canonical pair kernel.

The first executable milestone is:

```text
parse or construct a canonical dotted pair
print it deterministically
recover CAR
recover CDR
round-trip proper and improper lists
```

Do not begin:

```text
networking
Canvas
WASM
ISA lowering
remote modules
full macro system
full meta-circular evaluator
advanced quasigroup profiles
```

until the pair kernel, parser, printer, and tests are stable.

---

# 35. First milestone deliverables

The first milestone MUST contain:

```text
AGENTS.md
README.md
CHARTER.md
WHITEPAPER.md
cabal.project
package manifest
src/Emergent/Syntax.hs
src/Emergent/Printer.hs
src/MetaCons/Kernel.hs
test/Unit/KernelSpec.hs
test/Property/RoundTripSpec.hs
```

Minimum API:

```haskell
data Atom
data SExpr
nil
atom
cons
car
cdr
isNil
isAtom
isPair
printCanonical
```

Minimum tests:

```text
NIL prints canonically
atom prints canonically
pair prints canonically
proper list prints canonically
improper list prints canonically
CAR recovers left
CDR recovers right
canonical print is deterministic
canonical AST equality is structural
```

---

# 36. Final implementation lock

```text
Emergent Axial Lisp is the language.

Meta-CONS is the runtime.

SEXPR is canonical.

MEXPR lowers deterministically.

The runtime is multi-axial, not fixed-tuple.

CAR/CDR preserve order.

CONS resolves and recovers.

FS/GS/RS/US provide scope.

APVAL/APVAL1/SUBR/FSUBR/EXPR/FEXPR provide binding class.

LL/MM/NN provide temporal position.

LOGOS/NOMOS/PATHOS provide integrity.

Origins enter by tagged coproduct injection.

Sparse boards are exactly 256 bits.

The visible byte plane is a projection.

The full relation and provenance remain behind every visible coordinate.

Closed facts are ADTs.

Legal transitions are GADTs and type families.

Open behavior is expressed by type classes.

Pure semantics precede effects.

Effects require explicit capabilities.

Reflection does not grant authority.

Validation and projection remain separate.

No fixed 8-tuple is authoritative.

No proof uses Admitted.

No carrier redefines canonical meaning.
```