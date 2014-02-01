/*
 * svf_sc_tb.h
 *
 *  Created on: Feb 1, 2014
 *      Author: ballance
 */

#ifndef SVF_SC_TB_H_
#define SVF_SC_TB_H_

#ifdef VL_TRACE_EN
#include "verilated_vcd_sc.h"
#endif
#include "verilated.h"
#include <systemc.h>
#include "svdpi.h"

template <class TB> class svf_sc_tb : public sc_module {

	SC_HAS_PROCESS(svf_sc_tb<TB>);

	public:

		svf_sc_tb(const sc_module_name &in) :
			sc_module(in), clk("clk", sc_time(10, SC_NS)) {
			tb = new TB("tb");
			tb->clk(clk);

			running = false;

			SC_THREAD(run);
		}

		void run() {
			running = true;
			wait(sc_time(1, SC_NS));

			svf_runtest();

			running = false;

			sc_stop();
		}

		static int sc_main(int argc, char **argv) {
			for (int i=0; i<argc; i++) {
				fprintf(stdout, "ARGV[%d]=%s\n", i, argv[i]);
			}

#ifdef VERILATOR
			Verilated::commandArgs(argc, argv);
#endif

			svf_sc_tb<TB> *tb = new svf_sc_tb<TB>("tb");

#ifdef VL_TRACE_EN
			Verilated::traceEverOn(true);
#endif

			sc_start(1, SC_NS);

#ifdef VL_TRACE_EN
			VerilatedVcdSc *tfp = new VerilatedVcdSc();
			tb->tb->trace(tfp, 99);
			tfp->open("vlt_dump.vcd");
#endif

			sc_start(1000000, SC_NS);

			if (tb->running) {
				fprintf(stdout, "FAIL: timeout\n");
			}

#ifdef VL_TRACE_EN
			tb->tb->final();
			tfp->close();
#endif

			return 0;
		}

	public:
		sc_clock					clk;
		TB							*tb;
		bool						running;

};


#endif /* SVF_SC_TB_H_ */
