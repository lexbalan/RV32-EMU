
#include <stdint.h>
#include <stdarg.h>

#include "system.h"


uint64_t sum64(uint32_t a, uint32_t b) {
	return (uint64_t)a + (uint64_t)b;
}


void putchar(char c) {
	write(0, &c, 1);
}

void put_str8(char *s) {
	while (1) {
		const char c = *s;
		if (c == 0) {
			break;
		}
		putchar(c);
		++s;
	}
}


char *sprintf_hex32(char *buf, int d);
char *sprintf_dec32(char *buf, int d);


int print(const char *str, ...) {
	va_list a_list;
	va_start(a_list, str);

	va_list a_list2;
	va_copy(a_list2, a_list);

	char c;
	int i = 0;
	while (1) {
		c = str[i];
		if (c == 0) {
			break;
		}

		if (c == '%') {
			++i;
			c = str[i];

			// буффер для печати всего кроме строк
			char buf[10+1];
			char *sptr = &buf[0];

			if ((c == 'd') || (c == 'i')) {
				int d = va_arg(a_list, int);
				sprintf_dec32(sptr, d);
			} else if (c == 'x') {
				int d = va_arg(a_list, int);
				sprintf_hex32(sptr, d);
			} else if (c == 's') {
				char *s = va_arg(a_list, char*);
				sptr = s;
			} else if (c == 'c') {
				char cc = va_arg(a_list, int); // int!
				sptr[0] = cc;
				sptr[1] = 0;
			} else if (c == '%') {
				sptr = "%";
			}

			put_str8(sptr);

		} else {
			putchar(c);
		}

		i = i + 1;
	}

	va_end(a_list);

	return 0;
}


char *sprintf_hex32(char *buf, int d) {
	char cc[8] = {0};
	int pos = 8;

	int i = 0;
	int n;

	do {
		n = d % 16;
		d = d / 16;

		char c;
		if (n <= 9) {
			c = '0' + n;
		} else {
			c = 'A' + (n - 10);
		}

		cc[i] = c;
		i = i + 1;
	} while (d);


	// mirroring into buffer
	int j = 0;
	while(i) {
		--i;
		buf[j] = cc[i];
		++j;
	}

	buf[j] = 0;

	return buf;
}


char *sprintf_dec32(char *buf, int d) {
	char cc[11] = {0};

	const int neg = d < 0;

	if (neg) {
		d = -d;
	}

	int i = 0;
	do {
		const int n = d % 10;
		d = d / 10;
		cc[i] = '0' + n;
		i = i + 1;
	} while (d);


	int j = 0;
	if (neg) {
		buf[0] = '-';
		++j;
	}

	while(i) {
		--i;
		buf[j] = cc[i];
		++j;
	}

	buf[j] = 0;

	return buf;
}


