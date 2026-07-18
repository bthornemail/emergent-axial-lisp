# IMPLEMENTATION-PLAN.md

## Emergent Axial Lisp and the Meta-CONS Runtime

**Status:** Ready for implementation
**Primary language:** Haskell
**Formal verification:** Coq
**Portable targets:** Debug Core IR, Omnicron ISA, C99, WebAssembly
**Normative implementation contract:** `AGENTS.md`

---

# 0. Mission

Build **Emergent Axial Lisp** as a homoiconic, multi-stage, multi-axial declarative language evaluated by the **Meta-CONS Runtime**.

The initial implementation must establish a small, deterministic, testable semantic kernel before adding:

```text
macros
FEXPRs
remote modules
coproduct blackboards
quasigroup recovery
reflection
ISA lowering
network or hardware adapters
```

The coding agent must work in ordered passes.

Do not implement later architectural layers before the earlier invariants are stable.

---

# 1. Required reading before coding

Read these files in this order:

```text
1. AGENTS.md
2. WHITEPAPER.md
3. CHARTER.md
4. LANGUAGE-SPEC.md, when created
5. MULTI-AXIAL-TYPE-MODEL.md, when created
6. META-CONS-RUNTIME.md, when created
7. CONFORMANCE.md, when created
```

Before every implementation pass, identify:

```text
the owned authority
the explicit non-authority
the data types being introduced
the laws being enforced
the tests that will demonstrate the behavior
```

Do not begin coding from names alone.

---

# 2. Global execution rule

Use the following loop for every pass:

```text
1. Define the smallest semantic contract.

2. Define data types and errors.

3. Implement the pure operation.

4. Add unit tests.

5. Add property tests where applicable.

6. Add negative cases.

7. Add canonical serialization or printing where applicable.

8. Run the complete test suite.

9. Update documentation.

10. Commit the completed pass.
```

A pass is incomplete if:

```text
the code builds but has no tests
the happy path works but invalid input is unspecified
constructors allow invalid states
a placeholder remains
documentation claims more than the code establishes
```

---

# 3. Repository bootstrap

Create:

```text
emergent-axial-lisp/
├── AGENTS.md
├── IMPLEMENTATION-PLAN.md
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
├── src/
├── app/
├── test/
├── vectors/
├── proof/
└── examples/
```

Do not create dozens of empty source files.

Create a source file only when its contract is implemented in the current pass.

---

# 4. Build and quality configuration

Configure:

```text
GHC
Cabal
Hspec or Tasty
QuickCheck or Hedgehog
Fourmolu or Ormolu
HLint
GitHub Actions or the available CI system
```

Initial compiler warnings:

```text
-Wall
-Wcompat
-Wincomplete-record-updates
-Wincomplete-uni-patterns
-Wredundant-constraints
```

Do not enable `-Werror` until the bootstrap pass is stable.

Required bootstrap commands:

```bash
cabal build all
cabal test all
fourmolu --mode check .
hlint .
```

---

# 5. Pass 0 — Constitutional repository foundation

## Objective

Establish the repository, build system, documentation hierarchy, and CI without implementing advanced runtime behavior.

## Create

```text
README.md
CHARTER.md
LANGUAGE-SPEC.md
MULTI-AXIAL-TYPE-MODEL.md
META-CONS-RUNTIME.md
METAOBJECT-PROTOCOL.md
CONFORMANCE.md
SECURITY.md
PORTABILITY.md
```

These documents may begin as bounded specifications, but they must not contain invented implementation claims.

## README minimum content

```text
project identity
language/runtime distinction
repository map
current implementation status
build commands
authority boundaries
first milestone
```

## Completion gate

```text
repository builds
empty test executable runs
formatting passes
lint passes
CI passes
documentation names are consistent
```

## Commit

```text
Pass 0: Bootstrap Emergent Axial Lisp repository
```

---

# 6. Pass 1 — Canonical CONS kernel

## Objective

Implement the irreducible homoiconic object:

