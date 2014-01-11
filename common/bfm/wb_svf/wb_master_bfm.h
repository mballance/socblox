/*
 * wb_master_bfm.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef WB_MASTER_BFM_H_
#define WB_MASTER_BFM_H_
#include "svf.h"

class wb_master_bfm : public svf_component {

	svf_component_ctor_decl(wb_master_bfm)

	public:
		wb_master_bfm(const char *name, svf_component *parent);

		virtual ~wb_master_bfm();
};

#endif /* WB_MASTER_BFM_H_ */
