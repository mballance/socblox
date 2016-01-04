/****************************************************************************
 * vga_if.sv
 ****************************************************************************/

/**
 * Interface: vga_if
 * 
 * TODO: Add interface documentation
 */
interface vga_if;
	
	bit						clk_p;
	bit						hsync;
	bit						vsync;
	bit						csync;
	bit						blank;
	bit[7:0]				r;
	bit[7:0]				g;
	bit[7:0]				b;

	modport framebuf(
			output			clk_p,
			output			hsync,
			output			vsync,
			output			csync,
			output			blank,
			output			r,
			output			g,
			output			b);
	
	modport display(
			input			clk_p,
			input			hsync,
			input			vsync,
			input			csync,
			input			blank,
			input			r,
			input			g,
			input			b);
			
endinterface


