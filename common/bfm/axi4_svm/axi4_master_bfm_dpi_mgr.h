/*
 * axi4_master_bfm_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_DPI_MGR_H_
#define AXI4_MASTER_BFM_DPI_MGR_H_
#include "axi4_master_bfm_if.h"
#include <map>
#include <string>

using namespace std;

class axi4_master_bfm_dpi_mgr;

class axi4_master_bfm_dpi_closure : virtual axi4_master_bfm_target_if {

	public:

		typedef svm_bidi_api_port<axi4_master_bfm_host_if, axi4_master_bfm_target_if>	port_t;

		axi4_master_bfm_dpi_closure(const string &target) :
			m_target(target), m_port(0) {
		}

		void connect(port_t *port) {
			m_port = port;
			m_port->set_consumes(this);
		}

		axi4_master_bfm_host_if *host_if() {
			return m_port->provides();
		}

		void aw_valid(
				uint64_t			AWADDR,
				uint32_t			AWID,
				uint8_t				AWLEN,
				uint8_t				AWSIZE,
				uint8_t				AWBURST,
				uint8_t				AWCACHE,
				uint8_t				AWPROT,
				uint8_t				AWQOS,
				uint8_t				AWREGION);

	private:
		string								m_target;
//		axi4_master_bfm_dpi_mgr				*m_mgr;
		port_t								*m_port;

};

class axi4_master_bfm_dpi_mgr {

	public:

		static void connect(
				const string 							&target,
				axi4_master_bfm_dpi_closure::port_t 	&port);

		static void register_bfm(const string &target);

		static axi4_master_bfm_dpi_closure *get_closure(const string &target);

	private:

		static map<string, axi4_master_bfm_dpi_closure *>				m_closure_map;

};



#endif /* AXI4_MASTER_BFM_DPI_MGR_H_ */
