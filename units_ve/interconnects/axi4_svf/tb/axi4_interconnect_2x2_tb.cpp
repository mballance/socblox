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
#include "svf.h"

class axi4_interconnect_tb : public sc_module {

	public:

		SC_HAS_PROCESS(axi4_interconnect_tb);

		axi4_interconnect_tb(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)) {

			tb = new Vaxi4_interconnect_2x2_tb("tb");
			tb->clk(clk);

			SC_THREAD(run);
		}

		void run() {
			wait(sc_time(1, SC_NS));

			svf_runtest();
			sc_stop();
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

	sc_start(1000000, SC_NS);

	tb->tb->final();
	tfp->close();

	return 0;
}
