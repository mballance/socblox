/****************************************************************************
 * ${name}.sv
 ****************************************************************************/

/**
 * Module: ${name}
 * 
 * TODO: Add module documentation
 */
module ${name}(
		);

	// TODO: Implement 'target' tasks
	/*
    task ${name}_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	//
    endtask
    export "DPI-C" task ${name}_write8;
    	 */

	// TODO: Implement 'host' tasks
	// import "DPI-C" task ${name}_foo();
    
    import "DPI-C" context task ${name}_register();
    initial begin
    	${name}_register();
    end

endmodule