```text
NIL
ATOM
PAIR
```

## Files

```text
src/MetaCons/Kernel.hs
src/Emergent/Syntax.hs
src/Emergent/Printer.hs
src/Emergent/Error.hs

test/Unit/KernelSpec.hs
test/Property/KernelProperties.hs
```

## Required types

```haskell
data Atom
data SExpr
```

Recommended initial structure:

```haskell
data SExpr
  = Nil
  | AtomExpr Atom
  | Pair SExpr SExpr
```

Do not expose representation-dependent constructors if doing so would make later invariants difficult to preserve.

## Required API

```haskell
nil
atom
cons
car
cdr
isNil
isAtom
isPair
list
toProperList
printCanonical
```

`car` and `cdr` must return typed errors rather than crash.

## Required laws

```text
CAR(CONS(a,b)) = a

CDR(CONS(a,b)) = b

canonical equality is structural

canonical printing is deterministic
```

## Required tests

```text
NIL
atom
pair
nested pair
proper list
improper list
empty list
CAR success
CDR success
CAR failure on atom
CDR failure on NIL
deterministic printing
```

## Completion gate

No parser yet.

The kernel must be constructible and testable directly from Haskell.

## Commit

```text
Pass 1: Implement canonical Meta-CONS pair kernel
```

---

# 7. Pass 2 — Canonical S-expression parser

## Objective

Parse canonical S-expressions without evaluation.

## Files

```text
src/Emergent/Parser.hs
src/Emergent/SourceSpan.hs

test/Unit/ParserSpec.hs
test/Property/ParserRoundTrip.hs
test/Golden/Parser/
```

## Syntax supported

```text
NIL
symbols
strings, if included in the initial atom profile
integers, if included in the initial atom profile
proper lists
dotted pairs
quote
quasiquote
unquote
comments
```

Do not add every intended literal type in this pass.

Start with a deliberately small atom grammar.

## Required properties

```text
parse(printCanonical(ast)) = ast

parser output is deterministic

invalid dotted syntax is rejected

extra trailing forms are handled explicitly

source errors include line and column
```

## Security requirements

```text
bounded token length
bounded nesting or explicit parser resource policy
no evaluation during parsing
no host file access
```

## Completion gate

The following must round-trip exactly:

```lisp
NIL
a
(a . b)
(a b c)
(a b . c)
'form
```

## Commit

```text
Pass 2: Add canonical S-expression parser
```

---

# 8. Pass 3 — Multi-axial type foundation

## Objective

Implement the closed runtime axes as typed data.

## Files

```text
src/MetaCons/Axis.hs
src/MetaCons/Singleton.hs
src/MetaCons/Bounded.hs

test/Unit/AxisSpec.hs
test/Property/AxisProperties.hs
```

## Implement

```text
ScopeAxis
StructuralAxis
BindingAxis
EvalAxis
StageAxis
TimeAxis
IntegrityAxis
CarrierAxis
ProjectionAxis
Capability
```

## Type-level support

Use:

```text
DataKinds
GADTs
singleton witnesses
type families
```

Do not introduce a dependency-heavy singleton framework unless it materially improves the implementation.

Handwritten singleton witnesses are acceptable for the initial closed axes.

## Required type families

```haskell
EvalPolicy
NextStage
Mirror
```

## Required laws

```text
Mirror(Mirror(x)) = x

SUBR → Eager

EXPR → Eager

FSUBR → Special

FEXPR → Special
```

## Negative tests

Ensure ordinary public code cannot:

```text
invent an unknown scope
invent an unknown stage
construct an invalid byte coordinate
claim an impossible stage transition
```

## Commit

```text
Pass 3: Add closed multi-axial type model
```

---

# 9. Pass 4 — Canonical serialization

## Objective

Create a deterministic byte representation of the kernel and axes.

## Files

```text
src/MetaCons/Serialize.hs

test/Property/SerializationProperties.hs
test/Golden/Serialization/
```

