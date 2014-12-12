#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
# TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

TIMEOUT := 2ms

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

BFM_UNIT_DIRS = axi4_svf axi4_monitor \
                timebase
                
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../stim/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=axi4_l1_mem_subsys
TB=$(UNIT_VE)_tb

SYNTH_UNITS += $(UNITS)/axi4_l1_mem_subsystem

BFMS += COMMON_SVF
BFMS += SVF_AXI4_BFM 
BFMS += TIMEBASE AXI4_MONITOR_BFM

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk

