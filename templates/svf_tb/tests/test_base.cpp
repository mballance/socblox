/*
 * ${name}_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "${name}_test_base.h"
#include "svf_elf_loader.h"

${name}_test_base::${name}_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

${name}_test_base::~${name}_test_base() {
	// TODO Auto-generated destructor stub
}

void ${name}_test_base::build()
{
	m_env = ${name}_env::type_id.create("m_env", this);
}

void ${name}_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	// TODO: connect BFMs
}

void ${name}_test_base::start()
{
	m_runthread.init(this, &${name}_test_base::run);
	m_runthread.start();
}

void ${name}_test_base::run()
{
	svf_string target_exe;
	svf_string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

}

void ${name}_test_base::shutdown()
{

}

svf_test_ctor_def(${name}_test_base)