## Preserve

```text
pair order
proper versus improper lists
atom type
scope
binding
stage
origin
```

## Required laws

```text
decode(encode(x)) = x

encode(x) is deterministic
```

Separate:

```text
canonical semantic encoding
human-readable printing
```

Do not use a JSON object as the canonical identity format.

JSON may be added later as an adapter.

## Commit

```text
Pass 4: Add canonical semantic serialization
```

---

# 10. Pass 5 — M-expression lowering

## Objective

Add a small human-readable M-expression surface that lowers into canonical S-expressions.

## Files

```text
src/Emergent/MExpr.hs
src/Emergent/MExpr/Parser.hs
src/Emergent/MExpr/Lower.hs

test/Unit/MExprSpec.hs
test/Property/MExprProperties.hs
test/Golden/MExpr/
```

## Initial M-expression surface

Start with a minimal operator form such as:

```text
CONS(a, b)
CAR(x)
CDR(x)
```

Lower to:

```lisp
(cons a b)
(car x)
(cdr x)
```

Do not start with the full projective notation.

## Required law

```text
one valid MEXPR
→ exactly one canonical SEXPR
```

## Completion gate

M-expression parsing and lowering must be entirely separate from evaluation.

## Commit

```text
Pass 5: Add deterministic M-expression lowering
```

---

# 11. Pass 6 — Staged syntax

## Objective

Represent legal compilation stages in the type system.

## Files

```text
src/Emergent/Stage.hs
src/Emergent/Parsed.hs
src/Emergent/Expanded.hs
src/Emergent/Typed.hs
src/Emergent/Normalized.hs
src/Emergent/Resolved.hs
```

Use only as many files as are needed to keep contracts clear.

## Required progression

```text
Surface
→ Parsed
→ Expanded
→ Typed
→ Normalized
→ Resolved
→ Lowered
```

## Rules

```text
a parser produces Parsed

macro expansion consumes Parsed and produces Expanded

type elaboration consumes Expanded and produces Typed

normalization consumes Typed and produces Normalized

resolution consumes Normalized and produces Resolved

lowering consumes Resolved and produces target code
```

Do not allow arbitrary conversion functions between stages.

## Negative tests

The following must fail to type-check:

```text
lowering Parsed directly

projecting an unresolved term as canonical output

constructing Resolved directly through a public constructor
```

## Commit

```text
Pass 6: Add stage-indexed language pipeline
```

---

# 12. Pass 7 — Scoped binding environment

## Objective

Implement symbol lookup through independent scope and binding axes.

## Files

```text
src/MetaCons/Origin.hs
src/MetaCons/Binding.hs
src/MetaCons/Environment.hs
src/MetaCons/Dispatch.hs

test/Unit/EnvironmentSpec.hs
test/Property/EnvironmentProperties.hs
```

## Required classes

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

## Required lookup behaviors

Value position:

```text
APVAL
APVAL1
```

Operator position:

```text
SUBR
FSUBR
EXPR
FEXPR
```

## Required dimensions

A binding key must retain:

```text
symbol
scope
binding class
origin
```

Later axes may be added without changing the base relation.

## Ambiguity

If two incomparable bindings are admissible:

```text
return an ambiguity error
```

Do not choose by map ordering or module load order.

## Commit

```text
Pass 7: Add scoped origin-qualified binding environment
```

---

# 13. Pass 8 — Minimal evaluator

## Objective

Evaluate the canonical kernel with ordinary and special dispatch.

## Files

```text
src/MetaCons/Value.hs
src/MetaCons/Evaluate.hs
src/MetaCons/Primitive.hs

test/Unit/EvaluatorSpec.hs
test/Property/EvaluatorProperties.hs
```

## Initial values

```text
NIL
atoms
pairs
primitive functions
closures
special forms
```

## Initial primitives

```text
cons
car
cdr
atom?
pair?
nil?
quote
if
```

Do not add IO.

## Evaluation policy

