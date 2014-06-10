/*
 * uth_coop_scheduler_test_mutex.h
 *
 *  Created on: Jun 2, 2014
 *      Author: ballance
 */

#ifndef UTH_COOP_SCHEDULER_TEST_MUTEX_H_
#define UTH_COOP_SCHEDULER_TEST_MUTEX_H_
#include "uth_coop_scheduler_test_base.h"
#include "uth.h"

// Have each job request access to various resources
// Resources signified by a mutex

class r_job {

	public:
		r_job(uint32_t id, uth_mutex_t *resources, uint32_t n_resources) {
			m_id = id;
			m_resources = resources;
			m_n_resources = n_resources;
		}

		static void run(void *ud) {
			static_cast<r_job *>(ud)->run();
		}

		void run() {
			for (uint32_t i=0; i<1024; i++) {
				uint32_t rid = (rand() % m_n_resources);
				uint32_t len = (rand() % 100);

				fprintf(stdout, "--> job=%d locks resource %d for %d\n", m_id, rid, len);
				uth_mutex_lock(&m_resources[rid]);
				fprintf(stdout, "<-- job=%d locks resource %d for %d\n", m_id, rid, len);
				for (uint32_t l=0; l<len; l++) {
					uth_thread_yield();
				}
				fprintf(stdout, "--> job=%d releases resource %d\n", m_id, rid);
				uth_mutex_unlock(&m_resources[rid]);
				fprintf(stdout, "<-- job=%d releases resource %d\n", m_id, rid);
			}
		}

	private:
		uint32_t				m_id;
		uint32_t				m_n_resources;
		uth_mutex_t				*m_resources;

	public:
		uth_thread_t			m_thread;

};

class uth_coop_scheduler_test_mutex : public uth_coop_scheduler_test_base {
	svf_test_ctor_decl(uth_coop_scheduler_test_mutex)


	public:

		uth_coop_scheduler_test_mutex(const char *name);

		virtual ~uth_coop_scheduler_test_mutex();

		virtual void build();

		virtual void start();

	private:
		uth_mutex_t				*m_resources;
		uint32_t				  m_n_jobs;
		r_job					**m_jobs;

};

#endif /* UTH_COOP_SCHEDULER_TEST_MUTEX_H_ */
