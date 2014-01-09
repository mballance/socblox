/****************************************************************************
 * svf_dpi_pkg.sv
 ****************************************************************************/

/**
 * Package: svf_dpi_pkg
 * 
 * TODO: Add package documentation
 */
package svf_pkg;
	
	import "DPI-C" context svf_sc_set_config_string = function void set_config_string(
			string path, string key, string val);

endpackage

