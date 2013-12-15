/*
 * axi4_interconnect_env.h
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#ifndef AXI4_INTERCONNECT_ENV_H_
#define AXI4_INTERCONNECT_ENV_H_

#include "svm_component.h"
#include "axi4_master_bfm.h"

class axi4_interconnect_env: public svm_component {
	svm_component_ctor_decl(axi4_interconnect_env);

	public:
		axi4_interconnect_env(const char *name, svm_component *parent);

		virtual ~axi4_interconnect_env();

		void build();

		void connect();

	private:
		axi4_master_bfm				*m_bfm;


};

#endif /* AXI4_INTERCONNECT_ENV_H_ */
