
// Core RTL

+incdir+${COMMON_RTL}/axi4
${COMMON_RTL}/axi4/axi4_if.sv

// ${UNITS}/interconnects/axi4/axi4_interconnect_1x3.sv
${UNITS}/axi4_sram/axi4_sram.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
${UNITS}/axi4_l1_interconnect/axi4_l1_cache_2.sv
// ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect_2.sv
${UNITS}/axi4_l1_mem_unit/axi4_l1_mem_unit.sv
${UNITS}/axi4_l1_mem_unit/axi4_l1_mem_unit_top.sv
