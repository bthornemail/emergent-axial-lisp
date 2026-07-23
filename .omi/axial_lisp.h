/* =========================================================================
 * axial_lisp.h - BARE-METAL C99 COMPUTE INTERFACE
 * ========================================================================= */
#ifndef AXIAL_LISP_H
#define AXIAL_LISP_H

#include <stdbool.h>
#include <stdint.h>

#define CAR_MASK  0x0000FFFFU
#define CDR_SHIFT 16

static inline uint16_t omino_car(uint32_t pair) {
    return (uint16_t)(pair & CAR_MASK);
}

static inline uint16_t omino_cdr(uint32_t pair) {
    return (uint16_t)(pair >> CDR_SHIFT);
}

static inline uint32_t omino_cons(uint16_t car_val, uint16_t cdr_val) {
    return (((uint32_t)cdr_val) << CDR_SHIFT) | ((uint32_t)car_val);
}

static inline bool is_remote_codepoint(uint8_t cp) {
    return ((cp & 0x80) != 0);
}

#endif /* AXIAL_LISP_H */
