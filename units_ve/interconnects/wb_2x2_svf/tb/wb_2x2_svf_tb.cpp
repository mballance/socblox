/*
 * wb_2x2_svf_tb.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include <stdio.h>
#include "svf.h"
#ifdef VL_TRACE_EN
#include "verilated_vcd_sc.h"
#endif
#include "Vwb_2x2_svf_tb.h"
#include <systemc.h>

// TODO:

class wb_2x2_svf_tb : public sc_module {

	SC_HAS_PROCESS(wb_2x2_svf_tb);

	public:

		wb_2x2_svf_tb(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)) {
			tb = new Vwb_2x2_svf_tb("tb");

			tb->clk(clk);

			SC_THREAD(run);
		}

		void run() {
			wait(sc_time(1, SC_NS));

			svf_runtest();

			sc_stop();
		}

	public:
		sc_clock							clk;
		Vwb_2x2_svf_tb						*tb;

};

int sc_main(int argc, char **argv)
{
	for (int i=0; i<argc; i++) {
		fprintf(stdout, "ARGV[%d]=%s\n", i, argv[i]);
	}

#ifdef VERILATOR
	Verilated::commandArgs(argc, argv);
#endif

	wb_2x2_svf_tb *tb = new wb_2x2_svf_tb("tb");

#ifdef VERILATOR
	Verilated::traceEverOn(true);
#endif

	sc_start(1, SC_NS);

#ifdef VL_TRACE_EN
	VerilatedVcdSc *tfp = new VerilatedVcdSc();
	tb->tb->trace(tfp, 99);
	tfp->open("vlt_dump.vcd");
#endif

	sc_start(1000000, SC_NS);

#ifdef VL_TRACE_EN
	tb->tb->final();
	tfp->close();
#endif

	return 0;
}
