
LIB_NAME := uth_a23
UNIT_NAME := $(shell echo $(LIB_NAME) | tr [:lower:] [:upper:])

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	uth_a23_thread_primitives.cpp 

# Brings in rules to build the unit .a
include $(SOCBLOX)/common/common_unit_rules_defs.mk
