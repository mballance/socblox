
${COMMON_RTL}/axi4/axi4_if.sv
${COMMON_RTL}/axi4/axi4_monitor.sv
${COMMON_RTL}/wb/wb_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv

-F ${UNITS}/axi4_a23/axi4_a23_f.F

${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${UNITS}/axi4_rom/axi4_rom.sv
${UNITS}/axi4_sram/axi4_sram.sv
${UNITS}/timer/timer.sv
${UNITS}/interrupt_controller/interrupt_controller.sv
${UNITS}/coreinfo/coreinfo_2.sv

${UNITS}/interconnects/axi4/axi4_interconnect_2x6.sv
${UNITS}/interconnects/wb/wb_interconnect_1x2.sv

${UNITS}/interconnects/axi4/axi4_wb_bridge.sv

a23_dualcore_sys.sv
