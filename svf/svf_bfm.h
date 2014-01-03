/*
 * svf_bfm.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_BFM_H_
#define SVF_BFM_H_

#include "svf_component.h"

class svf_bfm: public svf_component {
	public:

		static const char					*BFM_PATH;

	public:
		svf_bfm(const char *name, svf_component *parent);

		virtual ~svf_bfm();
};

#endif /* SVF_BFM_H_ */
