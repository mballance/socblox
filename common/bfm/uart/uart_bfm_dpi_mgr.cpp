/*
 * uart_bfm_dpi_mgr.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include "uart_bfm_dpi_mgr.h"

uart_bfm_dpi_mgr::uart_bfm_dpi_mgr() {
}

uart_bfm_dpi_closure::uart_bfm_dpi_closure(const string &target) :
		svf_dpi_closure(target) {

}

SVF_DPI_CLOSURE_REGISTER_TASK(uart_bfm)

SVF_DPI_CLOSURE_EXPORT_TASK(uart_bfm, tx_start, (uint8_t ch), (ch))

SVF_DPI_CLOSURE_IMPORT_TASK(uart_bfm, tx_done, (), ());

SVF_DPI_CLOSURE_IMPORT_TASK(uart_bfm, rx_done, (uint8_t ch), (ch))




