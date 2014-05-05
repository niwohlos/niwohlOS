#include <cpu.h>
#include <kernel-term.h>
#include <stdint.h>

void main(int boot_loader_id, uintptr_t boot_loader_data)
{
    init_primordial_output();

    kputs("[ init ] Behelfsausgabe initialisiert.");


    init_cpu();


    for (;;);
}
