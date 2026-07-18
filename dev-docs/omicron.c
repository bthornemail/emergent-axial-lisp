#include "omi.h"
#include <string.h>

void omicron_init(Omicron *o) {
    memset(o, 0, sizeof(*o));
    o->stage = OMI_STAGE_RESET;
}

bool omicron_stage_preheader(Omicron *o) {
    static const uint8_t canonical[8] = {0xFF,0x00,0x1C,0x1D,0x1E,0x1F,0x20,0xFF};
    memcpy(o->preheader, canonical, sizeof(canonical));
    o->stage = OMI_STAGE_PREHEADER;
    return true;
}

bool omicron_induce_prelanguage(Omicron *o) {
    if (o->stage != OMI_STAGE_PREHEADER) return false;
    o->stage = OMI_STAGE_PRELANGUAGE;
    return true;
}

bool omicron_cross_sp(Omicron *o) {
    if (o->stage != OMI_STAGE_PRELANGUAGE) return false;
    o->dot_earned = true;
    o->stage = OMI_STAGE_READABLE;
    return true;
}
