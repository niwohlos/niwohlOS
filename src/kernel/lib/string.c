#include <stdint.h>
#include <string.h>

void *memset(void *dst, int c, size_t n)
{
    uint8_t *d = dst;

    while (n--)
        *(d++) = c;

    return dst;
}

void *memmove(void *dst, const void *src, size_t n)
{
    uint8_t *d = dst;
    const uint8_t *s = src;


    if ((uintptr_t)dst == (uintptr_t)src)
        return dst;
    else if (((uintptr_t)dst     <  (uintptr_t)src) ||
             ((uintptr_t)dst + n >= (uintptr_t)src))
    {
        while (n--)
            *(d++) = *(s++);

        return dst;
    }

    d += n;
    s += n;

    while (n--)
        *(--d) = *(--s);

    return dst;
}
