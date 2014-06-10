/*
 * uth_coop_scheduler_test_mutex.cpp
 *
 *  Created on: Jun 2, 2014
 *      Author: ballance
 */

#include "uth_coop_scheduler_test_mutex.h"

uth_coop_scheduler_test_mutex::uth_coop_scheduler_test_mutex(const char *name) : uth_coop_scheduler_test_base(name) {
	// TODO Auto-generated constructor stub

}

uth_coop_scheduler_test_mutex::~uth_coop_scheduler_test_mutex() {
	// TODO Auto-generated destructor stub
}

void uth_coop_scheduler_test_mutex::build()
{
	uint32_t n_resources = 4;
	uint32_t n_jobs = 16;

	m_n_jobs = n_jobs;

	m_resources = new uth_mutex_t[n_resources];
	m_jobs = new r_job *[n_jobs];

	for (uint32_t i=0; i<n_resources; i++) {
		uth_mutex_init(&m_resources[i]);
	}

	for (uint32_t i=0; i<n_jobs; i++) {
		m_jobs[i] = new r_job(i, m_resources, n_resources);
	}
}

void uth_coop_scheduler_test_mutex::start()
{
	for (uint32_t i=0; i<m_n_jobs; i++) {
		fprintf(stdout, "--> create %d\n", i);
		uth_thread_create(&m_jobs[i]->m_thread, &r_job::run, m_jobs[i]);
		fprintf(stdout, "<-- create %d\n", i);
	}

	for (uint32_t i=0; i<10000; i++) {
		fprintf(stdout, "--> yield\n");
		uth_thread_yield();
		fprintf(stdout, "<-- yield\n");
	}
}

svf_test_ctor_def(uth_coop_scheduler_test_mutex)
