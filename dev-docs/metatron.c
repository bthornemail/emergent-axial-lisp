#include "omi.h"
#include <stdio.h>

void metatron_project_json(const OmiReceipt *r, char *out, size_t n) {
    snprintf(out, n,
      "{\n  \"accepted\": %s,\n  \"cycle\": %u,\n  \"slot\": %u,\n  \"value\": \"0x%04X\",\n  \"xor_witness\": \"0x%04X\",\n  \"source\": \"%s\",\n  \"reason\": \"%s\"\n}",
      r->accepted ? "true" : "false", r->cycle, r->slot, r->value, r->witness, r->source, r->reason);
}
