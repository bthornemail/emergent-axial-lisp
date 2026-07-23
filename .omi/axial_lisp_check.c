/* =========================================================================
 * axial_lisp_check.c - C99 SYNTAX VERIFICATION HARNESS
 * ========================================================================= */
#include "axial_lisp.h"

int main(void) {
    uint16_t test_car = 0x1337;
    uint16_t test_cdr = 0xDEAD;

    uint32_t packed_pair = omino_cons(test_car, test_cdr);

    uint16_t extracted_car = omino_car(packed_pair);
    uint16_t extracted_cdr = omino_cdr(packed_pair);

    bool remote = is_remote_codepoint(0x8F);

    return (extracted_car == test_car && extracted_cdr == test_cdr && remote) ? 0 : 1;
}
