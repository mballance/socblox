/*
 * bidi_message_queue_drv_svf.cpp
 *
 *  Created on: Feb 16, 2015
 *      Author: ballance
 */

#include "bidi_message_queue_drv_svf.h"
#include "svf.h"

bidi_message_queue_drv_svf::bidi_message_queue_drv_svf(
		const char					*name,
		svf_component				*parent) :
			svf_component(name, parent), bidi_message_queue_ptr_drv(0, 0),
				link_port(this) {
}

bidi_message_queue_drv_svf::~bidi_message_queue_drv_svf() {
	// TODO Auto-generated destructor stub
}

int32_t bidi_message_queue_drv_svf::get_next_message_sz(bool block) {
	return bidi_message_queue_ptr_drv::get_next_message_sz(block);
}

int32_t bidi_message_queue_drv_svf::read_next_message(uint32_t *data) {
	return bidi_message_queue_ptr_drv::read_next_message(data);
}

int32_t bidi_message_queue_drv_svf::send_message(uint32_t sz, uint32_t *data) {
	return write_message(sz, data);
}

//void bidi_message_queue_drv_svf::inbound_lock() {
//	m_inbound_mutex.lock();
//}
//
//void bidi_message_queue_drv_svf::inbound_unlock() {
//	m_inbound_mutex.unlock();
//}
//
//void bidi_message_queue_drv_svf::outbound_lock() {
//	m_outbound_mutex.lock();
//}
//
//void bidi_message_queue_drv_svf::outbound_unlock() {
//	m_outbound_mutex.unlock();
//}

		// Wait for inbound data to be available
void bidi_message_queue_drv_svf::wait_inbound() {
	svf_thread::yield();
}

// Wait for space in the outbound queue to be available
void bidi_message_queue_drv_svf::wait_outbound() {
	svf_thread::yield();
}

svf_component_ctor_def(bidi_message_queue_drv_svf)
