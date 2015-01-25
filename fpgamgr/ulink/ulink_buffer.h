/*
 * hps_uart_buffer.h
 *
 *  Created on: Jan 7, 2015
 *      Author: ballance
 */

#ifndef HPS_UART_BUFFER_H_
#define HPS_UART_BUFFER_H_
#include <stdint.h>

class ulink_buffer {

	public:
		ulink_buffer(uint32_t page_sz=4096);

		virtual ~ulink_buffer();

		virtual int32_t read(uint8_t *buf, uint32_t sz);

		virtual int32_t write(uint8_t *buf, uint32_t sz);


	private:

		struct buffer_page {
			uint32_t				wr_ptr;
			uint32_t				rd_ptr;

			uint8_t					*data;

			buffer_page				*next;
		};

	private:
		struct buffer_page *alloc_page();

		void free_page(struct buffer_page *page);

	private:
		uint32_t					m_page_sz;

		buffer_page					*m_write_ptr;
		buffer_page					*m_read_ptr;

		buffer_page					*m_alloc_ptr;

};

#endif /* HPS_UART_BUFFER_H_ */
