#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
# TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

BFM_UNIT_DIRS = a23_tracer axi4_svf_sram axi4_rom uart axi4_svf
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../stim/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=axi4_l1_interconnect_2
TB=$(UNIT_VE)_tb



BFMS += SVF_AXI4_SRAM SVF_AXI4_ROM UART_BFM COMMON_SVF
BFMS += A23_TRACER SVF_AXI4_BFM

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk

