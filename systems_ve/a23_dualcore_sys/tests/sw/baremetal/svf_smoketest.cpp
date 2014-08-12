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

extern "C" int write(int fd, const void *data, int sz);


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

#ifdef UNDEFINED
#endif

class svf_smoketest : public svf_test {
	svf_test_ctor_decl(svf_smoketest)

	public:
		svf_smoketest(const char *name) : svf_test(name) {

		}

		void build() {
			fprintf(stdout, "build\n");
		}

		void start() {
			fprintf(stdout, "--> start\n");
			fflush(stdout);
			raise_objection();
			raise_objection();
			m_thread1.init(this, &svf_smoketest::run1);
			m_thread1.start();
			m_thread2.init(this, &svf_smoketest::run2);
			m_thread2.start();
			fprintf(stdout, "<-- start\n");
			fflush(stdout);
		}

		void run1() {
			char *buf = (char *)malloc(128);
			for (uint32_t i=0; i<16; i++) {
				fprintf(stdout, "run1: %d\n", i);
//				sprintf(buf, "run1: %d\n", (15-i));
//				fwrite(buf, 1, strlen(buf), stdout);
//				fflush(stdout);
//				write(0, buf, strlen(buf));
				uth_thread_yield();
			}
			drop_objection();
		}

		void run2() {
			for (uint32_t i=0; i<16; i++) {
				fprintf(stdout, "run2: %d\n", i);
				fflush(stdout);
				uth_thread_yield();
			}
			drop_objection();
		}

	private:
		svf_thread					m_thread1;
		svf_thread					m_thread2;

};

svf_test_ctor_def(svf_smoketest)
/*
 */



int main(int argc, char **argv)
{
	char buf[256];
	char *c;

	for (uint32_t i=0; i<16; i++) {
		fprintf(stdout, "i: %d\n", (15-i));
		fflush(stdout);
	}

#ifdef UNDEFINED
#endif
//	FILE *fp = fopen("foo", "r");
	write(0, "Hello World\n", 12);
//	for (uint32_t i=0; i<64; i++) {
	c = (char *)malloc(32);
//	fprintf(fp, "Hello World (1) %p\n", c);
//	fflush(fp);
	sprintf(buf, "Hello World %p\n", c);
	write(0, buf, strlen(buf));
//	}


	svf_smoketest *test = svf_smoketest::type_id.create("foo");
//	svf_smoketest *test = new svf_smoketest("foo");
//	(void)test;

	fprintf(stdout, "test=%p\n", test);
	fflush(stdout);

	fprintf(stdout, "--> elaborate()\n");
	fflush(stdout);
	test->elaborate();
	fprintf(stdout, "<-- elaborate()\n");
	fflush(stdout);
	fprintf(stdout, "--> run()\n");
	fflush(stdout);
	test->run();
	fprintf(stdout, "<-- run()\n");
	fflush(stdout);

	/*
	svf_runtest("svf_smoketest");
	 */

	/*
	 */

	while (1) {
		uth_thread_yield();
	}
}



