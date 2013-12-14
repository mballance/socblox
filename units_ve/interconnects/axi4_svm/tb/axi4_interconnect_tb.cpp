/*
 * axi4_interconnect_tb.cpp
 *
 *  Created on: Dec 10, 2013
 *      Author: ballance
 */

#include <systemc.h>
#include "verilated_vcd_sc.h"
// #include "axi4_interconnect_tb.h"
#include "Vaxi4_interconnect_2x2_tb.h"
#include "axi4_master_bfm.h"
#include "svm_factory.h"
#include "svm.h"

class axi4_interconnect_tb : public sc_module {

	public:
		axi4_interconnect_tb(const sc_module_name &in) : sc_module(in),
			clk("clk", sc_time(10, SC_NS)), t1_t(this, &axi4_interconnect_tb::t1),
			t1_ready(false), t2_ready(false), m_sem_t1t2(0), m_sem_t2t1(0) {

			master_bfm = new axi4_master_bfm("master_bfm", 0);

			axi4_master_bfm_dpi_mgr::connect("foo", master_bfm->bfm_port);

			tb = new Vaxi4_interconnect_2x2_tb("tb");

			tb->clk(clk);

			t2_t.init(this, &axi4_interconnect_tb::t2);
			t1_t.start();
			t2_t.start();
		}

		void t1() {
			for (int i=0; i<5; i++) {
				fprintf(stdout, "--> t1: t1 -> t2\n");
				m_sem_t1t2.put();
				/*
				mutex_t1t2.lock();
				t1_ready = true;
				cond_t1t2.notify();
				mutex_t1t2.unlock();
				 */
				fprintf(stdout, "<-- t1: t1 -> t2\n");

				fprintf(stdout, "--> t1: t2 -> t1\n");
				m_sem_t2t1.get();
				/*
				mutex_t2t1.lock();
				if (!t2_ready) {
					cond_t2t1.wait(mutex_t2t1);
				}
				t2_ready = false;
				mutex_t2t1.unlock();
				 */
				fprintf(stdout, "<-- t1: t2 -> t1\n");
			}
		}

		void t2() {
			for (int i=0; i<5; i++) {
				fprintf(stdout, "--> t2: t1 -> t2\n");
				m_sem_t1t2.get();
				/*
				mutex_t1t2.lock();
				if (!t1_ready) {
					cond_t1t2.wait(mutex_t1t2);
				}
				t1_ready = false;
				mutex_t1t2.unlock();
				 */
				fprintf(stdout, "<-- t2: t1 -> t2\n");

				fprintf(stdout, "--> t2: t2 -> t1\n");
				m_sem_t2t1.put();
				/*
				mutex_t2t1.lock();
				t2_ready = true;
				cond_t2t1.notify();
				mutex_t2t1.unlock();
				 */
				fprintf(stdout, "<-- t2: t2 -> t1\n");
			}
		}

	public:
		sc_clock					clk;
		Vaxi4_interconnect_2x2_tb	*tb;
		svm_component				*test;

		svm_thread					t1_t;
		svm_thread					t2_t;

		svm_semaphore				m_sem_t1t2;
		svm_semaphore				m_sem_t2t1;

		svm_thread_mutex			mutex_t1t2;
		svm_thread_cond				cond_t1t2;
		bool						t1_ready;
		svm_thread_mutex			mutex_t2t1;
		svm_thread_cond				cond_t2t1;
		bool						t2_ready;
		axi4_master_bfm				*master_bfm;
};


int sc_main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);

	axi4_interconnect_tb *tb = new axi4_interconnect_tb("tb");
	Verilated::traceEverOn(true);

	sc_start(1, SC_NS);

	VerilatedVcdSc *tfp = new VerilatedVcdSc();
	tb->tb->trace(tfp, 99);
	tfp->open("vlt_dump.vcd");

	sc_start(10000, SC_NS);

	tb->tb->final();
	tfp->close();

	return 0;
}
