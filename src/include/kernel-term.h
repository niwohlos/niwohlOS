#ifndef _KERNEL_TERM_H
#define _KERNEL_TERM_H

// Initialize some basic interface so all the modules, including early ones, may
// output (debugging) information.
void init_primordial_output(void);

// Print that string (either via that basic interface or (later on in the
// booting process) a more sophisticated one) and a trailing newline.
void kputs(const char *s);

// Prints that single character.
void kputc(char c);

#endif
