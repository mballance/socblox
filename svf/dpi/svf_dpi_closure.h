/*
 * svf_dpi_closure.h
 *
 *  Created on: Dec 30, 2013
 *      Author: ballance
 */

#ifndef SVF_DPI_CLOSURE_H_
#define SVF_DPI_CLOSURE_H_
#include <string>

using namespace std;

/**
 * Implements the closure for a task imported into SV.
 *
 */
#define SVF_DPI_CLOSURE_IMPORT_TASK(prefix, method, prototype, args) \
	extern "C" int prefix ## _ ## method prototype ; \
	int prefix ## _ ## method prototype \
	{ \
		svScope scope = svGetScope(); \
		const char *name = svGetNameFromScope(scope); \
		prefix ## _dpi_closure *c = prefix ## _dpi_mgr::get_closure(name); \
		\
		if (c) { \
			c->host_if()-> method args ; \
		} \
		\
		return 0; \
	}

#define SVF_DPI_CLOSURE_EXPORT_TASK(prefix, method, prototype, args) \
	extern "C" void prefix ## _ ## method  prototype ; \
	void prefix ## _dpi_closure :: method prototype { \
		svScope scope = svGetScopeFromName(m_target.c_str()); \
		svSetScope(scope); \
		\
		prefix ## _ ## method args; \
	}

#define SVF_DPI_CLOSURE_REGISTER_TASK(prefix) \
	extern "C" int prefix ## _ ## register(); \
	int prefix ## _ ## register() \
	{ \
		svScope scope = svGetScope(); \
		const char *name = svGetNameFromScope(scope); \
		\
		fprintf(stdout, #prefix "_register: %s\n", name); \
		\
		prefix ## _dpi_mgr :: register_bfm(name); \
		\
		return 0; \
	}

template <class host_if_t, class target_if_t> class svf_dpi_closure : public virtual target_if_t {

	public:
		typedef svf_bidi_api_port<host_if_t, target_if_t>	port_t;

		svf_dpi_closure(const string &target) : m_target(target), m_port(0) { }

		void connect(port_t *port) {
			m_port = port;
			m_port->set_consumes(this);
		}

		host_if_t *host_if() {
			return m_port->provides();
		}

	protected:
		string							m_target;
		port_t							*m_port;

};



#endif /* SVF_DPI_CLOSURE_H_ */
