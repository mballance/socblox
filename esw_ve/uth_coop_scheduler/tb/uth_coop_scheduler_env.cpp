/*
 * uth_coop_scheduler_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "uth_coop_scheduler_env.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"

static uth_coop_thread_mgr	*thread_mgr = 0;

uth_thread_mgr *uth_get_thread_mgr()
{
	if (!thread_mgr) {
		thread_mgr = new uth_coop_thread_mgr();
		thread_mgr->init();
	}

	return thread_mgr;
}

uth_coop_scheduler_env::uth_coop_scheduler_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

uth_coop_scheduler_env::~uth_coop_scheduler_env() {
	// TODO Auto-generated destructor stub
}

void uth_coop_scheduler_env::build() {
	// TODO: instantiate BFMs
}

void uth_coop_scheduler_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(uth_coop_scheduler_env)
