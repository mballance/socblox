// Core RTL

+incdir+${COMMON_RTL}/axi4
${COMMON_RTL}/axi4/axi4_if.sv

${COMMON_RTL}/memory/generic_sram_line_en_if.sv
${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
${UNITS}/axi4_sram_bridges/axi4_generic_line_en_sram_bridge.sv
${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv

${UNITS}/hps2fpga_test/hps2fpga_test_top.sv
${UNITS}/hps2fpga_test/hps_master.v



// ${UNITS}/interconnects/axi4/axi4_interconnect_1x3.sv
// ${UNITS}/interconnects/axi4/axi4_interconnect_1x2.sv
// ${UNITS}/axi4_sram/axi4_sram.sv
// ${UNITS}/axi4_sram_bridges/axi4_generic_byte_en_sram_bridge.sv
// ${COMMON_RTL}/memory/generic_sram_byte_en_if.sv
// ${COMMON_RTL}/memory/generic_sram_byte_en_w.sv
// ${UNITS}/axi4_l1_interconnect/axi4_l1_cache_2.sv
// ${UNITS}/axi4_l1_interconnect/axi4_l1_interconnect_2.sv
// ${UNITS}/axi4_l1_mem_subsystem/axi4_l1_mem_subsystem.sv
// ${UNITS}/axi4_l1_mem_subsystem/axi4_l1_mem_subsystem_top.sv
${UNITS}/hps2fpga_test/submodules/altdq_dqs2_acv_connect_to_hard_phy_cyclonev.sv
${UNITS}/hps2fpga_test/submodules/altera_mem_if_dll_cyclonev.sv
${UNITS}/hps2fpga_test/submodules/altera_mem_if_hard_memory_controller_top_cyclonev.sv
${UNITS}/hps2fpga_test/submodules/altera_mem_if_hhp_qseq_synth_top.v
${UNITS}/hps2fpga_test/submodules/altera_mem_if_oct_cyclonev.sv
${UNITS}/hps2fpga_test/submodules/hps_master_hps_0_fpga_interfaces.sv
${UNITS}/hps2fpga_test/submodules/hps_master_hps_0_hps_io_border.sv
${UNITS}/hps2fpga_test/submodules/hps_master_hps_0_hps_io.v
${UNITS}/hps2fpga_test/submodules/hps_master_hps_0.v
${UNITS}/hps2fpga_test/submodules/hps_master_irq_mapper.sv
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_acv_hard_addr_cmd_pads.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_acv_hard_io_pads.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_acv_hard_memphy.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_acv_ldc.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_altdqdqs.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_clock_pair_generator.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_generic_ddio.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_iss_probe.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_phy_csr.sv
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_reset_sync.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0_reset.v
${UNITS}/hps2fpga_test/submodules/hps_sdram_p0.sv
${UNITS}/hps2fpga_test/submodules/hps_sdram_pll.sv
${UNITS}/hps2fpga_test/submodules/hps_sdram.v
