/*
 * regio.h
 *
 *  Created on: Jan 24, 2015
 *      Author: ballance
 */

#ifndef REGIO_H_
#define REGIO_H_
#include <stdint.h>

#define __arch_getb(a)                  (*(volatile unsigned char *)(a))
#define __arch_getw(a)                  (*(volatile unsigned short *)(a))
#define __arch_getl(a)                  (*(volatile unsigned int *)(a))

#define __arch_putb(v,a)                (*(volatile unsigned char *)(a) = (v))
#define __arch_putw(v,a)                (*(volatile unsigned short *)(a) = (v))
#define __arch_putl(v,a)                (*(volatile unsigned int *)(a) = (v))

#define dmb()           __asm__ __volatile__ ("" : : : "memory")
#define __iormb()       dmb()
#define __iowmb()       dmb()

#define writeb(v,c)     ({ uint8_t  __v = v; __iowmb(); __arch_putb(__v,c); __v; })
#define writew(v,c)     ({ uint16_t __v = v; __iowmb(); __arch_putw(__v,c); __v; })
#define writel(v,c)     ({ uint32_t __v = v; __iowmb(); __arch_putl(__v,c); __v; })

#define readb(c)        ({ uint8_t  __v = __arch_getb(c); __iormb(); __v; })
#define readw(c)        ({ uint16_t __v = __arch_getw(c); __iormb(); __v; })
#define readl(c)        ({ uint32_t __v = __arch_getl(c); __iormb(); __v; })


#endif /* REGIO_H_ */
