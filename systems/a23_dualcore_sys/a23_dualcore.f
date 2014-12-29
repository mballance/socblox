
+incdir+${COMMON_RTL}/axi4
${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/axi4/axi4_monitor.sv
${COMMON_RTL}/wb/wb_if.sv
${COMMON_RTL}/uart/uart_if.sv

${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_dualport_w.sv

-f ${UNITS}/axi4_a23/axi4_a23.f
-f ${UNITS}/axi4_a23_mp/axi4_a23_mp.f
-f ${UNITS}/axi4_a23_dual/axi4_a23_dual.f

${UNITS}/bidi_message_queue/bidi_message_queue_if.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv
${UNITS}/axi4_rom/axi4_rom.sv
${UNITS}/axi4_sram/axi4_sram.sv
${UNITS}/timer/timer.sv
${UNITS}/interrupt_controller/interrupt_controller.sv
${UNITS}/coreinfo/coreinfo_2.sv
${UNITS}/wb_uart/wb_uart.sv

${UNITS}/interconnects/axi4/axi4_interconnect_1x8.sv
${UNITS}/interconnects/axi4/axi4_interconnect_2x1.sv
${UNITS}/interconnects/wb/wb_interconnect_1x3.sv

-f ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect.f

${UNITS}/interconnects/axi4/axi4_wb_bridge.sv

${SYSTEMS}/a23_dualcore_sys/a23_dualcore_sys.sv
