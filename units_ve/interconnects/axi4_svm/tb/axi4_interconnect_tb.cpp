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

		SC_HAS_PROCESS(axi4_interconnect_tb);

		axi4_interconnect_tb(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)) {

			tb = new Vaxi4_interconnect_2x2_tb("tb");
			tb->clk(clk);

			SC_THREAD(run);

			/*
			master_bfm = new axi4_master_bfm("master_bfm", 0);

			axi4_master_bfm_dpi_mgr::connect("foo", master_bfm->bfm_port);
			 */
		}

		void run() {
			wait(sc_time(1, SC_NS));

			svm_test *test = svm_factory::get_default()->create_test("axi4_interconnect_test_base", "root");

			test->elaborate();
			test->run();
		}

	public:
		sc_clock					clk;
		Vaxi4_interconnect_2x2_tb	*tb;
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
