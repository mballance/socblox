
UNIT_NAME := COMMON_SVF
LIB_NAME := common_svf

COMMON_SVF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))


$(UNIT_NAME)_SRC=\
	svf_elf_loader.cpp
	
include $(SOCBLOX)/common/common_unit_rules_defs.mk

