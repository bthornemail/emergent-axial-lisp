#include "omi.h"
#include <stdio.h>
#include <string.h>

void omi_ring_init(OmiReceiptRing *r) { memset(r, 0, sizeof(*r)); r->next_cycle = 1; }

OmiReceipt tetragrammatron_validate_and_record(OmiReceiptRing *ring, const char *source, const OmiCons *cell) {
    OmiReceipt r; memset(&r, 0, sizeof(r));
    snprintf(r.source, sizeof(r.source), "%s", source ? source : "");
    r.value = omi_encode_cons(cell);
    r.witness = omi_cons_witness(cell);
    r.slot = (uint16_t)(r.witness % OMI_RING_SIZE);
    r.cycle = ring->next_cycle++;
    r.accepted = true;
    snprintf(r.reason, sizeof(r.reason), "well-formed lazy declaration recorded; no side effect executed");
    ring->slots[r.slot] = r;
    ring->occupied[r.slot] = true;
    return r;
}
