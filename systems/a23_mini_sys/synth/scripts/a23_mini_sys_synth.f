-project a23_mini_sys
-top a23_mini_sys
-f ${COMMON_RTL}/../fpga/altera_sockit_settings.f

+define+FPGA

-f ${SYSTEMS}/a23_mini_sys/a23_mini_sys.f

${COMMON_RTL}/../sram/fpga/altera/generic_rom.v
${COMMON_RTL}/../sram/fpga/altera/generic_sram_byte_en.v
${COMMON_RTL}/../sram/fpga/altera/generic_sram_line_en.v

a23_mini_sys.sdc

/**
 * Port mapping
 */
-assign-pin clk_i PIN_K14 
-assign-pin led0 PIN_AF10 
-assign-pin led1 PIN_AD10 
-assign-pin led2 PIN_AE11 
-assign-pin led3 PIN_AD7 

/**
 * Voltage
 */ 
-io-standard clk_i "3.3-V LVTTL"
-io-standard led0 "3.3-V LVTTL"
-io-standard led1 "3.3-V LVTTL"
-io-standard led2 "3.3-V LVTTL"
-io-standard led3 "3.3-V LVTTL"


