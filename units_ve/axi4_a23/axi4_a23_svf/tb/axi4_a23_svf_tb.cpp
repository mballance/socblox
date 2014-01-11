/*
 * axi4_a23_svf_tb.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: ballance
 */
#include <systemc.h>
#include "svf.h"

#ifdef QUESTA
#include "axi4_a23_svf_tb_wrapper.h"
#else
#ifdef VL_TRACE_EN
#include "verilated_vcd_sc.h"
#endif
#include "Vaxi4_a23_svf_tb.h"
// #define axi4_a23_svf_tb	Vaxi4_a23_svf_tb
#endif

#include "axi4_svf_sram_dpi_mgr.h"
#include "axi4_svf_sram_bfm.h"
#include "svf_elf_loader.h"
#include "svdpi.h"

class axi4_a23_svf_tb_sc : public sc_module {

	public:

		SC_HAS_PROCESS(axi4_a23_svf_tb_sc);

		axi4_a23_svf_tb_sc(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)), clk_n("clk_n") {

#ifdef QUESTA
			tb = new axi4_a23_svf_tb("tb", "axi4_a23_svf_tb");
#else
			tb = new Vaxi4_a23_svf_tb("tb");
#endif
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
		sc_signal<bool>				clk_n;
		Vaxi4_a23_svf_tb		*tb;
};


int sc_main(int argc, char **argv)
{
	for (int i=0; i<argc; i++) {
		fprintf(stdout, "ARGV[%d]=%s\n", i, argv[i]);
	}

#ifdef VERILATOR
	Verilated::commandArgs(argc, argv);
#endif

	axi4_a23_svf_tb_sc *tb = new axi4_a23_svf_tb_sc("tb");

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
