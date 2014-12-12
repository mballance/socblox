
SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

# UNIT_NAME = axi4_l1_interconnect
TOP_MODULE = axi4_l1_mem_unit_top

SRC_DIRS += $(SCRIPTS_DIR)



include $(COMMON_DIR)/common_synth.mk
