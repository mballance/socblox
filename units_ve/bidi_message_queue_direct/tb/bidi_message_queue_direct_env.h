/*
 * bidi_message_queue_direct_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef bidi_message_queue_direct_ENV_H_
#define bidi_message_queue_direct_ENV_H_
#include "svf.h"
// TODO: Include BFM header files
#include "axi4_master_bfm.h"
#include "bidi_message_queue_direct_bfm.h"

class bidi_message_queue_direct_env : public svf_component {
	svf_component_ctor_decl(bidi_message_queue_direct_env)

	public:
		bidi_message_queue_direct_env(const char *name, svf_component *parent);

		virtual ~bidi_message_queue_direct_env();

		virtual void build();

		virtual void connect();

	public:
		axi4_master_bfm					*m_master_bfm;
		bidi_message_queue_direct_bfm	*m_message_queue_bfm;

};

#endif /* bidi_message_queue_direct_ENV_H_ */
