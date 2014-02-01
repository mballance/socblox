

UNIT_NAME := SVF_AXI4_SRAM
LIB_NAME := axi4_sram_bfm

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	axi4_svf_sram_bfm.cpp \
	axi4_svf_sram_dpi_mgr.cpp \

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
