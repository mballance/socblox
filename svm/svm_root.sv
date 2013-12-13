/****************************************************************************
 * svm_root.sv
 ****************************************************************************/

/**
 * Module: svm_root
 * 
 * TODO: Add module documentation
 */
module svm_root(input clk);
	reg test_ended = 0;
	
	always @(posedge clk) begin
		if (test_ended) begin
			$finish(0);
		end
	end
	
	task svm_runtest(string testname=null);
		int ret;
	
		if (testname == null) begin
			$value$plusargs("+SVM_TESTNAME=%s", testname);
			if (testname == null) begin
				$display("FATAL: testname not supplied and no +SVM_TESTNAME argument");
				$finish(1);
			end
		end
		
		ret = svm_runtest_init(testname);
		
		if (ret != 0) begin
			$display("FATAL: Failed to start test %s", testname);
			$finish(1);
		end
	endtask
	
	import "DPI-C" context function int svm_runtest_init(string testname);
	
	task svm_runtest_end();
		test_ended = 1;
	endtask
	export "DPI-C" task svm_runtest_end;

endmodule

