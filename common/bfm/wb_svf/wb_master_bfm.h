/*
 * wb_master_bfm.h
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#ifndef WB_MASTER_BFM_H_
#define WB_MASTER_BFM_H_
#include "svf.h"
#include "wb_master_bfm_dpi_mgr.h"
#include "svf_mem_if.h"

class wb_master_bfm :
		public svf_component,
		public virtual svf_mem_if,
		public virtual wb_master_bfm_host_if {

	svf_component_ctor_decl(wb_master_bfm)

	public:
		svf_bidi_api_port<wb_master_bfm_host_if, wb_master_bfm_target_if>	bfm_port;


	public:
		wb_master_bfm(const char *name, svf_component *parent);

		virtual ~wb_master_bfm();

		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write8(uint64_t addr, uint8_t data);

		virtual uint32_t read32(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint8_t read8(uint64_t addr);

		void wait_for_reset();

		virtual void reset();

		virtual void acknowledge(uint8_t ERR);

	private:

		svf_thread_mutex				m_access_mutex;
		svf_semaphore					m_access_sem;
		svf_semaphore					m_reset_sem;
		bool							m_reset_received;

};

#endif /* WB_MASTER_BFM_H_ */
