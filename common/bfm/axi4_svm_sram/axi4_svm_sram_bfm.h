/*
 * axi4_svm_sram_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef AXI4_SVM_SRAM_BFM_H_
#define AXI4_SVM_SRAM_BFM_H_
#include "svm.h"
#include "svm_mem_if.h"

class axi4_svm_sram_bfm : public svm_component, public virtual svm_mem_if {

	public:
		svm_api_port<svm_mem_if>				port;

	public:

		axi4_svm_sram_bfm(const char *name, svm_component *parent);

		virtual ~axi4_svm_sram_bfm();

		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write8(uint64_t addr, uint8_t data);

		virtual uint32_t read32(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint8_t read8(uint64_t addr);

};

#endif /* AXI4_SVM_SRAM_BFM_H_ */
