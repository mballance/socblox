

// -f ${SOCBLOX}/units/axi4_a23/axi4_a23.f
-f ${SOCBLOX}/units/interconnects/interconnects.f
-f ${SOCBLOX}/units/ethmac/ethmac.f
${SOCBLOX}/units/a23_dualcore_subsys/a23_dualcore_subsys.sv
-f ${UNITS}/altor32/altor32.f
${SOCBLOX}/units/timer/timer.sv
${SOCBLOX}/units/interrupt_controller/interrupt_controller.sv
${SOCBLOX}/units/axi4_rom/axi4_rom.sv
${SOCBLOX}/units/rtc/rtc.sv
${SOCBLOX}/units/axi4_sram/axi4_sram.sv
${SOCBLOX}/units/wb_uart/wb_uart.sv

${SOCBLOX}/units/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${SOCBLOX}/units/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv

${SOCBLOX}/units/bidi_message_queue/bidi_message_queue.sv
${SOCBLOX}/units/bidi_message_queue/bidi_message_queue_if.sv

-f ${UNITS}/axi4_a23_mp/axi4_a23_mp.f
-f ${UNITS}/axi4_a23_dual/axi4_a23_dual.f
-f ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect.f
-f ${UNITS}/wb_vga_lcd/wb_vga_lcd.f

${UNITS}/wb_sram/wb_sram.sv
${UNITS}/wb_rom/wb_rom.sv

-f ${UNITS}/wb_sram_bridges/wb_sram_bridges.f


${UNITS}/coreinfo/coreinfo_2.sv




