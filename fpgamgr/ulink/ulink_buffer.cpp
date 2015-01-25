/*
 * hps_uart_buffer.cpp
 *
 *  Created on: Jan 7, 2015
 *      Author: ballance
 */

#include "ulink_buffer.h"

ulink_buffer::ulink_buffer(uint32_t page_sz) {
	m_page_sz = page_sz;
	m_alloc_ptr = 0;
	m_write_ptr = alloc_page();
	m_read_ptr = m_write_ptr;

}

ulink_buffer::~ulink_buffer() {
	// TODO Auto-generated destructor stub
	buffer_page *p, *tp;
	buffer_page *buffer_list[] = {m_alloc_ptr, m_read_ptr};

	for (int i=0; i<sizeof(buffer_list)/sizeof(buffer_page *); i++) {
		p = buffer_list[i];
		while (p) {
			tp = p;
			p = tp->next;
			if (tp->data) {
				delete [] tp->data;
			}
			delete tp;
		}
	}
}

int32_t ulink_buffer::read(uint8_t *buf, uint32_t sz)
{
	int32_t idx = 0;

	while (m_read_ptr && idx < sz) {
		while (m_read_ptr->rd_ptr < m_read_ptr->wr_ptr && idx < sz) {
			buf[idx++] = m_read_ptr->data[m_read_ptr->rd_ptr++];
		}

		if (m_read_ptr->rd_ptr >= m_read_ptr->wr_ptr) {
			if (m_read_ptr->wr_ptr >= m_page_sz) {
				// we've finished with the page
				buffer_page *tp = m_read_ptr;
				m_read_ptr = m_read_ptr->next;
				free_page(tp);
			} else {
				// we've run out of data in this page, but
				// this page is still being written
				break;
			}
		}
	}

	return idx;
}

int32_t ulink_buffer::write(uint8_t *buf, uint32_t sz)
{
	int32_t idx = 0;

	while (idx < sz) {

		while (idx < sz && m_write_ptr->wr_ptr < m_page_sz) {
			m_write_ptr->data[m_write_ptr->wr_ptr++] = buf[idx++];
		}

		if (m_write_ptr->wr_ptr >= m_page_sz) {
			// Page is full. Allocate a new one
			m_write_ptr->next = alloc_page();
			m_write_ptr = m_write_ptr->next;
		}
	}

	return idx;
}

ulink_buffer::buffer_page *ulink_buffer::alloc_page() {
	buffer_page *page = m_alloc_ptr;

	if (page) {
		m_alloc_ptr = m_alloc_ptr->next;
	} else {
		page = new buffer_page;
		page->data = new uint8_t[m_page_sz];
	}

	page->next = 0;
	page->wr_ptr = 0;
	page->rd_ptr = 0;

	return page;
}

void ulink_buffer::free_page(ulink_buffer::buffer_page *page) {
	page->next = m_alloc_ptr;
	m_alloc_ptr = page;
}
