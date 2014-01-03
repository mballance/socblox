/*
 * svf_dpi_mgr.h
 *
 *  Created on: Dec 30, 2013
 *      Author: ballance
 */

#ifndef SVF_DPI_MGR_H_
#define SVF_DPI_MGR_H_
#include <map>
#include <string>
#include "svf_dpi_closure.h"

using namespace std;


template <class closure_t> class svf_dpi_mgr {

	public:

		static void connect(
				const string					&target,
				typename closure_t::port_t		&port);

		static void register_bfm(const string &target);

		static closure_t *get_closure(const string &target);


	private:

		static map<string, closure_t *>				m_closure_map;

};

template <class closure_t> void svf_dpi_mgr<closure_t>::connect(
		const string					&target,
		typename closure_t::port_t		&port)
{
	typename map<string, closure_t *>::iterator it;

	it = m_closure_map.find(target);

	closure_t *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new closure_t(target);
		m_closure_map[target] = c;
	} else {
		c = it->second;
	}

	c->connect(&port);
}

template <class closure_t> void svf_dpi_mgr<closure_t>::register_bfm(const string &target)
{
	typename map<string, closure_t *>::iterator it;

	it = m_closure_map.find(target);

	closure_t *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new closure_t(target);
		m_closure_map[target] = c;
	}
}

template <class closure_t> closure_t *svf_dpi_mgr<closure_t>::get_closure(const string &target)
{
	typename map<string, closure_t *>::iterator it;

	it = m_closure_map.find(target);

	closure_t *c = 0;

	if (it != m_closure_map.end()) {
		c = it->second;
	}

	return c;
}

template <class closure_t> map<string, closure_t *> svf_dpi_mgr<closure_t>::m_closure_map;


#endif /* SVF_DPI_MGR_H_ */
