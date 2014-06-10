
LIB_NAME := uth_coop_thread_mgr
UNIT_NAME := $(shell echo $(LIB_NAME) | tr [:lower:] [:upper:])

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	uth_coop_thread_mgr.cpp

# Brings in rules to build the unit .a
include $(SOCBLOX)/common/common_so_unit_rules_defs.mk
