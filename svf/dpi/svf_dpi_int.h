/*
 * svf_dpi_int.h
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */

#ifndef SVF_DPI_INT_H_
#define SVF_DPI_INT_H_
#include <stdint.h>

typedef struct {
	void (*create_thread)(void *, uint32_t *);
	uint32_t (*create_mutex)();
	void (*mutex_lock)(uint32_t mutex_id);
	void (*mutex_unlock)(uint32_t mutex_id);

	uint32_t (*create_cond)();
	void (*cond_wait)(uint32_t cond_id, uint32_t mutex_id);
	void (*cond_notify)(uint32_t cond_id);
	void (*cond_notify_all)(uint32_t cond_id);

	void (*thread_yield)();

} svf_dpi_api_t;


void set_svf_dpi_api(svf_dpi_api_t *api);

svf_dpi_api_t *get_svf_dpi_api();


#endif /* SVF_DPI_INT_H_ */
