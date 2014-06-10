/*
 * uth_coop_scheduler_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "uth_coop_scheduler_test_base.h"
#include "uth.h"

uth_coop_scheduler_test_base::uth_coop_scheduler_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

uth_coop_scheduler_test_base::~uth_coop_scheduler_test_base() {
	// TODO Auto-generated destructor stub
}

void uth_coop_scheduler_test_base::build()
{
	m_env = uth_coop_scheduler_env::type_id.create("m_env", this);
}

void uth_coop_scheduler_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	// TODO: connect BFMs
}

void uth_coop_scheduler_test_base::start()
{
	m_runthread.init(this, &uth_coop_scheduler_test_base::run);
	m_runthread.start();
}

void thread_main(void *ud)
{
	fprintf(stdout, "thread_main\n");
}

void uth_coop_scheduler_test_base::run()
{
	string target_exe;
	string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

	{
		uth_thread_t main_t;

		uth_thread_create(&main_t, &thread_main, 0);
		fprintf(stdout, "--> yield\n");
		uth_thread_yield();
		fprintf(stdout, "<-- yield\n");
	}
}

void uth_coop_scheduler_test_base::shutdown()
{

}

svf_test_ctor_def(uth_coop_scheduler_test_base)

