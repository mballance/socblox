
${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/axi4/axi4_monitor.sv
${COMMON_RTL}/wb/wb_if.sv

${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_line_en_w.sv

-f ${UNITS}/axi4_a23/axi4_a23.f

${UNITS}/interconnects/axi4/axi4_interconnect_1x4.sv
${UNITS}/interconnects/axi4/axi4_interconnect_1x5.sv
${UNITS}/interconnects/wb/wb_interconnect_1x2.sv
${UNITS}/interconnects/axi4/axi4_wb_bridge.sv

${UNITS}/timer/timer.sv
${UNITS}/interrupt_controller/interrupt_controller.sv

${UNITS}/axi4_rom/axi4_rom.sv
${UNITS}/axi4_sram/axi4_sram.sv

${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv

${SYSTEMS}/a23_mini_sys/a23_mini_sys.sv
