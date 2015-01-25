
#ifndef INCLUDED_CRC32_H
#define INCLUDED_CRC32_H

#include <stdint.h>
#include <sys/types.h>

uint32_t crc32(uint32_t crc, const void *buf, size_t size);

#endif /* INCLUDED_CRC32_H */

