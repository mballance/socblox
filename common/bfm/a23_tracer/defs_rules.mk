
UNIT_NAME := A23_TRACER
LIB_NAME := a23_tracer

A23_TRACER_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

$(UNIT_NAME)_SRC = \
	a23_tracer.cpp \
	a23_tracer_dpi_mgr.cpp
	

# Brings in rules to build the unit .so
include $(SOCBLOX)/common/common_unit_rules_defs.mk
	