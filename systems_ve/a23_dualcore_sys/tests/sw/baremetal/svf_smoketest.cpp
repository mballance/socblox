/*
 * svf_smoketest.cpp
 *
 *  Created on: Jul 21, 2014
 *      Author: ballance
 */

#include "svf.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "svf_cmdline.h"


svf_ptr_vector<svf_string> svf_cmdline::args()
{
	svf_ptr_vector<svf_string> ret;
	return ret;
}

/*
 */
void *__dso_handle = (void *)NULL;

extern "C" void irq_handler() { }

static uth_coop_thread_mgr *thread_mgr = 0;
extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	if (!thread_mgr) {
		thread_mgr = new uth_coop_thread_mgr();
		thread_mgr->init();
	}
	return thread_mgr;
}

class svf_smoketest : public svf_test {
	svf_test_ctor_decl(svf_smoketest)

	public:
		svf_smoketest(const char *name) : svf_test(name) {

		}

	private:

};

svf_test_ctor_def(svf_smoketest)
/*
 */

extern "C" int write(int fd, const void *data, int sz);

svf_smoketest *ctor() {
	return new svf_smoketest("foo");
}

int main(int argc, char **argv)
{
	char buf[256];
	char *c;
	FILE *fp = fopen("foo", "r");
	write(0, "Hello World\n", 12);
//	for (uint32_t i=0; i<64; i++) {
	c = (char *)malloc(32);
	fprintf(fp, "Hello World (1) %p\n", c);
	fflush(fp);
	sprintf(buf, "Hello World %p\n", c);
	write(0, buf, strlen(buf));
//	}


	svf_smoketest *test = svf_smoketest::type_id.create("foo");
//	svf_smoketest *test = new svf_smoketest("foo");
//	(void)test;

	fprintf(stdout, "test=%p\n", test);
	fflush(stdout);

	test = svf_smoketest::type_id.create("foo");
	fprintf(stdout, "test=%p\n", test);
	fflush(stdout);

	/*
	 */

	while (1) {}
}



