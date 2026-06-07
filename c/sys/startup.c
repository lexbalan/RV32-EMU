
#include <stdint.h>

#include "base.h"


void __rt0() {
#if 1
  // Зануление BSS сегмента
  {
	extern void _bss_start, _bss_end;
	uint8_t *const p = &_bss_start;
	const uint32_t bss_size = (uint32_t)&_bss_end - (uint32_t)&_bss_start;

	uint32_t i = 0;
	while (i < bss_size) {
	  p[i] = 0;
	  ++i;
	}
  }
#endif


#if 1
  // Копирование .data сегмента из FLASH в RAM
  {
	extern void _data_start, _data_end, _data_flash_start;
	uint8_t *const dst = &_data_start;
	uint8_t *const src = &_data_flash_start;
	const uint32_t data_size = (uint32_t)&_data_end - (uint32_t)&_data_start;

	uint32_t i = 0;
	while (i < data_size) {
	  dst[i] = src[i];
	  ++i;
	}
  }
#endif
}


extern int main();
// Объявляем внешний символ начала стека
// (который должен быть определен в линкер-скрипте)
extern void* _stack_start;
extern void _bss_start, _bss_end;
extern void _data_start, _data_end, _data_flash_start;


__attribute__ ((section (".startup")))
void startup() {
	const uint32_t bss_size = (uint32_t)&_bss_end - (uint32_t)&_bss_start;
	__builtin_memset(&_bss_start, 0, bss_size);

	const uint32_t data_size = (uint32_t)&_data_end - (uint32_t)&_data_start;
	__builtin_memcpy(&_data_start, &_data_flash_start, data_size);

	main();
}

