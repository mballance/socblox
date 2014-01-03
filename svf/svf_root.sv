/****************************************************************************
 * svf_root.sv
 ****************************************************************************/

/**
 * Module: svf_root
 * 
 * TODO: Add module documentation
 */
module svf_root(input clk);
	reg test_ended = 0;
	
	always @(posedge clk) begin
		if (test_ended) begin
			$finish(0);
		end
	end
	
	task svf_runtest(string testname=null);
		int ret;
	
		if (testname == null) begin
			$value$plusargs("+SVF_TESTNAME=%s", testname);
			if (testname == null) begin
				$display("FATAL: testname not supplied and no +SVF_TESTNAME argument");
				$finish(1);
			end
		end
		
		ret = svf_runtest_init(testname);
		
		if (ret != 0) begin
			$display("FATAL: Failed to start test %s", testname);
			$finish(1);
		end
	endtask
	
	import "DPI-C" context function int svf_runtest_init(string testname);
	
	task svf_runtest_end();
		test_ended = 1;
	endtask
	export "DPI-C" task svf_runtest_end;

endmodule