```text
SUBR
evaluated operands

FSUBR
unevaluated operands

EXPR
user closure with evaluated operands

FEXPR
user closure with unevaluated operands
```

## Resource limits

Introduce evaluation fuel or another deterministic step limit before supporting user-defined recursive evaluation.

## Commit

```text
Pass 8: Add pure scoped Meta-CONS evaluator
```

---

# 14. Pass 9 — Macro expansion

## Objective

Add hygienic or explicitly scoped syntax transformation before ordinary evaluation.

## Files

```text
src/Emergent/Macro.hs
src/Emergent/SyntaxObject.hs

test/Unit/MacroSpec.hs
test/Property/MacroProperties.hs
```

## Boundary

```text
macro
Parsed/Expanded transformation

FEXPR
runtime special evaluation
```

Do not implement macros by calling the full unrestricted evaluator.

Use a bounded expansion environment.

## Required protections

```text
expansion depth limit
source-span preservation
origin preservation
no ambient effects
```

## Commit

```text
Pass 9: Add bounded macro expansion stage
```

---

# 15. Pass 10 — Board256

## Objective

Implement the bounded 256-position contribution board.

## Files

```text
src/MetaCons/Bitboard.hs

test/Unit/BitboardSpec.hs
test/Property/BitboardProperties.hs
vectors/board256.yaml
```

## Representation

```haskell
newtype Board256 =
  Board256 (Word64, Word64, Word64, Word64)
```

## Operations

```text
empty
full
singleton
test
set
clear
union
intersection
difference
symmetric difference
complement
pop count
serialization
```

## Laws

```text
union is associative

intersection is associative

symmetric difference with self is empty

difference never creates new bits

all indices are between 0 and 255
```

## Commit

```text
Pass 10: Implement bounded Board256 algebra
```

---

# 16. Pass 11 — Origin-preserving coproduct blackboard

## Objective

Allow independent modules to contribute tagged boards without losing origin.

## Files

```text
src/MetaCons/Coproduct.hs
src/MetaCons/Blackboard.hs
src/MetaCons/Fiber.hs

test/Unit/CoproductSpec.hs
test/Property/CoproductProperties.hs
vectors/coproduct.yaml
```

## Contribution record

Each contribution must include:

```text
origin
scope
binding
CAR
CDR
board
resolver profile
stage
version
```

## Required behavior

```text
inject contribution

compute visible occupancy

preserve one fiber per visible coordinate

report overlaps

never silently merge origins
```

## Core property

Two contributions may project to the same byte while remaining distinct objects.

```text
(origin-A, 0x48) ≠ (origin-B, 0x48)
```

## Commit

```text
Pass 11: Add origin-preserving coproduct blackboard
```

---

# 17. Pass 12 — First quasigroup resolver profile

## Objective

Implement one small, fully testable reversible resolver.

## Files

```text
src/MetaCons/Quasigroup.hs
src/MetaCons/Resolver.hs
src/MetaCons/Resolver/Profile0.hs

test/Unit/QuasigroupSpec.hs
test/Property/QuasigroupProperties.hs
vectors/recovery.yaml
```

## Requirements

Implement:

```text
qmul
leftDivide
rightDivide
```

Prove by exhaustive tests over the profile’s finite domain:

```text
left recovery
right recovery
left reconstruction
right reconstruction
```

Do not call the profile canonical until all laws pass.

Do not begin with a 32-bit domain if exhaustive testing is impractical.

Begin with a small domain such as:

```text
4-bit
8-bit
```

Then lift the law in a later pass.

## Commit

```text
Pass 12: Add first lawful finite quasigroup resolver
```

---

# 18. Pass 13 — Scoped CONS resolution

## Objective

Bind the structural relation to resolver profiles.

## Files

```text
src/MetaCons/Cons.hs
src/MetaCons/Coordinate.hs

test/Unit/ConsResolutionSpec.hs
test/Property/ConsResolutionProperties.hs
```

## Operations

