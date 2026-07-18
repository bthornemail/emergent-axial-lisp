#include "omi.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
    if (argc != 2) { fprintf(stderr, "usage: %s '(CAR . CDR)'\n", argv[0]); return 2; }
    Omicron omicron; omicron_init(&omicron);
    if (!omicron_stage_preheader(&omicron) || !omicron_induce_prelanguage(&omicron) || !omicron_cross_sp(&omicron)) {
        fprintf(stderr, "boot normalization failed\n"); return 3;
    }
    OmiCons *cell = NULL; char err[160];
    if (!omi_parse_declaration(&omicron, argv[1], &cell, err, sizeof(err))) {
        fprintf(stderr, "parse error: %s\n", err); return 4;
    }
    OmiReceiptRing ring; omi_ring_init(&ring);
    OmiReceipt r = tetragrammatron_validate_and_record(&ring, argv[1], cell);
    char json[1024]; metatron_project_json(&r, json, sizeof(json));
    puts(json);
    omi_free_cons(cell);
    return 0;
}
