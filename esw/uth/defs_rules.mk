
LIB_NAME := uth
UNIT_NAME := $(shell echo $(LIB_NAME) | tr [:lower:] [:upper:])

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	uth.cpp \
	uth_thread_mgr.cpp

# Brings in rules to build the unit .a
include $(SOCBLOX)/common/common_unit_rules_defs.mk