```text
resolve CAR CDR → CONS

recover CAR CONS → CDR

recover CONS CDR → CAR
```

## Preserve

```text
operand order
origin
scope
resolver profile
full coordinate
visible projection, if requested separately
```

The resolver must return a full relation object, not only a byte.

## Commit

```text
Pass 13: Add typed CAR/CDR/CONS resolution
```

---

# 19. Pass 14 — Temporal Delta3

## Objective

Implement the independent temporal axis.

## Files

```text
src/MetaCons/Temporal.hs

test/Unit/TemporalSpec.hs
vectors/delta3.yaml
```

## Values

```text
LL
previous

MM
present

NN
forward
```

## Requirements

```text
explicit transitions
no equation with integrity bits
canonical serialization
complete vector coverage
```

## Commit

```text
Pass 14: Add Delta3 temporal coordinates
```

---

# 20. Pass 15 — Compact Hamming integrity

## Objective

Implement the Hamming `[7,4,3]` integrity surface.

## Files

```text
src/MetaCons/Integrity.hs
src/MetaCons/Hamming743.hs

test/Unit/Hamming743Spec.hs
test/Property/Hamming743Properties.hs
vectors/compact743.yaml
```

## Canonical order

```text
[LOGOS NOMOS FS PATHOS GS RS US]
```

## Equations

```text
LOGOS = FS XOR GS XOR US

NOMOS = FS XOR RS XOR US

PATHOS = GS XOR RS XOR US
```

## Syndrome mapping

```text
000 no error
001 LOGOS
010 NOMOS
011 FS
100 PATHOS
101 GS
110 RS
111 US
```

## Required tests

```text
all 16 scope assignments

all seven single-position corruptions

no-error case

correction round trip
```

## Commit

```text
Pass 15: Add compact Hamming scope integrity
```

---

# 21. Pass 16 — Temporal-integrity routing

## Objective

Represent the `Delta3 × Integrity3` matrix and its canonical routed diagonal.

## Files

```text
src/MetaCons/TemporalIntegrity.hs

test/Unit/TemporalIntegritySpec.hs
```

## Canonical routing

```text
LL → LOGOS
MM → NOMOS
NN → PATHOS
```

## Boundary

This is a routing selection.

It does not make:

```text
LL equal LOGOS
MM equal NOMOS
NN equal PATHOS
```

## Commit

```text
Pass 16: Add temporal-integrity routing matrix
```

---

# 22. Pass 17 — Carrier mirror

## Objective

Implement the exact byte carrier geometry.

## Files

```text
src/MetaCons/Carrier.hs

test/Unit/CarrierSpec.hs
test/Property/CarrierProperties.hs
vectors/carrier-mirror.yaml
```

## Regions

```text
0x00–0x1F low control

0x20–0x7F low affine

0x80–0x9F high projective control

0xA0–0xFF high projective
```

## Law

```text
mirror(x) = x XOR 0x80
mirror(mirror(x)) = x
```

Test all 256 byte values exhaustively.

## Commit

```text
Pass 17: Add exact XOR-0x80 carrier mirror
```

---

# 23. Pass 18 — Tetrahedral scope model

## Objective

Implement the four vertices, six edges, four faces, and centroid interface.

## Files

```text
src/MetaCons/Tetrahedral.hs
src/MetaCons/Projective.hs
src/MetaCons/Affine.hs

test/Unit/TetrahedralSpec.hs
```

## Projective object

```text
[CONS_FS : CONS_GS : CONS_RS : CONS_US]
```

## Required objects

```text
four scoped vertices
six typed edges
four typed faces
centroid resolver input
affine chart view
```

Do not define the centroid as a fifth vertex.

## Commit

```text
Pass 18: Add tetrahedral projective scope model
```

---

# 24. Pass 19 — Read-only metaobject protocol

## Objective

Make runtime structure inspectable.

## Files

```text
src/MetaCons/MetaObject.hs
src/MetaCons/Reflect.hs

test/Unit/ReflectionSpec.hs
```

## Functions

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

Only read-only reflection is permitted in this pass.

## Commit

```text
Pass 19: Add read-only Meta-CONS metaobject protocol
```

---

# 25. Pass 20 — Core IR

## Objective

Lower resolved language objects into a small typed execution representation.

## Files

```text
src/MetaCons/CoreIR.hs
src/MetaCons/Lower.hs

test/Unit/CoreIRSpec.hs
test/Golden/CoreIR/
```

## Initial instructions

```text
CoreNil
CoreAtom
CorePair
CoreCar
CoreCdr
CoreBind
CoreLookup
CoreLambda
CoreApply
CoreSpecial
CoreQuote
CoreScope
CoreRecover
CoreProject
```

The Core IR is not the Omnicron ISA.

It is the semantic lowering boundary before target-specific encoding.

## Commit

```text
Pass 20: Add typed Meta-CONS Core IR
```

---

# 26. Pass 21 — Debug interpreter target

## Objective

Execute Core IR directly for testing.

## Files

```text
src/Adapter/DebugInterpreter.hs
app/Main.hs
app/Repl.hs

test/Integration/DebugInterpreterSpec.hs
```

The debug interpreter becomes the first executable target.

Do not begin ISA emission before Core IR behavior is stable.

## Commit

```text
Pass 21: Add Core IR debug interpreter
```

---

# 27. Pass 22 — Capability-mediated runtime

## Objective

Add effects without contaminating the pure core.

## Files

```text
src/MetaCons/Capability.hs
src/MetaCons/Runtime.hs
src/MetaCons/RuntimeState.hs
src/MetaCons/RuntimeEvent.hs

test/Unit/CapabilitySpec.hs
test/Integration/RuntimeSpec.hs
```

## Capabilities

```text
memory
storage
network
clock
foreign
projection
```

## Rules

```text
no ambient IO

missing capability returns explicit error

pure programs run with no effect capabilities

runtime events are deterministic for deterministic capability implementations
```

## Commit

```text
Pass 22: Add capability-mediated Meta-CONS runtime
```

---

# 28. Pass 23 — Module loading

## Objective

Load local or remote modules through tagged origin-preserving injection.

## Files

```text
src/Emergent/Module.hs
src/MetaCons/ModuleLoader.hs

test/Integration/ModuleLoadingSpec.hs
```

## Requirements

```text
origin identity
module version
declared capabilities
exports
imports
qualified names
conflict handling
```

Imports must not erase origin.

## Commit

```text
Pass 23: Add typed origin-preserving modules
```

---

# 29. Pass 24 — Formal Coq foundation

## Objective

Begin formal verification only after implementation laws are stable.

## Initial proof files

```text
proof/CarrierMirror.v
proof/Quasigroup.v
proof/Hamming743.v
proof/CoproductOrigin.v
```

## First theorems

```text
mirror involution

quasigroup recovery

Hamming syndrome correctness

origin preservation under projection
```

## Restrictions

```text
no Admitted

no admit

no placeholder Axiom

no pseudo-Coq syntax

all files compile with coqc
```

## Commit

```text
Pass 24: Add first compiled Meta-CONS proofs
```

---

# 30. Pass 25 — Omnicron ISA adapter

## Objective

Lower stable Core IR into the Omnicron ISA.

## Files

```text
src/Adapter/OmnicronISA.hs
vectors/omnicron-isa.yaml
test/Golden/OmnicronISA/
```

## Requirements

```text
explicit instruction mapping
explicit unsupported-operation errors
deterministic output
no direct lowering from surface syntax
```

Pipeline:

```text
Emergent Axial Lisp
→ SEXPR
→ typed stages
→ resolved Meta-CONS
→ Core IR
→ Omnicron ISA
```

## Commit

```text
Pass 25: Add Omnicron ISA lowering adapter
```

---

# 31. Pass 26 — C99 embedding ABI

## Objective

