/*
 * svf_bridge.h
 *
 *  Created on: Mar 30, 2014
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_H_
#define SVF_BRIDGE_H_
#include "svf_component.h"
#include "svf_bridge_if.h"

class svf_bridge : public svf_component, public virtual svf_bridge_if {
	public:
		svf_bridge();

		virtual ~svf_bridge();

	private:

};

#endif /* SVF_BRIDGE_H_ */
