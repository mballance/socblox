/****************************************************************************
 * svf_dpi_pkg.sv
 ****************************************************************************/

/**
 * Package: svf_dpi_pkg
 * 
 * TODO: Add package documentation
 */
package svf_dpi_pkg;
	process						prv_proclist[$];
	
//	import "DPI-C" context task svf_dpi_create_thread_trampoline(chandle hndl);

	task svf_dpi_int_launcher(input chandle hndl, output process p);
		automatic process p_tmp;
		automatic mailbox #(process) sem = new(0);

		fork
			begin
				automatic process p = process::self();
				sem.put(p);
//				svf_dpi_create_thread_trampoline(hndl);
			end
		join_none

		$display("--> sem.get()");
		sem.get(p_tmp);
		$display("<-- sem.get()");
	endtask
	
	task svf_dpi_create_thread(input chandle hndl, output int unsigned out_p);
		automatic process p_tmp;
		automatic mailbox #(process) sem = new(0);
	
		svf_dpi_int_launcher(hndl, p_tmp);	

		out_p = prv_proclist.size();
		prv_proclist.push_back(p_tmp);
	endtask
	export "DPI-C" task svf_dpi_create_thread;

	task svf_dpi_tmp();
	endtask
	export "DPI-C" task svf_dpi_tmp;
	
//	import "DPI-C" context svf_dpi_run_test = task run_test(string testname=null);
	import "DPI-C" context svf_dpi_run_test = task run_test(string testname=null);

	import "DPI-C" function int svf_dpi_init();
	static int init = svf_dpi_init();

endpackage

