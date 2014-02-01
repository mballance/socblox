

UNIT_NAME := SVF_AXI4_BFM
LIB_NAME := axi4_svf_bfm

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	axi4_master_bfm.cpp \
	axi4_master_bfm_dpi_mgr.cpp

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
