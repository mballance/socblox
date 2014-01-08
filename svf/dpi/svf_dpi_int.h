/*
 * svf_dpi_int.h
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */

#ifndef SVF_DPI_INT_H_
#define SVF_DPI_INT_H_

typedef struct {
	void (*create_thread)(void *, void **);


} svf_dpi_api_t;


void set_svf_dpi_api(svf_dpi_api_t *api);

svf_dpi_api_t *get_svf_dpi_api();


#endif /* SVF_DPI_INT_H_ */
