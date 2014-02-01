
UNIT_NAME := SVF_AXI4_ROM
LIB_NAME := axi4_rom_bfm

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	axi4_svf_rom_bfm.cpp \
	axi4_svf_rom_dpi_mgr.cpp \

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	
