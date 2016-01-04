/****************************************************************************
 * vlog.f
 *
 * TODO: Filelist for testbench
 ****************************************************************************/
 
${COMMON_RTL}/wb/wb_if.sv
${COMMON_RTL}/vga/vga_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
-f ${COMMON_RTL}/../sram/common_sram.f
${COMMON_BFM}/wb_master_bfm/wb_master_bfm.sv
-f ${UNITS}/wb_sram_bridges/wb_sram_bridges.f
${UNITS}/wb_sram/wb_sram.sv
-f ${UNITS}/wb_vga_lcd/wb_vga_lcd.f

${SIM_DIR}/../tb/wb_vga_lcd_tb.sv


