OUTPUT_ARCH("i386:i386")
OUTPUT_FORMAT("elf32-i386")
physical = 0x00100000;
virtual = 0x00100000;

SECTIONS
{
    .multiboot virtual : AT(physical)
    {
        . = ALIGN(4);
        multiboot = .;
        *(.multiboot)
    }
    .text virtual + code - multiboot : AT(physical + code - multiboot)
    {
        . = ALIGN(4);
        code = .;
        *(.text)
    }
    .data : AT(physical + data - multiboot)
    {
        . = ALIGN(4);
        data = .;
        *(.data)
    }
    .bss : AT(physical + bss - multiboot)
    {
        . = ALIGN(4);
        bss = .;
        *(.bss)
        *(COMMON)
    }

    __kernel_elf_end = .;
}

