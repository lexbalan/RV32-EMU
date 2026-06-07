
#if !defined(CONSOLE_H)
#define CONSOLE_H
#include "riscv_emu.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
void console_putc(char x);
char console_getc(void);
void console_put_code(uint32_t x);
uint32_t console_get_code(void);
void console_print_int(int32_t x);
void console_print_uint(uint32_t x);
void console_print_uint_hex(uint32_t x);
void console_puts(char *x);
#endif

