#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
# TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

ESW_DIR ?= $(COMMON_SIM_MK_DIR)/../esw

ESW_UNIT_DIRS = uth_coop_thread_mgr uth uth_ucontext 
MK_INCLUDES += $(foreach dir,$(ESW_UNIT_DIRS), $(ESW_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
#MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=uth_coop_scheduler
TB=$(UNIT_VE)_tb


BFMS += $(foreach dir,$(ESW_UNIT_DIRS), $(shell echo $(dir) | tr [:lower:] [:upper:]))

#BFMS += SVF_AXI4_SRAM SVF_AXI4_ROM UART_BFM COMMON_SVF
#BFMS += A23_TRACER

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk

