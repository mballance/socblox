/*
 * axi4_amber23_svf_tb.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: ballance
 */
#include <systemc.h>
#include "svf.h"
#include "verilated_vcd_sc.h"
#include "Vaxi4_amber23_svf_tb.h"
#include "axi4_svf_sram_dpi_mgr.h"
#include "axi4_svf_sram_bfm.h"
#include "svf_elf_loader.h"
#include "svdpi.h"

class axi4_amber23_svf_tb : public sc_module {

	public:

		SC_HAS_PROCESS(axi4_amber23_svf_tb);

		axi4_amber23_svf_tb(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)) {

			tb = new Vaxi4_amber23_svf_tb("tb");
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
		Vaxi4_amber23_svf_tb		*tb;
};


int sc_main(int argc, char **argv)
{
	for (int i=0; i<argc; i++) {
		fprintf(stdout, "ARGV[%d]=%s\n", i, argv[i]);
	}
	Verilated::commandArgs(argc, argv);

	axi4_amber23_svf_tb *tb = new axi4_amber23_svf_tb("tb");
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
