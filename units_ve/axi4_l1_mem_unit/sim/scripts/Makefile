#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
# TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

TIMEOUT := 100us

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

BFM_UNIT_DIRS = axi4_svf
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../stim/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=axi4_l1_mem_unit
TB=$(UNIT_VE)_tb

SYNTH_UNITS = $(UNITS)/axi4_l1_mem_unit


BFMS += SVF_COMMON SVF_AXI4_BFM

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk

