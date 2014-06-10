/*
 * bidi_message_queue_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_env.h"

bidi_message_queue_env::bidi_message_queue_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

bidi_message_queue_env::~bidi_message_queue_env() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_env::build() {
	// TODO: instantiate BFMs
	m_master_bfm = axi4_master_bfm::type_id.create("m_master_bfm", this);
	m_message_queue_bfm = bidi_message_queue_bfm::type_id.create("m_message_queue_bfm", this);
}

void bidi_message_queue_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(bidi_message_queue_env)
