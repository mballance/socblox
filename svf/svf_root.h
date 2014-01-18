/*
 * svf_root.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_ROOT_H_
#define SVF_ROOT_H_

#include "svf_component.h"
#include "svf_objection.h"
#include "svf_config_db.h"

class svf_cmdline;

class svf_root : public svf_component {

	public:
		svf_root(const char *name);

		virtual ~svf_root();

		void elaborate();

		void run();

		svf_cmdline &cmdline();

		virtual void raise_objection();

		virtual void drop_objection();

		svf_config_db &config_db();

	private:

		void do_build(svf_component *level);

		void do_connect(svf_component *level);

		void do_start(svf_component *level);

		void do_shutdown(svf_component *level);

	private:

		svf_cmdline					*m_cmdline;
		svf_objection				m_objection;
		svf_config_db				m_config_db;

};

#endif /* SVF_ROOT_H_ */
