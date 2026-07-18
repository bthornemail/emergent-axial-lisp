# LANGUAGE-SPEC.md

## Status

Defined model for Pass 1 and Pass 2 only.

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

This file does not yet define MEXPR lowering, modules, macros, FEXPRs, evaluation, or type elaboration.

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
