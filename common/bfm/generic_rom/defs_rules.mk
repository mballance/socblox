
UNIT_NAME := GENERIC_ROM
LIB_NAME := generic_rom

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	generic_rom_bfm.cpp \
	generic_rom_dpi_mgr.cpp \

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	
