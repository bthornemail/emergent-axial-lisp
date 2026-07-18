# LANGUAGE-SPEC.md

## Status

Defined model for Pass 1 only.

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

This file does not yet define parsing, MEXPR lowering, modules, macros, FEXPRs, evaluation, or type elaboration.
