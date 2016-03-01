/*
 * svf_dpi.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVF_DPI_H_
#define SVF_DPI_H_
// #include "svdpi.h"

typedef void * svScope;
extern "C" svScope svSetScope(const svScope scope);
extern "C" svScope svGetScope(void);
extern "C" const char *svGetNameFromScope(const svScope);
extern "C" svScope svGetScopeFromName(const char *name);

#include "svf_dpi_closure.h"
#include "svf_dpi_mgr.h"


#endif /* SVF_DPI_H_ */
