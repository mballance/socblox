
LIB_NAME := bidi_message_queue_drv_svf
UNIT_NAME := $(shell echo $(LIB_NAME) | tr [:lower:] [:upper:])

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	bidi_message_queue_drv_svf.cpp 

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	
