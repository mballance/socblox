
LIB_NAME := axi4_monitor_bfm
UNIT_NAME := $(shell echo $(LIB_NAME) | tr [:lower:] [:upper:])

$(UNIT_NAME)_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC := \
	axi4_monitor_bfm.cpp \
	axi4_monitor_bfm_dpi_mgr.cpp \
	axi4_monitor_transaction.cpp \
	axi4_monitor_stream_logger.cpp \
	axi4_monitor_transaction_producer.cpp

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	
