#include "a2.h"

unsigned reversebits(unsigned num) {
    unsigned result = 0;
    
    // number of bits
    unsigned temp = num;
    int bits = 0;
    
    while (temp > 0) {
        bits++;
        temp >>= 1;
    }

    for (int i = 0; i < bits; i++) {
        result <<= 1;
        result |= (num & 1);
        num >>= 1;
    }

    return result;
}

unsigned mul(unsigned x, unsigned y) {
    unsigned result = 0;

    while (y > 0) {
        if (y & 1) {
            result += x;
        }
        x <<= 1;
        y >>= 1;
    }
    return result;
}