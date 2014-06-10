/*
 * uex_hal_api.h
 *
 *  Created on: May 5, 2014
 *      Author: ballance
 */

#ifndef UEX_HAL_API_H_
#define UEX_HAL_API_H_
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

typedef enum {


} uex_hal_msg_e;

typedef struct uex_hal_msg_s {
	uex_hal_msg_e			msg_type;
	uint32_t				p1;
	uint32_t				p2;
	uint32_t				p3;
} uex_hal_msg_t;

/**
 * uex_hal_get_num_cores()
 *
 * Target HAL must provide this
 */
uint32_t uex_hal_get_num_cores(void);

/**
 * uex_hal_get_coreid()
 *
 */
uint32_t uex_hal_get_coreid(void);

/**
 * uex_hal_percore_init()
 *
 * Performs per-core initialization. This is run for all cores
 */
void uex_hal_percore_init(void);

/**
 * uex_hal_global_init()
 *
 * Performs global initialization. This is only run for Core0
 */
void uex_hal_global_init(void);

/**
 * uex_hal_malloc()
 *
 * Target HAL must provide this
 */
void *uex_hal_malloc(uint32_t size);

/**
 * uex_hal_free()
 *
 * Target HAL must provide this
 */
void uex_hal_free(void *p);

void uex_thread_swap(uex_thread_t *src, uex_thread_t *dst);

void uex_thread_init(uex_thread_t *t, void (*f)(void *), void *);

#ifdef __cplusplus
}
#endif

#endif /* UEX_HAL_API_H_ */
