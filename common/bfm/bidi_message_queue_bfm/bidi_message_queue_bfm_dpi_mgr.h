/*
 * bidi_message_queue_bfm_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_bfm_DPI_MGR_H
#define INCLUDED_bidi_message_queue_bfm_DPI_MGR_H
#include "svf.h"
#include "svf_dpi.h"
#include "bidi_message_queue_bfm_if.h"
#include <map>
#include <string>

using namespace std;

class bidi_message_queue_bfm_dpi_mgr;

class bidi_message_queue_bfm_dpi_closure : public svf_dpi_closure<bidi_message_queue_bfm_host_if, bidi_message_queue_bfm_target_if> {

	public:

		bidi_message_queue_bfm_dpi_closure(const string &target);

		virtual ~bidi_message_queue_bfm_dpi_closure() {}

		// TODO: Virtual methods for target API

		virtual void write_req(uint32_t data);
		virtual void read_req();

};

class bidi_message_queue_bfm_dpi_mgr : public svf_dpi_mgr<bidi_message_queue_bfm_dpi_closure> {

	public:

		bidi_message_queue_bfm_dpi_mgr();

};



#endif /* INCLUDED_bidi_message_queue_bfm_DPI_MGR_H */
