/*
 * a23_tracer_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef A23_TRACER_DPI_MGR_H_
#define A23_TRACER_DPI_MGR_H_
#include "svm.h"
#include "a23_tracer_if.h"
#include <map>
#include <string>

using namespace std;

class a23_tracer_dpi_mgr;

class a23_tracer_dpi_closure {

	public:

		typedef svm_api_publisher_port<a23_tracer_if>	port_t;

		a23_tracer_dpi_closure(const string &target) :
			m_target(target), m_port(0) {
		}

		void connect(port_t *port) {
			fprintf(stdout, "port=%p\n", port);
			m_port = port;
		}

		port_t *port() {
			return m_port;
		}

		template <typename ...Ts> void call(void (a23_tracer_if::*method)(Ts...), Ts... args) {
			if (m_port) {
				(*m_port)(method, args...);
			} else {
				fprintf(stdout, "PORT NULL\n");
			}
		}

	private:
		string								m_target;
		port_t								*m_port;

};

class a23_tracer_dpi_mgr {

	public:

		static void connect(
				const string 					&target,
				a23_tracer_dpi_closure::port_t 	&port);

		static void register_bfm(const string &target);

		static a23_tracer_dpi_closure *get_closure(const string &target);

	private:

		static map<string, a23_tracer_dpi_closure *>				m_closure_map;

};



#endif /* A23_TRACER_DPI_MGR_H_ */
