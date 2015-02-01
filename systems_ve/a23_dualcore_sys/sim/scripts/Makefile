#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

UNIT_VE=a23_dualcore_sys

#* TODO: Uncomment to enable target build
TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

# TIMEOUT = 16ms
# TIMEOUT = 80ms
TIMEOUT = 5ms

BFMS += COMMON_SVF TIMEBASE A23_TRACER
BFMS += BIDI_MESSAGE_QUEUE_DIRECT_BFM
BFMS += GENERIC_ROM GENERIC_SRAM_BYTE_EN
BFMS += UART_BFM
BFMS += AXI4_MONITOR_BFM

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

# BFM_UNIT_DIRS := $(shell echo $(BFMS) | tr '[:upper:]' '[:lower:]')
BFM_UNIT_DIRS  = a23_tracer generic_rom uart generic_sram_byte_en timebase
BFM_UNIT_DIRS += bidi_message_queue_direct_bfm uart axi4_monitor
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(UNITS)/bidi_message_queue/sw/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

TB=$(UNIT_VE)_tb

SYNTH_UNITS += $(SYSTEMS)/a23_dualcore_sys


VERILATOR_TRACE_EN ?= 1

# SIM_DATAFILES += baremetal/smoke.mem

%.mem : $(BUILD_DIR)/%.mem
	cp $^ $@
	
baremetal/%.mem : $(BUILD_DIR)/baremetal/%.mem
	if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	cp $^ $@

include $(SOCBLOX)/common/common_sim.mk

