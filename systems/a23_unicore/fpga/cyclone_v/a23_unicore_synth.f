-project a23_unicore_sys
-top a23_unicore_cyclone_v_top
-f ../../../../common/fpga/altera_sockit_settings.f
-f ${SOCBLOX}/systems/a23_unicore/a23_unicore.f

-f ${SOCBLOX}/common/sram/fpga/altera/altera_memories.f

${SOCBLOX}/systems/a23_unicore/fpga/cyclone_v/a23_unicore_sys.sdc

${SOCBLOX}/systems/a23_unicore/fpga/cyclone_v/a23_unicore_cyclone_v_top.sv
// ${SOCBLOX}/units/uart2axi/uart2axi.sv

/**
 * Port mapping
 */
-assign-pin brdclk PIN_K14 
-assign-pin led0 PIN_AF10 
-assign-pin led1 PIN_AD10 
-assign-pin led2 PIN_AE11 
-assign-pin led3 PIN_AD7 

/**
 * Voltage
 */ 
-io-standard brdclk "3.3-V LVTTL"
-io-standard led0 "3.3-V LVTTL"
-io-standard led1 "3.3-V LVTTL"
-io-standard led2 "3.3-V LVTTL"
-io-standard led3 "3.3-V LVTTL"


