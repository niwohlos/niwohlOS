.code32
.att_syntax

.global _start
.extern main

.section .multiboot
#define MB_MAGIC    0x1BADB002
#define MB_FLAGS    0x00000000
#define MB_CHECKSUM -(MB_MAGIC + MB_FLAGS)

.align 4
.int    MB_MAGIC
.int    MB_FLAGS
.int    MB_CHECKSUM


.section .text

_start:
// Der Stack muss seit GCC 4.5 oder so beim Funktionsaufruf immer an 16 Byte
// ausgerichtet sein (SSE und so)
mov     $kernel_stack - 16,%esp

mov     %eax,0(%esp)
mov     %ebx,4(%esp)

call    main

hangman:
cli
hlt
jmp     hangman


.section .bss
.align 16
.space 4096
kernel_stack:
