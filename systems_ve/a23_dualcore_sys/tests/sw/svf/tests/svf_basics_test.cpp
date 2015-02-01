/*
 * svf_basics_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "svf_basics_test.h"

svf_basics_test::svf_basics_test(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

svf_basics_test::~svf_basics_test() {
	// TODO Auto-generated destructor stub
}

void svf_basics_test::build() {
	svf_test::build();
	m_env = a23_dualcore_sys_env::type_id.create("m_env", this);
}

void svf_basics_test::connect() {
	svf_test::connect();
}

void svf_basics_test::start() {
	svf_test::start();


	m_t1.init(this, &svf_basics_test::t1_main);
	m_t2.init(this, &svf_basics_test::t2_main);

	m_t1.start();
	m_t2.start();

}

void svf_basics_test::t1_main() {
	raise_objection();
	printf("Hello from t1_main()\n");
	drop_objection();
}

void svf_basics_test::t2_main() {
	raise_objection();
	printf("Hello from t2_main()\n");
	drop_objection();
}

svf_test_ctor_def(svf_basics_test)

