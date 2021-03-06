/*
 * axi4_a23_svf_coretest.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef AXI4_A23_SVF_CORETEST_H_
#define AXI4_A23_SVF_CORETEST_H_

#include "axi4_a23_svf_test_base.h"

class axi4_a23_svf_coretest:
		public axi4_a23_svf_test_base,
		public virtual a23_tracer_if {
	svf_test_ctor_decl(axi4_a23_svf_coretest)

	public:
		axi4_a23_svf_coretest(const char *name);

		virtual ~axi4_a23_svf_coretest();

		virtual void build();

		virtual void connect();

		virtual void start();

		void run();

		// Tracer API
		virtual void mem_access(
				uint32_t			addr,
				bool				is_write,
				uint32_t			data);

		virtual void execute(
				uint32_t			addr,
				uint32_t			op
				);

		virtual void regchange(
				uint32_t			reg,
				uint32_t			val
				);

	private:
		svf_api_export<a23_tracer_if>		tracer_port;

	private:
		svf_thread							m_run_thread;
		svf_semaphore						m_end_sem;
		uint32_t							m_instr_timeout;
		uint32_t							m_instr_count;
		uint32_t							m_test_status;

};

#endif /* AXI4_A23_SVF_CORETEST_H_ */
