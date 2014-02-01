
UNIT_NAME := UART_BFM
LIB_NAME := uart_bfm
UART_BFM_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC = \
	uart_bfm.cpp \
	uart_bfm_dpi_mgr.cpp

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
