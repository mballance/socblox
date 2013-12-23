/*
 * svm_mem_if.h
 *
 *  Created on: Dec 21, 2013
 *      Author: ballance
 */

#ifndef SVM_MEM_IF_H_
#define SVM_MEM_IF_H_
#include "svm.h"

class svm_mem_if {

	public:

		virtual ~svm_mem_if() {}

		virtual void write8(uint64_t addr, uint8_t data) = 0;

		virtual void write16(uint64_t addr, uint16_t data) = 0;

		virtual void write32(uint64_t addr, uint32_t data) = 0;

		virtual uint8_t read8(uint64_t addr) = 0;

		virtual uint16_t read16(uint64_t addr) = 0;

		virtual uint32_t read32(uint64_t addr) = 0;

};



#endif /* SVM_MEM_IF_H_ */