/*
 * bidi_message_queue_direct_bfm_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "bidi_message_queue_direct_bfm_dpi_mgr.h"

bidi_message_queue_direct_bfm_dpi_mgr::bidi_message_queue_direct_bfm_dpi_mgr() {
}

bidi_message_queue_direct_bfm_dpi_closure::bidi_message_queue_direct_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {
}

SVF_DPI_CLOSURE_REGISTER_TASK(bidi_message_queue_direct_bfm)

SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, get_queue_sz, (uint32_t *queue_sz), (queue_sz))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, get_inbound_ptrs, (uint32_t *rd_ptr, uint32_t *wr_ptr), (rd_ptr, wr_ptr))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, set_inbound_wr_ptr, (uint32_t wr_ptr), (wr_ptr))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, get_outbound_ptrs, (uint32_t *rd_ptr, uint32_t *wr_ptr), (rd_ptr, wr_ptr))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, set_outbound_rd_ptr, (uint32_t rd_ptr), (rd_ptr))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, set_data, (uint32_t offset, uint32_t data), (offset, data))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, get_data, (uint32_t offset, uint32_t *data), (offset, data))
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, wait_inbound_avail, (), ())
SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, wait_outbound_avail, (), ())

// TODO: SVF_DPI_CLOSURE_EXPORT_TASK for tasks implemented in SystemVerilog
// SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, write8, (uint64_t addr, uint8_t data), (addr, data))
SVF_DPI_CLOSURE_IMPORT_TASK(bidi_message_queue_direct_bfm, inbound_avail_ack, (), ())
SVF_DPI_CLOSURE_IMPORT_TASK(bidi_message_queue_direct_bfm, outbound_avail_ack, (), ())

// TODO: SVF_DPI_CLOSURE_IMPORT_TASK for tasks implemented in C++
// SVF_DPI_CLOSURE_EXPORT_TASK(bidi_message_queue_direct_bfm, write16, (uint64_t addr, uint16_t data), (addr, data))


