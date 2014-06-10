/****************************************************************************
 * timebase.sv
 ****************************************************************************/

/**
 * Module: timebase
 * 
 * TODO: Add module documentation
 */
module timebase(
		);

	// TODO: Implement 'target' tasks
	/*
    task timebase_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	//
    endtask
    export "DPI-C" task timebase_write8;
    	 */

	// TODO: Implement 'host' tasks
	// import "DPI-C" task timebase_foo();
	task timebase_gettime(
		output longint unsigned curr_time);
		curr_time = $time;
	endtask
	export "DPI-C" task timebase_gettime;
    
    import "DPI-C" context task timebase_register();
    initial begin
    	timebase_register();
    end

endmodule

