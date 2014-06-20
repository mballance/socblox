/*
 * bidi_message_queue_direct_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_direct_test_base.h"
#include "svf_elf_loader.h"

bidi_message_queue_direct_test_base::bidi_message_queue_direct_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

bidi_message_queue_direct_test_base::~bidi_message_queue_direct_test_base() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_direct_test_base::build()
{
	m_env = bidi_message_queue_direct_env::type_id.create("m_env", this);
}

void bidi_message_queue_direct_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	// TODO: connect BFMs
	axi4_master_bfm_dpi_mgr::connect(TB_ROOT + ".u_axi4_bfm",
			m_env->m_master_bfm->bfm_port);
	bidi_message_queue_direct_bfm_dpi_mgr::connect(TB_ROOT + ".u_queue",
			m_env->m_message_queue_bfm->bfm_port);

}

void bidi_message_queue_direct_test_base::start()
{
	m_runthread.init(this, &bidi_message_queue_direct_test_base::run);
	m_runthread.start();
}

void bidi_message_queue_direct_test_base::run()
{
	string target_exe;
	string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

}

void bidi_message_queue_direct_test_base::shutdown()
{

}

svf_test_ctor_def(bidi_message_queue_direct_test_base)

