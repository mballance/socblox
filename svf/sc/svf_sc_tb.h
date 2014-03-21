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
			sc_time timeout = sc_time(1, SC_MS);
			bool trace = false;
			const char *tracefile = "vlt_dump.vcd";

			for (int i=0; i<argc; i++) {
				fprintf(stdout, "ARGV[%d]=%s\n", i, argv[i]);

				if (!strncmp(argv[i], "+TIMEOUT=", 9)) {
					char *u;
					uint32_t t = strtoul(&argv[i][9], &u, 10);

					fprintf(stdout, "t=%d u=%s\n", t, u);

					if (!strcmp(u, "fs")) {
						timeout = sc_time(t, SC_FS);
					} else if (!strcmp(u, "ps")) {
						timeout = sc_time(t, SC_PS);
					} else if (!strcmp(u, "ns")) {
						timeout = sc_time(t, SC_NS);
					} else if (!strcmp(u, "us")) {
						timeout = sc_time(t, SC_US);
					} else if (!strcmp(u, "ms")) {
						fprintf(stdout, "Timeout=%dms\n", t);
						timeout = sc_time(t, SC_MS);
					} else if (!strcmp(u, "s")) {
						timeout = sc_time(t, SC_SEC);
					} else {
						fprintf(stdout, "Error: Unknown timeout %s\n", argv[i]);
					}
				} else if (!strcmp(argv[i], "-trace")) {
					trace = true;
				}
			}

#ifdef VERILATOR
			Verilated::commandArgs(argc, argv);
#endif

			svf_sc_tb<TB> *tb = new svf_sc_tb<TB>("tb");

#ifdef VL_TRACE_EN
			Verilated::traceEverOn(trace);
#endif

			sc_start(1, SC_NS);

#ifdef VL_TRACE_EN
			VerilatedVcdSc *tfp = 0;

			if (trace) {
				tfp = new VerilatedVcdSc();
				tb->tb->trace(tfp, 99);
				tfp->open(tracefile);
			}
#endif

			sc_start(timeout);

			if (tb->running) {
				fprintf(stdout, "FAIL: timeout\n");
			}

#ifdef VL_TRACE_EN
			tb->tb->final();
			if (tfp) {
				tfp->close();
			}
#endif

			return 0;
		}

	public:
		sc_clock					clk;
		TB							*tb;
		bool						running;

};


#endif /* SVF_SC_TB_H_ */
