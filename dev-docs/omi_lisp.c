#include "omi.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { const char *s; size_t i; } Parser;

static void seterr(char *err, size_t n, const char *msg) {
    if (err && n) snprintf(err, n, "%s", msg);
}

static void ws(Parser *p) { while (isspace((unsigned char)p->s[p->i])) p->i++; }

static bool atom_read(Parser *p, OmiAtom *a, char *err, size_t errlen) {
    ws(p);
    size_t start = p->i;
    while (p->s[p->i] && !isspace((unsigned char)p->s[p->i]) && p->s[p->i] != '(' && p->s[p->i] != ')' && p->s[p->i] != '.') p->i++;
    if (p->i == start) { seterr(err, errlen, "expected atom"); return false; }
    size_t len = p->i - start;
    if (len >= OMI_MAX_ATOM) { seterr(err, errlen, "atom too long"); return false; }
    char tok[OMI_MAX_ATOM]; memcpy(tok, p->s + start, len); tok[len] = 0;
    memset(a, 0, sizeof(*a));
    if (!strcmp(tok, "NULL")) { a->kind = OMI_ATOM_NULL; return true; }
    char *end = NULL;
    unsigned long v = strtoul(tok, &end, 0);
    if (*tok && end && *end == 0 && v <= 0xFFFFul) { a->kind = OMI_ATOM_NUMBER; a->number = (uint16_t)v; return true; }
    a->kind = OMI_ATOM_SYMBOL;
    memcpy(a->symbol, tok, len + 1);
    return true;
}

static bool form_read(Parser *p, bool *is_cons, OmiAtom *atom, OmiCons **cons, char *err, size_t errlen);

static bool cons_read(Parser *p, OmiCons **out, char *err, size_t errlen) {
    ws(p);
    if (p->s[p->i] != '(') { seterr(err, errlen, "expected ("); return false; }
    p->i++;
    OmiCons *c = calloc(1, sizeof(*c));
    if (!c) { seterr(err, errlen, "out of memory"); return false; }
    if (!form_read(p, &c->car_is_cons, &c->car_atom, &c->car_cons, err, errlen)) { free(c); return false; }
    ws(p);
    if (p->s[p->i] != '.') { omi_free_cons(c); seterr(err, errlen, "OMI-Lisp declaration requires dotted CONS"); return false; }
    p->i++;
    if (!form_read(p, &c->cdr_is_cons, &c->cdr_atom, &c->cdr_cons, err, errlen)) { omi_free_cons(c); return false; }
    ws(p);
    if (p->s[p->i] != ')') { omi_free_cons(c); seterr(err, errlen, "expected )"); return false; }
    p->i++;
    *out = c;
    return true;
}

static bool form_read(Parser *p, bool *is_cons, OmiAtom *atom, OmiCons **cons, char *err, size_t errlen) {
    ws(p);
    if (p->s[p->i] == '(') {
        *is_cons = true;
        return cons_read(p, cons, err, errlen);
    }
    *is_cons = false;
    return atom_read(p, atom, err, errlen);
}

bool omi_parse_declaration(const Omicron *o, const char *source, OmiCons **out, char *err, size_t errlen) {
    if (!o || o->stage != OMI_STAGE_READABLE || !o->dot_earned) {
        seterr(err, errlen, "dot notation not earned: Omicron must cross SP first");
        return false;
    }
    Parser p = {source, 0};
    if (!cons_read(&p, out, err, errlen)) return false;
    ws(&p);
    if (source[p.i] != 0) { omi_free_cons(*out); *out = NULL; seterr(err, errlen, "trailing input"); return false; }
    return true;
}

void omi_free_cons(OmiCons *c) {
    if (!c) return;
    if (c->car_is_cons) omi_free_cons(c->car_cons);
    if (c->cdr_is_cons) omi_free_cons(c->cdr_cons);
    free(c);
}

static uint16_t fnv16(const char *s) {
    uint32_t h = 2166136261u;
    for (; *s; s++) { h ^= (uint8_t)*s; h *= 16777619u; }
    return (uint16_t)(((h >> 16) ^ h) & 0xFFFFu);
}

uint16_t omi_encode_atom(const OmiAtom *a) {
    if (a->kind == OMI_ATOM_NULL) return 0;
    if (a->kind == OMI_ATOM_NUMBER) return a->number;
    return fnv16(a->symbol);
}

static uint16_t side_encode(bool is_cons, const OmiAtom *a, const OmiCons *c) {
    return is_cons ? omi_encode_cons(c) : omi_encode_atom(a);
}

uint16_t omi_encode_cons(const OmiCons *c) {
    return side_encode(c->car_is_cons, &c->car_atom, c->car_cons) ^ side_encode(c->cdr_is_cons, &c->cdr_atom, c->cdr_cons);
}

uint16_t omi_cons_witness(const OmiCons *c) { return omi_encode_cons(c); }
