
UNIT_NAME := GENERIC_SRAM_BYTE_EN
LIB_NAME := generic_sram_byte_en

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	generic_sram_byte_en_bfm.cpp \
	generic_sram_byte_en_dpi_mgr.cpp \

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	
