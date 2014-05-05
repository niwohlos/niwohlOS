#include <kernel-term.h>
#include <stdint.h>
#include <string.h>


#define WIDTH  80
#define HEIGHT 25
// Linear char buffer
#define LCB    ((uint16_t *)0xB8000)

static int x, y;
static uint16_t flags;


void init_primordial_output(void)
{
    memset(LCB, 0, WIDTH * HEIGHT * sizeof(uint16_t));

    x = 0;
    y = 0;
    flags = 0x0700;
}

void kputs(const char *s)
{
    while (*s)
        kputc(*(s++));

    kputc('\n');
}

static void scroll_down(void)
{
    memmove(&LCB[0], &LCB[WIDTH], WIDTH * (HEIGHT - 1) * sizeof(uint16_t));
}

void kputc(char c)
{
    switch (c)
    {
        case '\r':
            x = 0;
            break;
        case '\n':
            while (++y >= HEIGHT)
            {
                y--;
                scroll_down();
            }
            x = 0;
            break;
        default:
            LCB[x++ + y * WIDTH] = c | flags;
            while (x >= WIDTH)
            {
                x -= WIDTH;
                while (++y >= HEIGHT)
                {
                    y--;
                    scroll_down();
                }
            }
    }
}
