/*
 * a23_dualcore_sys_smoke_test.cpp
 *
 *  Created on: Jan 28, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_smoke_test.h"
#include "svf_elf_loader.h"

a23_dualcore_sys_smoke_test::a23_dualcore_sys_smoke_test(const char *name) :
	a23_dualcore_sys_test_base(name) {
	// TODO Auto-generated constructor stub

}

a23_dualcore_sys_smoke_test::~a23_dualcore_sys_smoke_test() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_smoke_test::connect()
{
	a23_dualcore_sys_test_base::connect();
}

void a23_dualcore_sys_smoke_test::start()
{
	string target_exe;
	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {

	}

	svf_elf_loader loader(m_env->m_bootrom);

	int ret = loader.load(target_exe.c_str());

	raise_objection();
}

svf_test_ctor_def(a23_dualcore_sys_smoke_test)
