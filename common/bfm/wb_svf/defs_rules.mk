
UNIT_NAME := WB_SVF_MASTER_BFM
LIB_NAME := wb_svf_master_bfm

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	wb_master_bfm.cpp \
	wb_master_bfm_dpi_mgr.cpp

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk

