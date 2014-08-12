#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

TIMEOUT = 500us

BFMS += UART_BFM COMMON_SVF GENERIC_ROM GENERIC_SRAM_BYTE_EN
BFMS += A23_TRACER

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

# BFM_UNIT_DIRS := $(shell echo $(BFMS) | tr '[:upper:]' '[:lower:]')
BFM_UNIT_DIRS = a23_tracer axi4_svf_sram generic_rom uart generic_sram_byte_en
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=a23_mini_sys
TB=$(UNIT_VE)_tb




VERILATOR_TRACE_EN ?= 1

SIM_DATAFILES += baremetal/smoke.mem

%.mem : $(BUILD_DIR)/%.mem
	cp $^ $@
	
baremetal/%.mem : $(BUILD_DIR)/baremetal/%.mem
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	cp $^ $@

include $(SOCBLOX)/common/common_sim.mk

