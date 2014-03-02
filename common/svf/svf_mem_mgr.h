/*
 * svf_mem_mgr.h
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#ifndef SVF_MEM_MGR_H_
#define SVF_MEM_MGR_H_
#include "svf_mem_if.h"
#include <vector>

using namespace std;

struct svf_mem_mgr_region;

class svf_mem_mgr : public virtual svf_mem_if {

	public:
		svf_mem_mgr();

		virtual ~svf_mem_mgr();

		void add_region(
				svf_mem_if		*mem_if,
				uint64_t		base,
				uint64_t		limit);

		virtual void write8(uint64_t addr, uint8_t data);

		virtual void write16(uint64_t addr, uint16_t data);

		virtual void write32(uint64_t addr, uint32_t data);

		virtual uint8_t read8(uint64_t addr);

		virtual uint16_t read16(uint64_t addr);

		virtual uint32_t read32(uint64_t addr);

	private:
		svf_mem_mgr_region *find(uint64_t base, uint64_t limit);

	private:
		vector<svf_mem_mgr_region *>		m_regions;

};

#endif /* SVF_MEM_MGR_H_ */