Expose the stable pure kernel through an opaque C interface.

## Requirements

```text
opaque handles
fixed-width integers
explicit ownership
explicit allocator policy
canonical error codes
no exposed Haskell runtime internals
```

Do not begin before the Haskell kernel API is stable.

---

# 32. Pass 27 — WebAssembly adapter

## Objective

Expose parsing, canonical printing, bounded evaluation, and projection through WASM.

No filesystem or network authority by default.

---

# 33. Deferred work

The following work is intentionally deferred until the core passes are complete:

```text
full M-expression projective syntax
advanced macro hygiene
full meta-circular evaluator
runtime metaobject mutation
distributed reconciliation
network transport
Canvas rendering
Markdown adapter
OMI-Port adapter
hardware targets
large 32-bit quasigroup profiles
performance specialization
parallel evaluation
JIT compilation
```

Do not treat deferred work as missing bootstrap functionality.

---

# 34. Required reporting format for the coding agent

After each pass, report:

```text
Pass completed

Files created
Files changed

Types introduced

Laws implemented

Tests added

Commands run

Exact test results

Known limitations

No-authority boundary

Next pass
```

Example:

```text
Pass 1 completed: Canonical Meta-CONS pair kernel

Files created:
- src/MetaCons/Kernel.hs
- src/Emergent/Syntax.hs
- src/Emergent/Printer.hs
- test/Unit/KernelSpec.hs

Laws:
- car(cons a b) = a
- cdr(cons a b) = b

Tests:
- 18 unit
- 6 property
- 0 failures

Boundary:
- No parser
- No evaluator
- No validation
- No projection

Next:
- Pass 2 canonical S-expression parser
```

---

# 35. Stop conditions

Stop and report rather than inventing behavior when:

```text
two source documents conflict

a mathematical law is underspecified

a type requires a new authority assumption

a serialization field has no defined meaning

a resolver fails quasigroup laws

an implementation choice would erase origin

a projection requires changing canonical identity

a Coq proof needs an unapproved axiom

an adapter cannot preserve required information
```

When stopped, provide:

```text
the exact conflict
the affected files
the smallest decision required
two or three bounded alternatives
the recommended choice
```

---

# 36. Immediate command to the coding agent

Begin now with:

```text
Pass 0
Repository foundation

Pass 1
Canonical Meta-CONS pair kernel
```

Do not proceed beyond Pass 1 until:

```text
the repository builds
the complete test suite passes
canonical proper and improper lists round-trip
CAR/CDR recovery tests pass
the canonical printer is deterministic
the implementation report is produced
```

The first target is not a full language.

The first target is a trustworthy homoiconic kernel.

---

# 37. First implementation prompt

Use this as the coding agent’s first execution instruction:

```text
Read AGENTS.md and IMPLEMENTATION-PLAN.md completely.

Implement Pass 0 and Pass 1 only.

Create the Haskell/Cabal repository foundation and the canonical Meta-CONS
pair kernel containing NIL, Atom, Pair, cons, car, cdr, structural equality,
proper-list construction, proper-list inspection, and deterministic canonical
printing.

Add unit and property tests for proper lists, improper lists, nested pairs,
CAR/CDR recovery, invalid CAR/CDR access, and deterministic printing.

Do not implement parsing, evaluation, macros, axes, bitboards, quasigroups,
reflection, networking, Canvas, ISA lowering, or effects in this pass.

Run all build, test, formatting, and lint commands.

Report exact files, APIs, laws, tests, command results, limitations, and the
authority boundary at completion.
```

---

# 38. Final lock

```text
Start with the pair.

Prove the pair behavior through tests.

Parse only after the pair is stable.

Type the axes only after syntax is stable.

Evaluate only after binding is defined.

Compose boards only after origins are preserved.

Add recovery only after the quasigroup laws pass.

Add effects only after pure semantics are stable.

Lower to ISA only after Core IR is stable.

Formalize only stable laws.

Never let projection become authority.
```
