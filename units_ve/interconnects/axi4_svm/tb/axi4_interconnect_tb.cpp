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
#include "svm_factory.h"
#include "svm.h"

class axi4_interconnect_tb : public sc_module {

	public:
		axi4_interconnect_tb(const sc_module_name &in) : sc_module(in),
			clk("clk", sc_time(10, SC_NS)), t1_ready(false), t2_ready(false) {

			tb = new Vaxi4_interconnect_2x2_tb("tb");

			tb->clk(clk);

//			test = svm_factory::get_default().create_component("", "", 0);
			// (*this, axi4_interconnect_tb::run);
			svm_closure<axi4_interconnect_tb> *c1 = new svm_closure<axi4_interconnect_tb>(this, &axi4_interconnect_tb::t1);
			svm_closure<axi4_interconnect_tb> *c2 = new svm_closure<axi4_interconnect_tb>(this, &axi4_interconnect_tb::t2);
//			c();
//			svm_thread *t = new svm_thread(c);
//			svm_thread *t = svm_thread::create(svm_closure<axi4_interconnect_tb>(this, &axi4_interconnect_tb::run));
			svm_thread *t1 = svm_thread::create(this, &axi4_interconnect_tb::t1);
			svm_thread *t2 = svm_thread::create(this, &axi4_interconnect_tb::t2);
			t1->start();
			t2->start();
		}

		void t1() {
			for (int i=0; i<5; i++) {
				fprintf(stdout, "--> t1: t1 -> t2\n");
				mutex_t1t2.lock();
				t1_ready = true;
				cond_t1t2.notify();
				mutex_t1t2.unlock();
				fprintf(stdout, "<-- t1: t1 -> t2\n");

				fprintf(stdout, "--> t1: t2 -> t1\n");
				mutex_t2t1.lock();
				if (!t2_ready) {
					cond_t2t1.wait(mutex_t2t1);
				}
				t2_ready = false;
				mutex_t2t1.unlock();
				fprintf(stdout, "<-- t1: t2 -> t1\n");
			}
		}

		void t2() {
			for (int i=0; i<5; i++) {
				fprintf(stdout, "--> t2: t1 -> t2\n");
				mutex_t1t2.lock();
				if (!t1_ready) {
					cond_t1t2.wait(mutex_t1t2);
				}
				t1_ready = false;
				mutex_t1t2.unlock();
				fprintf(stdout, "<-- t2: t1 -> t2\n");

				fprintf(stdout, "--> t2: t2 -> t1\n");
				mutex_t2t1.lock();
				t2_ready = true;
				cond_t2t1.notify();
				mutex_t2t1.unlock();
				fprintf(stdout, "<-- t2: t2 -> t1\n");
			}
		}

	public:
		sc_clock					clk;
		Vaxi4_interconnect_2x2_tb	*tb;
		svm_component				*test;
		svm_thread_mutex			mutex_t1t2;
		svm_thread_cond				cond_t1t2;
		bool						t1_ready;
		svm_thread_mutex			mutex_t2t1;
		svm_thread_cond				cond_t2t1;
		bool						t2_ready;
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
