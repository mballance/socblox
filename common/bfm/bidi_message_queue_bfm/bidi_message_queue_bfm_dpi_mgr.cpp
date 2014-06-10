/*
 * bidi_message_queue_bfm_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "bidi_message_queue_bfm_dpi_mgr.h"

bidi_message_queue_bfm_dpi_mgr::bidi_message_queue_bfm_dpi_mgr() {
}

bidi_message_queue_bfm_dpi_closure::bidi_message_queue_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(bidi_message_queue_bfm)

// TODO: SVF_DPI_CLOSURE_EXPORT_TASK for tasks implemented in SystemVerilog
// SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_bfm, write8, (uint64_t addr, uint8_t data), (addr, data))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_bfm, write_req, (uint32_t data), (data))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_bfm, read_req, (), ())

// TODO: SVF_DPI_CLOSURE_IMPORT_TASK for tasks implemented in C++
// SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_bfm, write16, (uint64_t addr, uint16_t data), (addr, data))
SVF_DPI_CLOSURE_IMPORT_TASK(bidi_message_queue_bfm, write_ack, (), ())
SVF_DPI_CLOSURE_IMPORT_TASK(bidi_message_queue_bfm, read_ack, (uint32_t data), (data))


