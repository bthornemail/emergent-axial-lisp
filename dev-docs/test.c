#include "omi.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

static OmiCons *parse_ready(const char *s) {
    Omicron o; omicron_init(&o); assert(omicron_stage_preheader(&o)); assert(omicron_induce_prelanguage(&o)); assert(omicron_cross_sp(&o));
    OmiCons *c = NULL; char err[128]; assert(omi_parse_declaration(&o, s, &c, err, sizeof(err))); return c;
}

int main(void) {
    Omicron o; omicron_init(&o); OmiCons *bad = NULL; char err[128];
    assert(!omi_parse_declaration(&o, "(A . B)", &bad, err, sizeof(err)));
    OmiCons *n = parse_ready("(NULL . NULL)"); assert(omi_cons_witness(n) == 0); omi_free_cons(n);
    OmiCons *m = parse_ready("(0xAA55 . 0x55AA)"); assert(omi_cons_witness(m) == 0xFFFF); omi_free_cons(m);
    OmiCons *nested = parse_ready("(FS . (GS . (RS . US)))"); assert(nested != NULL); omi_free_cons(nested);
    OmiCons *c = parse_ready("(intent . candidate)"); OmiReceiptRing ring; omi_ring_init(&ring); OmiReceipt r=tetragrammatron_validate_and_record(&ring,"(intent . candidate)",c); assert(r.accepted); assert(ring.occupied[r.slot]); omi_free_cons(c);
    puts("all C runtime tests passed");
    return 0;
}
